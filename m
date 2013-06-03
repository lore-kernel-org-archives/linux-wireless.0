Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53756 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758040Ab3FCP2Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 11:28:16 -0400
Message-ID: <1370273291.8227.24.camel@jlt4.sipsolutions.net> (sfid-20130603_172819_298282_289A2027)
Subject: Re: [PATCH v2 2/2] cfg80211/nl80211: Add packet coalesce support
From: Johannes Berg <johannes@sipsolutions.net>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Bing Zhao <bzhao@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Luciano Coelho <coelho@ti.com>
Date: Mon, 03 Jun 2013 17:28:11 +0200
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF5950F313C2CA5@SC-VEXCH1.marvell.com> (sfid-20130528_182605_492892_8E269C06)
References: <5FF020A1CFFEEC49BD1E09530C4FF5950F313C2CA5@SC-VEXCH1.marvell.com>
	 (sfid-20130528_182605_492892_8E269C06)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

sorry for the late reply. I did see you sent another version, but wanted
to comment here anyway.

> > This is curious, you already discard those that you don't care about by
> > way of multicast filtering, no? What's the added advantage here? Would
> > you coalesce interrupts for those packets that pass the filter(s)?
> 
> Yes. we don't want to simply discard those packets, because few of
> them may be useful for the host.
> The advantage here is instead of getting random per packet receive
> interrupts, host receives multiple buffered packets with a single
> receive interrupt.

I guess that makes some sense.

> > Actually, you should probably make that a pointer, then it can be NULL
> > for drivers not supporting it, and static const for those that do. Means
> > you should make it a const pointer, of course.
> > 
> > Userspace can tell by checking if the support is advertised.
> 
> We will use following condition to check if driver is not supporting
> the feature. (wowlan code does the same thing)
> 
> "if (!dev->wiphy.coalesce.n_patterns || !dev->wiphy.coalesce.n_rules)"

Hmm. I think wowlan should probably be changed though, no need to make
the struct larger just for this, right? Not all drivers are going to
support it.

For WoWLAN I'm going to apply this:
http://p.sipsolutions.net/fa808e0722a7624a.txt

> > This is bad. You leave rdev->coalesce assigned, but it's completely
> > invalid data. IMHO you should use a temporary variable and only assign
> > it when it's fully parsed, freeing it if not. That way, you also don't
> > kill old values when new invalid values are parsed.
> 
> "iw coalesce add" command adds one coalesce rule at a time. "iw
> coalesce disable" command removes all configured rules.

Can you please change this to "iw coalesce set" and make it set all the
rules in one? Otherwise you're going to have very awkward races and need
to always clear etc. The code would also be easier, though obviously
you'd need to be able to specify multiple rules at the same time.

johannes

