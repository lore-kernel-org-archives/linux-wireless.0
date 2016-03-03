Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56475 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754888AbcCCPOy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 10:14:54 -0500
Message-ID: <1457018090.2044.20.camel@sipsolutions.net> (sfid-20160303_161538_298810_4D35EA11)
Subject: Re: [PATCH] mac80211: fix AP buffered multicast frames with queue
 control and txq
From: Johannes Berg <johannes@sipsolutions.net>
To: Dave Taht <dave.taht@gmail.com>, Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 03 Mar 2016 16:14:50 +0100
In-Reply-To: <CAA93jw5Vk1-1AcawzQxNT1Re9EsMPUK220A5WsxS6MhX3VJQBQ@mail.gmail.com> (sfid-20160228_183522_530668_22E40833)
References: <1456669193-56860-1-git-send-email-nbd@openwrt.org>
	 <CAA93jw5Vk1-1AcawzQxNT1Re9EsMPUK220A5WsxS6MhX3VJQBQ@mail.gmail.com>
	 (sfid-20160228_183522_530668_22E40833)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2016-02-28 at 09:35 -0800, Dave Taht wrote:
> On Sun, Feb 28, 2016 at 6:19 AM, Felix Fietkau <nbd@openwrt.org>
> wrote:
> > Buffered multicast frames must be passed to the driver directly via
> > drv_tx instead of going through the txq, otherwise they cannot
> > easily be
> > scheduled to be sent after DTIM.
> > 
> > Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> > ---
> >  net/mac80211/tx.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> > index 3a7475f..b294820 100644
> > --- a/net/mac80211/tx.c
> > +++ b/net/mac80211/tx.c
> > @@ -1247,7 +1247,8 @@ static void ieee80211_drv_tx(struct
> > ieee80211_local *local,
> >         struct txq_info *txqi;
> >         u8 ac;
> > 
> > -       if (info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE)
> > +       if ((info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) ||
> > +           (info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE))
> >                 goto tx_normal;
> > 
> >         if (!ieee80211_is_data(hdr->frame_control))
> > --
> > 2.2.2
> 
> I would like 

Feel free to propose patches for anything you like :)

johannes
> 
