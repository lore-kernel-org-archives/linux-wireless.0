Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49677 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab2GFHPt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 03:15:49 -0400
Message-ID: <1341558944.4462.9.camel@jlt3.sipsolutions.net> (sfid-20120706_091553_207247_08BAB338)
Subject: Re: v3.4.4 ath9k: kernel NULL pointer dereference in skb_dequeue
 during heavy udp xmit
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Chant <andrew.chant@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Date: Fri, 06 Jul 2012 09:15:44 +0200
In-Reply-To: <CANugF37dDx1mvNJ-Y3is6OaeVFD1KwH=yh8Xef2BrN=YQPsiZQ@mail.gmail.com> (sfid-20120706_063735_542275_72C9855A)
References: <CANugF35YQzs7gi4htrgCUKrTDp_ia0RUo9g_HNJ=CzfnOCkO2g@mail.gmail.com>
	 <CANugF37dDx1mvNJ-Y3is6OaeVFD1KwH=yh8Xef2BrN=YQPsiZQ@mail.gmail.com>
	 (sfid-20120706_063735_542275_72C9855A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-John
+QCA folks

On Thu, 2012-07-05 at 21:36 -0700, Andrew Chant wrote:

>  while performance testing ath9k -> ath9k performance in 3.4.4, I got
> a nasty kernel panic.  My performance testing involved filling the air
> with 1410-byte UDP packets between the machines, and switching the
> frequencies of the two cards to see how frequency affected
> performance.  I had switched between channels 36, 40, 44, and 48.
> Oops was on the transmitting machine, which was acting as the AP.
> 
> Very clear screen image of the oops is at
> https://picasaweb.google.com/lh/photo/CjBdHLZH0up5PrnmCySJidMTjNZETYmyPJy0liipFm0?feat=directlink

I briefly looked at this, but I don't see a bug in mac80211. It seems
likely that ath9k hands back a corrupted SKB, or frees one it no longer
owns, or such. The skb->next/prev pointers seem corrupted (rcx is NULL)
in one of the SKBs on the list, but mac80211 can't do that afaict.

johannes

