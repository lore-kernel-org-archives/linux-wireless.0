Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:45747 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab0CIMSm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 07:18:42 -0500
Received: by ewy8 with SMTP id 8so654430ewy.28
        for <linux-wireless@vger.kernel.org>; Tue, 09 Mar 2010 04:18:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100309075549.30616.4609.stgit@void>
References: <20100309075124.30616.40896.stgit@void>
	 <20100309075549.30616.4609.stgit@void>
Date: Tue, 9 Mar 2010 14:18:41 +0200
Message-ID: <40f31dec1003090418p479ff97bpdaadee407a6416be@mail.gmail.com>
Subject: Re: [PATCH 07/13] ath5k: remove ah_mac_revision
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/3/9 Bruno Randolf <br1@einfach.org>:
> it's not used, and we have ah_mac_srev.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> ---
>  drivers/net/wireless/ath/ath5k/ath5k.h  |    1 -
>  drivers/net/wireless/ath/ath5k/attach.c |    1 -
>  2 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
> index 3d63511..54f35ae 100644
> --- a/drivers/net/wireless/ath/ath5k/ath5k.h
> +++ b/drivers/net/wireless/ath/ath5k/ath5k.h
> @@ -1047,7 +1047,6 @@ struct ath5k_hw {
>        u32                     ah_phy;
>        u32                     ah_mac_srev;
>        u16                     ah_mac_version;
> -       u16                     ah_mac_revision;
>        u16                     ah_phy_revision;
>        u16                     ah_radio_5ghz_revision;
>        u16                     ah_radio_2ghz_revision;
> diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
> index 66758cb..dd4099a 100644
> --- a/drivers/net/wireless/ath/ath5k/attach.c
> +++ b/drivers/net/wireless/ath/ath5k/attach.c
> @@ -148,7 +148,6 @@ int ath5k_hw_attach(struct ath5k_softc *sc)
>        /* Get MAC, PHY and RADIO revisions */
>        ah->ah_mac_srev = srev;
>        ah->ah_mac_version = AR5K_REG_MS(srev, AR5K_SREV_VER);
> -       ah->ah_mac_revision = AR5K_REG_MS(srev, AR5K_SREV_REV);
>        ah->ah_phy_revision = ath5k_hw_reg_read(ah, AR5K_PHY_CHIP_ID) &
>                        0xffffffff;
>        ah->ah_radio_5ghz_revision = ath5k_hw_radio_revision(ah,
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
