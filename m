Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65448 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab0JFBS2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 21:18:28 -0400
Received: by iwn5 with SMTP id 5so9028912iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Oct 2010 18:18:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101005095521.3083.87663.stgit@tt-desk>
References: <20101005095510.3083.46174.stgit@tt-desk> <20101005095521.3083.87663.stgit@tt-desk>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 5 Oct 2010 18:18:07 -0700
Message-ID: <AANLkTin5r7ig7-h9DRjwGrei9R5-CL6gW7kcBNKWP2Rs@mail.gmail.com>
Subject: Re: [PATCH 3/5] ath9k: Use common cycle counters
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, nbd@openwrt.org,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	adrian@freebsd.org, vasanth@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 5, 2010 at 2:55 AM, Bruno Randolf <br1@einfach.org> wrote:
> Update ath9k to use the common cycle counters.
>
> This also includes other changes from Felix Fietkaus "[PATCH 2/4] ath9k_hw:
> merge codepaths that access the cycle counter registers".
>
> Compile tested only. ath9k team please review...
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> ---
>  drivers/net/wireless/ath/ath9k/ani.c        |   87 +++------------------------
>  drivers/net/wireless/ath/ath9k/ani.h        |    6 --
>  drivers/net/wireless/ath/ath9k/ar5008_phy.c |    9 +--
>  drivers/net/wireless/ath/ath9k/ar9003_phy.c |   18 +++---
>  4 files changed, 22 insertions(+), 98 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
> index 0496f96..0c0d01d 100644
> --- a/drivers/net/wireless/ath/ath9k/ani.c
> +++ b/drivers/net/wireless/ath/ath9k/ani.c
> @@ -549,47 +549,21 @@ static u8 ath9k_hw_chan_2_clockrate_mhz(struct ath_hw *ah)
>
>  static int32_t ath9k_hw_ani_get_listen_time(struct ath_hw *ah)
>  {
> -       struct ar5416AniState *aniState;
>        struct ath_common *common = ath9k_hw_common(ah);
> -       u32 txFrameCount, rxFrameCount, cycleCount;
> -       int32_t listenTime;
> +       int32_t listen_time;
> +       int32_t clock_rate;
>
> -       txFrameCount = REG_READ(ah, AR_TFCNT);
> -       rxFrameCount = REG_READ(ah, AR_RFCNT);
> -       cycleCount = REG_READ(ah, AR_CCCNT);
> +       ath_hw_cycle_counters_lock(common);

Note the lock call here. This is what I'd like to see avoided. Can you
perhaps have the lock called within the core driver instead, that is,
add the lock call for the caller of ath9k_hw_ani_get_listen_time(). In
this case I see ath9k_hw_ani_get_listen_time() is static though and so
is its caller but ultimately we get to ath9k_hw_ani_monitor(). What
I'm saying is how about calling the
ath_hw_cycle_counters_lock(common); right before
ath9k_hw_ani_monitor().

> +       ath_hw_cycle_counters_update(common);

  Luis
