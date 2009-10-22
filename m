Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:56168 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbZJVDmW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2009 23:42:22 -0400
Received: by iwn8 with SMTP id 8so3927398iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2009 20:42:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1255934026-20686-1-git-send-email-lrodriguez@atheros.com>
References: <1255934026-20686-1-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 22 Oct 2009 12:42:07 +0900
Message-ID: <43e72e890910212042i6a6a1bc3h1cd2a742f462353f@mail.gmail.com>
Subject: Re: [RFT 00/15] ath9k_hw ar9271 updates & AR5416 force bias
To: linux-wireless@vger.kernel.org,
	Sujith <Sujith.Manoharan@atheros.com>
Cc: ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 19, 2009 at 3:33 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> This series started off to extend support for ar9271 on ath9k_hw
> but after review of the phy related code I noticed a fix for
> AR5416 was only partially being implemented and used for all
> chipsets. This series then adds the changes I've noticed so far
> required for ar9271 but also fixes and completes the orientation
> fix for AR5416 (force bias). Since I'm touching phy.c I also extend
> documentation for it.
>
> I don't have AR9285 cards with me but I do have an AR5416 cardbus
> card -- I'd appreciate it if someone can give this a test on AR9285
> but also more AR5416 cards -- this should help with TX on of AR5416
> and AR5418 on the 2.4 GHz band.
>
> Reports on issues or performance differences are greatly appreciated;
> the only issue I'd expect you'd see on non AR5416 hardware is a BUG_ON()
> which would be very obvious to notice and the performance enhancements
> should be seen on AR5416 for TX -- not yet sure exactly under what
> circumstances.
>
> Luis R. Rodriguez (15):
>  ath9k_hw: modify the rf control register for ar9271 revision 1.0
>  ath9k_hw: update register initialization/reset values for ar9271
>  ath9k_hw: change the way we initialize the pll for ar9271
>  ath9k_hw: start documenting 802.11n RF anlong front ends
>  ath9k_hw: bail out early on ath9k_hw_init_rf()
>  ath9k_hw: simplify rf attach and rename to
>    ath9k_hw_rf_alloc_ext_banks()
>  ath9k_hw: simplify ath9k_hw_rf_alloc_ext_banks()
>  ath9k_hw: rename ath9k_hw_rf_free() to ath9k_hw_rf_free_ext_banks()
>  ath9k_hw: make both analog channel change routines return int
>  ath9k_hw: use a callback for frequency change
>  ath9k_hw: order phy.c code and integrate spur mitigation
>  ath9k_hw: make spur mitigation a callback
>  ath9k_hw: remove unused modesIndex param from ath9k_hw_write_regs()
>  ath9k_hw: Fix and complete force bias for AR5416
>  ath9k_hw: make ath9k_phy_modify_rx_buffer() static

Omni-patch:

http://bombadil.infradead.org/~mcgrof/patches/all/all-2009-10-19.patch

  Luis
