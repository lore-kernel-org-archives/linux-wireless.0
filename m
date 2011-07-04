Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56102 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab1GDKey convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2011 06:34:54 -0400
Received: by ywe9 with SMTP id 9so1911759ywe.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jul 2011 03:34:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1309758467-1712-5-git-send-email-nbd@openwrt.org>
References: <1309758467-1712-1-git-send-email-nbd@openwrt.org>
	<1309758467-1712-2-git-send-email-nbd@openwrt.org>
	<1309758467-1712-3-git-send-email-nbd@openwrt.org>
	<1309758467-1712-4-git-send-email-nbd@openwrt.org>
	<1309758467-1712-5-git-send-email-nbd@openwrt.org>
Date: Mon, 4 Jul 2011 13:34:53 +0300
Message-ID: <CAFtRNNy9AK0BUShq+U6Pvk-qtMLttkWSUBB4p9A9EgWLvQ=g7w@mail.gmail.com> (sfid-20110704_123457_949771_1F7B5D1A)
Subject: Re: [ath5k-devel] [PATCH 5/8] ath5k: delay full calibration after reset
From: Nick Kossifidis <mickflemm@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/7/4 Felix Fietkau <nbd@openwrt.org>:
> During scans the full calibration usually does not make much sense,
> PAPD probing and IQ calibration should be deferred until there is
> enough time to complete them. Adding 100 ms to the initial full
> calibration delay should be enough to do this.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath5k/base.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index a413aa7..efec14f 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -2728,7 +2728,7 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan,
>
>        ath5k_ani_init(ah, ani_mode);
>
> -       ah->ah_cal_next_full = jiffies;
> +       ah->ah_cal_next_full = jiffies + msecs_to_jiffies(100);
>        ah->ah_cal_next_ani = jiffies;
>        ah->ah_cal_next_nf = jiffies;
>        ewma_init(&ah->ah_beacon_rssi_avg, 1024, 8);
> --
> 1.7.3.2
>

BTW have you checked this one ->
http://www.kernel.org/pub/linux/kernel/people/mickflemm/calibtest.patch
?

Acked-by: Nick Kossifidis <mickflemm@gmail.com>



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
