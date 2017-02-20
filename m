Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21533 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750872AbdBTFIx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Feb 2017 00:08:53 -0500
From: "Raja, Tamizh Chelvam" <c_traja@qti.qualcomm.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCHv2] ath10k: Update available channel list for 5G radio
Date: Mon, 20 Feb 2017 05:07:53 +0000
Message-ID: <675b9586e5bb47908a46c0155a428232@aphydexm01f.ap.qualcomm.com> (sfid-20170220_060856_016219_6CAD981F)
References: <1487567190-18243-1-git-send-email-c_traja@qti.qualcomm.com>
In-Reply-To: <1487567190-18243-1-git-send-email-c_traja@qti.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please ignore this patch:(

> -----Original Message-----
> From: Raja, Tamizh Chelvam
> Sent: Monday, February 20, 2017 10:37 AM
> To: ath10k@lists.infradead.org
> Cc: linux-wireless@vger.kernel.org; Raja, Tamizh Chelvam
> <c_traja@qti.qualcomm.com>
> Subject: [PATCHv2] ath10k: Update available channel list for 5G radio
>=20
> From: Tamizh chelvam <c_traja@qti.qualcomm.com>
>=20
> If a 5 GHz radio is calibrated for operation in both the low band (channe=
ls 36 to
> 64) and high band(channels 100 to 169), hardware allows operations in all=
 the
> listed channels. However, if the chip has been calibrated only for the lo=
w/high
> band and a high/low band channel is configured, due to lack of calibratio=
n
> there will be potentially invalid signal on those non calibrated channels=
.
> To avoid this problem this patch introduces ath10k_low_5ghz_channel and
> ath10k_high_5ghz_channel lists as separate arrays.
> The channel list will be initialized depending on the low_5ghz_chan and
> high_5ghz_chan values which we get from target through wmi service ready
> event.
>=20
> Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
> ---
> v2:
>   * Addressed Jouni and Kalle's comments
>=20
>  drivers/net/wireless/ath/ath10k/core.h |    2 ++
>  drivers/net/wireless/ath/ath10k/mac.c  |   55
> +++++++++++++++++++++++++++++---
>  drivers/net/wireless/ath/ath10k/wmi.c  |    6 ++++
>  drivers/net/wireless/ath/ath10k/wmi.h  |    2 ++
>  4 files changed, 61 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/wireless/ath/ath10k/core.h
> b/drivers/net/wireless/ath/ath10k/core.h
> index 88d14be..d07d567 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -774,6 +774,8 @@ struct ath10k {
>  	u32 vht_cap_info;
>  	u32 num_rf_chains;
>  	u32 max_spatial_stream;
> +	u32 low_5ghz_chan;
> +	u32 high_5ghz_chan;
>  	/* protected by conf_mutex */
>  	bool ani_enabled;
>=20
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c
> b/drivers/net/wireless/ath/ath10k/mac.c
> index 3029f25..0840efb 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -7623,6 +7623,38 @@ static void
> ath10k_mac_op_sta_pre_rcu_remove(struct ieee80211_hw *hw,
>  	CHAN2G(14, 2484, 0),
>  };
>=20
> +static const struct ieee80211_channel ath10k_low_5ghz_channels[] =3D {
> +	CHAN5G(36, 5180, 0),
> +	CHAN5G(40, 5200, 0),
> +	CHAN5G(44, 5220, 0),
> +	CHAN5G(48, 5240, 0),
> +	CHAN5G(52, 5260, 0),
> +	CHAN5G(56, 5280, 0),
> +	CHAN5G(60, 5300, 0),
> +	CHAN5G(64, 5320, 0),
> +};
> +
> +static const struct ieee80211_channel ath10k_high_5ghz_channels[] =3D {
> +	CHAN5G(100, 5500, 0),
> +	CHAN5G(104, 5520, 0),
> +	CHAN5G(108, 5540, 0),
> +	CHAN5G(112, 5560, 0),
> +	CHAN5G(116, 5580, 0),
> +	CHAN5G(120, 5600, 0),
> +	CHAN5G(124, 5620, 0),
> +	CHAN5G(128, 5640, 0),
> +	CHAN5G(132, 5660, 0),
> +	CHAN5G(136, 5680, 0),
> +	CHAN5G(140, 5700, 0),
> +	CHAN5G(144, 5720, 0),
> +	CHAN5G(149, 5745, 0),
> +	CHAN5G(153, 5765, 0),
> +	CHAN5G(157, 5785, 0),
> +	CHAN5G(161, 5805, 0),
> +	CHAN5G(165, 5825, 0),
> +	CHAN5G(169, 5845, 0),
> +};
> +
>  static const struct ieee80211_channel ath10k_5ghz_channels[] =3D {
>  	CHAN5G(36, 5180, 0),
>  	CHAN5G(40, 5200, 0),
> @@ -8014,6 +8046,7 @@ int ath10k_mac_register(struct ath10k *ar)
>  	};
>  	struct ieee80211_supported_band *band;
>  	void *channels;
> +	int n_channels;
>  	int ret;
>=20
>  	SET_IEEE80211_PERM_ADDR(ar->hw, ar->mac_addr); @@ -8049,16
> +8082,30 @@ int ath10k_mac_register(struct ath10k *ar)
>  	}
>=20
>  	if (ar->phy_capability & WHAL_WLAN_11A_CAPABILITY) {
> -		channels =3D kmemdup(ath10k_5ghz_channels,
> -				   sizeof(ath10k_5ghz_channels),
> -				   GFP_KERNEL);
> +		if (ar->high_5ghz_chan <=3D 5350) {
> +			channels =3D kmemdup(ath10k_low_5ghz_channels,
> +					   sizeof(ath10k_low_5ghz_channels),
> +					   GFP_KERNEL);
> +			n_channels =3D ARRAY_SIZE(ath10k_low_5ghz_channels);
> +		} else if (ar->low_5ghz_chan >=3D 5490 &&
> +			   ar->high_5ghz_chan <=3D 5885) {
> +			channels =3D kmemdup(ath10k_high_5ghz_channels,
> +					   sizeof(ath10k_high_5ghz_channels),
> +					   GFP_KERNEL);
> +			n_channels =3D
> ARRAY_SIZE(ath10k_high_5ghz_channels);
> +		} else {
> +			channels =3D kmemdup(ath10k_5ghz_channels,
> +					   sizeof(ath10k_5ghz_channels),
> +					   GFP_KERNEL);
> +			n_channels =3D ARRAY_SIZE(ath10k_5ghz_channels);
> +		}
>  		if (!channels) {
>  			ret =3D -ENOMEM;
>  			goto err_free;
>  		}
>=20
>  		band =3D &ar->mac.sbands[NL80211_BAND_5GHZ];
> -		band->n_channels =3D ARRAY_SIZE(ath10k_5ghz_channels);
> +		band->n_channels =3D n_channels;
>  		band->channels =3D channels;
>  		band->n_bitrates =3D ath10k_a_rates_size;
>  		band->bitrates =3D ath10k_a_rates;
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c
> b/drivers/net/wireless/ath/ath10k/wmi.c
> index 2f1743e..b31c4f7 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -4593,6 +4593,8 @@ static int ath10k_wmi_alloc_host_mem(struct ath10k
> *ar, u32 req_id,
>  	arg->phy_capab =3D ev->phy_capability;
>  	arg->num_rf_chains =3D ev->num_rf_chains;
>  	arg->eeprom_rd =3D ev->hal_reg_capabilities.eeprom_rd;
> +	arg->low_5ghz_chan =3D ev->hal_reg_capabilities.low_5ghz_chan;
> +	arg->high_5ghz_chan =3D ev->hal_reg_capabilities.high_5ghz_chan;
>  	arg->num_mem_reqs =3D ev->num_mem_reqs;
>  	arg->service_map =3D ev->wmi_service_bitmap;
>  	arg->service_map_len =3D sizeof(ev->wmi_service_bitmap); @@ -4629,6
> +4631,8 @@ static int ath10k_wmi_alloc_host_mem(struct ath10k *ar, u32
> req_id,
>  	arg->phy_capab =3D ev->phy_capability;
>  	arg->num_rf_chains =3D ev->num_rf_chains;
>  	arg->eeprom_rd =3D ev->hal_reg_capabilities.eeprom_rd;
> +	arg->low_5ghz_chan =3D ev->hal_reg_capabilities.low_5ghz_chan;
> +	arg->high_5ghz_chan =3D ev->hal_reg_capabilities.high_5ghz_chan;
>  	arg->num_mem_reqs =3D ev->num_mem_reqs;
>  	arg->service_map =3D ev->wmi_service_bitmap;
>  	arg->service_map_len =3D sizeof(ev->wmi_service_bitmap); @@ -4682,6
> +4686,8 @@ static void ath10k_wmi_event_service_ready_work(struct
> work_struct *work)
>  	ar->phy_capability =3D __le32_to_cpu(arg.phy_capab);
>  	ar->num_rf_chains =3D __le32_to_cpu(arg.num_rf_chains);
>  	ar->hw_eeprom_rd =3D __le32_to_cpu(arg.eeprom_rd);
> +	ar->low_5ghz_chan =3D __le32_to_cpu(arg.low_5ghz_chan);
> +	ar->high_5ghz_chan =3D __le32_to_cpu(arg.high_5ghz_chan);
>=20
>  	ath10k_dbg_dump(ar, ATH10K_DBG_WMI, NULL, "wmi svc: ",
>  			arg.service_map, arg.service_map_len); diff --git
> a/drivers/net/wireless/ath/ath10k/wmi.h
> b/drivers/net/wireless/ath/ath10k/wmi.h
> index 386aa51..78350d4 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.h
> +++ b/drivers/net/wireless/ath/ath10k/wmi.h
> @@ -6335,6 +6335,8 @@ struct wmi_svc_rdy_ev_arg {
>  	__le32 num_rf_chains;
>  	__le32 eeprom_rd;
>  	__le32 num_mem_reqs;
> +	__le32 low_5ghz_chan;
> +	__le32 high_5ghz_chan;
>  	const __le32 *service_map;
>  	size_t service_map_len;
>  	const struct wlan_host_mem_req
> *mem_reqs[WMI_MAX_MEM_REQS];
> --
> 1.7.9.5
