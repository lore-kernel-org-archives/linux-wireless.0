Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:32487 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753884AbXKSEPi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Nov 2007 23:15:38 -0500
From: bruno randolf <bruno@thinktube.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] ath5k: consistent info and error logging
Date: Mon, 19 Nov 2007 13:01:06 +0900
Cc: Kalle Valo <Kalle.Valo@nokia.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
References: <1195200656-25847-1-git-send-email-bruno@thinktube.com> <87mytez5vs.fsf@nokia.com> <1195228438.8147.146.camel@johannes.berg>
In-Reply-To: <1195228438.8147.146.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200711191301.06366.bruno@thinktube.com> (sfid-20071119_041544_098215_93E6AE17)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 17 November 2007 00:53:58 Johannes Berg wrote:
> On Fri, 2007-11-16 at 15:17 +0200, Kalle Valo wrote:
> > Johannes Berg <johannes@sipsolutions.net> writes:
> > >> +#define AR5K_INFO(_sc, _fmt, ...)	\
> > >> +	printk(KERN_INFO "ath5k %s: " _fmt, wiphy_name((_sc)->hw->wiph=
y),
> > >> ##__VA_ARGS__)
> > >
> > > Eww. Can't you make them static inlines?
> >
> > Wasn't it so that a inline function with va_args is not possible?
>
> Hmm. That might be true.=20

yes, gcc tells me
"sorry, unimplemented: function =E2=80=98AR5K_INFO=E2=80=99 can never b=
e inlined because it=20
uses variable argument lists".

> How about just using dev_dbg?=20

i thought about that, and it would be possible to change the macros to =
use=20
dev_dbg, dev_info, etc, but i think the phyX names make the output much=
=20
clearer and easier to match with the output from mac80211, than the PCI=
 bus=20
ids.

> Not that I really =20
> ever need to look into ath5k (hopefully!), but the code just struck m=
e
> as not very nice.

well, it's not *that* bad, and defines like this are used in many place=
s in=20
the kernel. for example rt2x00/rt2x00.h has basically the same define.

bruno
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
