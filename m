Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43455 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932394AbZJHOqp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2009 10:46:45 -0400
Date: Thu, 8 Oct 2009 10:43:52 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	reinette chatre <reinette.chatre@intel.com>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: NULL pointer deref at wext ioctl (Re: [PATCH] compat-2.6:
	adding ethtool.h to compat-2.6.31.h)
Message-ID: <20091008144352.GA2869@tuxdriver.com>
References: <3ace41890910071216y69b8bc9la67b8f0ce5890cd8@mail.gmail.com> <3ace41890910071228i786d4097w69dc7a3dfeb64afe@mail.gmail.com> <1254952886.3713.4.camel@johannes.local> <3ace41890910072328n1460ee34v1fe7ca9b78eb646f@mail.gmail.com> <1254995514.3713.22.camel@johannes.local> <1255002647.3713.25.camel@johannes.local> <43e72e890910080643h282c4bf1xf972f15f13eae755@mail.gmail.com> <43e72e890910080728ra63f1e7w6be3a2af65bc4766@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <43e72e890910080728ra63f1e7w6be3a2af65bc4766@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 08, 2009 at 10:28:33AM -0400, Luis R. Rodriguez wrote:
> On Thu, Oct 8, 2009 at 9:43 AM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > On Thu, Oct 8, 2009 at 7:50 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> >> On Thu, 2009-10-08 at 11:51 +0200, Johannes Berg wrote:
> >>
> >>> Ok, that's odd. Is it possible that somehow cfg80211 is picking up an
> >>> #ifdef'ed copy of "struct iw_handler_def", and thus the struct it is
> >>> defining is simply too small?
> >>
> >> That is apparently what is happening since compat-wireless ships
> >> iw_handler.h. This is wrong, as wext functionality is built into the
> >> kernel image so you can't use a newer header file with it.
> >
> > Dah, thanks for looking into this! This must've been there this way
> > for ages and we hadn't noticed until now. This is now fixed, and a new
> > tarball pushed out. I'll fix on the stable stuff as well, although I
> > doubt the header has changed much except now.
> 
> OK so iw_handler added the libipw pointer, so libipw and friends are
> now messed up on compat-wireless. Do we care? I'll disable them for
> now. Can't think of a way to backport this easily.
> 
>   CC [M]  /home/mcgrof/devel/compat-wireless-2.6/drivers/net/wireless/ipw2x00/ipw2100.o
> /home/mcgrof/devel/compat-wireless-2.6/drivers/net/wireless/ipw2x00/ipw2100.c:
> In function ‘ipw2100_alloc_device’:
> /home/mcgrof/devel/compat-wireless-2.6/drivers/net/wireless/ipw2x00/ipw2100.c:6060:
> error: ‘struct iw_public_data’ has no member named ‘libipw’
> make[4]: *** [/home/mcgrof/devel/compat-wireless-2.6/drivers/net/wireless/ipw2x00/ipw2100.o]
> Error 1

-       /* Structure managed by the in-kernel IEEE 802.11 layer */
-       struct ieee80211_device *       ieee80211;
+       /* Legacy structure managed by the ipw2x00-specific IEEE 802.11 layer */
+       struct libipw_device *          libipw;

Really just a name change, FWIW...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
