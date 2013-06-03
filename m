Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:46312 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759541Ab3FCQxP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 12:53:15 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: 'Johannes Berg' <johannes@sipsolutions.net>
CC: Bing Zhao <bzhao@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Luciano Coelho <coelho@ti.com>
Date: Mon, 3 Jun 2013 09:47:43 -0700
Subject: RE: [PATCH v2 2/2] cfg80211/nl80211: Add packet coalesce support
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF5950F313C2CB5@SC-VEXCH1.marvell.com> (sfid-20130603_185324_161464_C13FF38D)
In-Reply-To: <1370273291.8227.24.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> Hi,
> 
> sorry for the late reply. I did see you sent another version, but wanted
> to comment here anyway.
> 
> > > This is curious, you already discard those that you don't care about
> by
> > > way of multicast filtering, no? What's the added advantage here? Would
> > > you coalesce interrupts for those packets that pass the filter(s)?
> >
> > Yes. we don't want to simply discard those packets, because few of
> > them may be useful for the host.
> > The advantage here is instead of getting random per packet receive
> > interrupts, host receives multiple buffered packets with a single
> > receive interrupt.
> 
> I guess that makes some sense.
> 
> > > Actually, you should probably make that a pointer, then it can be NULL
> > > for drivers not supporting it, and static const for those that do.
> Means
> > > you should make it a const pointer, of course.
> > >
> > > Userspace can tell by checking if the support is advertised.
> >
> > We will use following condition to check if driver is not supporting
> > the feature. (wowlan code does the same thing)
> >
> > "if (!dev->wiphy.coalesce.n_patterns || !dev->wiphy.coalesce.n_rules)"
> 
> Hmm. I think wowlan should probably be changed though, no need to make
> the struct larger just for this, right? Not all drivers are going to
> support it.
> 
> For WoWLAN I'm going to apply this:
> http://p.sipsolutions.net/fa808e0722a7624a.txt
> 

This looks good. We don't need to unnecessarily allocate space in wiphy. We will make similar changes for coalesce.

> > > This is bad. You leave rdev->coalesce assigned, but it's completely
> > > invalid data. IMHO you should use a temporary variable and only assign
> > > it when it's fully parsed, freeing it if not. That way, you also don't
> > > kill old values when new invalid values are parsed.
> >
> > "iw coalesce add" command adds one coalesce rule at a time. "iw
> > coalesce disable" command removes all configured rules.
> 
> Can you please change this to "iw coalesce set" and make it set all the
> rules in one?

"iw coalesce add" was used, because command for adding multiple rules at the same time will be a bit lengthy(user will need to enter multiple lists of packet patterns) and syntax check in iw will also need some efforts. 

> Otherwise you're going to have very awkward races and need
> to always clear etc. The code would also be easier, though obviously
> you'd need to be able to specify multiple rules at the same time.

For "iw coalesce set" also user needs to always clear the settings using "iw coalesce disable". Also similar to "coalesce set", for "coalesce add" we clear the settings and free allocations while unloading the driver.

Please let us know if you prefer "coalesce set" over "coalesce add".

Thanks,
Amit

> 
> johannes

