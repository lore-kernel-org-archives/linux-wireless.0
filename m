Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:51285 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530Ab1DSLwr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 07:52:47 -0400
Received: by wyb42 with SMTP id 42so5521306wyb.4
        for <linux-wireless@vger.kernel.org>; Tue, 19 Apr 2011 04:52:45 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: use 2 spare TX blocks for GEM cipher
From: Luciano Coelho <coelho@ti.com>
To: Guy Eilam <guy@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <BANLkTimtZaGTcouKvKS+cEfU=G6c6b775w@mail.gmail.com>
References: <1301834245-16679-1-git-send-email-guy@wizery.com>
	 <1302284338.2031.21.camel@pimenta>
	 <BANLkTimtZaGTcouKvKS+cEfU=G6c6b775w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Apr 2011 14:55:05 +0300
Message-ID: <1303214105.1988.679.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-04-12 at 08:03 +0300, Guy Eilam wrote:
> On Fri, Apr 8, 2011 at 8:38 PM, Luciano Coelho <coelho@ti.com> wrote:
> > On Sun, 2011-04-03 at 15:37 +0300, Guy Eilam wrote:
> >> diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
> >> index db9e47e..2c79b6e 100644
> >> --- a/drivers/net/wireless/wl12xx/tx.c
> >> +++ b/drivers/net/wireless/wl12xx/tx.c
> >> @@ -135,12 +135,10 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
> >>       u32 len;
> >>       u32 total_blocks;
> >>       int id, ret = -EBUSY;
> >> -     u32 spare_blocks;
> >> +     u32 spare_blocks = wl->tx_spare_blocks;
> >>
> >>       if (unlikely(wl->quirks & WL12XX_QUIRK_USE_2_SPARE_BLOCKS))
> >>               spare_blocks = 2;
> >> -     else
> >> -             spare_blocks = 1;
> >
> > Do we still need the quirk now? Wouldn't it be nicer to change the
> > wl->tx_spare_blocks value directly instead?
> >
> 
> We still need the quirk because if we change the tx_spare_blocks
> directly, then the
> we also need to have a tx_spare_blocks_previously member so that the KEY_GEM
> code will know the value to set in KEY_REMOVAL.
> Do you really think that it is better?

No, indeed this sounds more complicated, so you can keep it as it is.

-- 
Cheers,
Luca.

