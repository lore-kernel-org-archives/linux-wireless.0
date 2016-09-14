Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42363 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762923AbcINOZg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 10:25:36 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "greearb@candelatech.com" <greearb@candelatech.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 11/21] ath10k: add fw-powerup-fail to ethtool stats.
Date: Wed, 14 Sep 2016 14:25:26 +0000
Message-ID: <87fup2eey2.fsf@kamboji.qca.qualcomm.com> (sfid-20160914_162550_734609_CD76BA8D)
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
        <1462986153-16318-12-git-send-email-greearb@candelatech.com>
In-Reply-To: <1462986153-16318-12-git-send-email-greearb@candelatech.com>
        (greearb@candelatech.com's message of "Wed, 11 May 2016 10:02:23        -0700")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> This gives user-space a normal-ish way to detect that
> firmware has failed to start and that a reboot is
> probably required.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  drivers/net/wireless/ath/ath10k/core.h  | 1 +
>  drivers/net/wireless/ath/ath10k/debug.c | 2 ++
>  drivers/net/wireless/ath/ath10k/pci.c   | 2 ++
>  3 files changed, 5 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireles=
s/ath/ath10k/core.h
> index 6aa7a14..e7c228a 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -698,6 +698,7 @@ struct ath10k {
> =20
>  	enum ath10k_hw_rev hw_rev;
>  	u16 dev_id;
> +	bool fw_powerup_failed; /* If true, might take reboot to recover. */
>  	u32 chip_id;
>  	u32 target_version;
>  	u8 fw_version_major;
> diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wirele=
ss/ath/ath10k/debug.c
> index 76b5163..05b5ea4 100644
> --- a/drivers/net/wireless/ath/ath10k/debug.c
> +++ b/drivers/net/wireless/ath/ath10k/debug.c
> @@ -1541,6 +1541,7 @@ static const char ath10k_gstrings_stats[][ETH_GSTRI=
NG_LEN] =3D {
>  	"d_fw_crash_count",
>  	"d_fw_warm_reset_count",
>  	"d_fw_cold_reset_count",
> +	"d_fw_powerup_failed", /* boolean */
>  };
> =20
>  #define ATH10K_SSTATS_LEN ARRAY_SIZE(ath10k_gstrings_stats)
> @@ -1640,6 +1641,7 @@ void ath10k_debug_get_et_stats(struct ieee80211_hw =
*hw,
>  	data[i++] =3D ar->stats.fw_crash_counter;
>  	data[i++] =3D ar->stats.fw_warm_reset_counter;
>  	data[i++] =3D ar->stats.fw_cold_reset_counter;
> +	data[i++] =3D ar->fw_powerup_failed;
> =20
>  	spin_unlock_bh(&ar->data_lock);
> =20
> diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless=
/ath/ath10k/pci.c
> index dbf0db8..2adc459 100644
> --- a/drivers/net/wireless/ath/ath10k/pci.c
> +++ b/drivers/net/wireless/ath/ath10k/pci.c
> @@ -2709,10 +2709,12 @@ static int ath10k_pci_hif_power_up(struct ath10k =
*ar)
>  		goto err_ce;
>  	}
> =20
> +	ar->fw_powerup_failed =3D false;
>  	return 0;
> =20
>  err_ce:
>  	ath10k_pci_ce_deinit(ar);
> +	ar->fw_powerup_failed =3D true;
> =20
>  err_sleep:
>  	return ret;

I didn't test myself, but if the firmware boot fails during module load
we should return an error and the module would fail to load (and hence
no network interface available). And if the firmware boot fails during
the interface up call (mac80211 calling ath10k_start()) we should return
an error and the interface would stay down. IMHO that's enough of
indications to the user space, I don't see how providing this boolean
via ethtool stats is really needed.

--=20
Kalle Valo=
