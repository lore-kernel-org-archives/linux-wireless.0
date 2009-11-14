Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:61707 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbZKNP0u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Nov 2009 10:26:50 -0500
Received: by fg-out-1718.google.com with SMTP id e12so1834148fga.1
        for <linux-wireless@vger.kernel.org>; Sat, 14 Nov 2009 07:26:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1258142198-3223-5-git-send-email-reinette.chatre@intel.com>
References: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
	<1258142198-3223-5-git-send-email-reinette.chatre@intel.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sat, 14 Nov 2009 16:26:35 +0100
Message-ID: <69e28c910911140726x96646dcgdc8ff8592e459dcf@mail.gmail.com>
Subject: Re: [PATCH 04/16] iwlwifi: drop non-production PCI-IDs for 6x50
	series
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Does that mean, Centrino 6350AGN cancelled?

On Fri, Nov 13, 2009 at 8:56 PM, Reinette Chatre
<reinette.chatre@intel.com> wrote:
> From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
>
> drop the non-production PCI-IDs for 6x50 series
>
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-6000.c |   32 -------------------------------
>  drivers/net/wireless/iwlwifi/iwl-agn.c  |    3 --
>  drivers/net/wireless/iwlwifi/iwl-dev.h  |    1 -
>  3 files changed, 0 insertions(+), 36 deletions(-)
>
> diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
> index 72ed944..4ab9897 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-6000.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
> @@ -456,37 +456,5 @@ struct iwl_cfg iwl6000_3agn_cfg = {
>        .support_ct_kill_exit = true,
>  };
>
> -struct iwl_cfg iwl6050_3agn_cfg = {
> -       .name = "6050 Series 3x3 AGN",
> -       .fw_name_pre = IWL6050_FW_PRE,
> -       .ucode_api_max = IWL6050_UCODE_API_MAX,
> -       .ucode_api_min = IWL6050_UCODE_API_MIN,
> -       .sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
> -       .ops = &iwl6050_ops,
> -       .eeprom_size = OTP_LOW_IMAGE_SIZE,
> -       .eeprom_ver = EEPROM_6050_EEPROM_VERSION,
> -       .eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
> -       .num_of_queues = IWL50_NUM_QUEUES,
> -       .num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
> -       .mod_params = &iwl50_mod_params,
> -       .valid_tx_ant = ANT_ABC,
> -       .valid_rx_ant = ANT_ABC,
> -       .pll_cfg_val = 0,
> -       .set_l0s = true,
> -       .use_bsm = false,
> -       .pa_type = IWL_PA_SYSTEM,
> -       .max_ll_items = OTP_MAX_LL_ITEMS_6x50,
> -       .shadow_ram_support = true,
> -       .ht_greenfield_support = true,
> -       .led_compensation = 51,
> -       .use_rts_for_ht = true, /* use rts/cts protection */
> -       .chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
> -       .supports_idle = true,
> -       .adv_thermal_throttle = true,
> -       .support_ct_kill_exit = true,
> -       .support_sm_ps = true,
> -       .support_wimax_coexist = true,
> -};
> -
>  MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
>  MODULE_FIRMWARE(IWL6050_MODULE_FIRMWARE(IWL6050_UCODE_API_MAX));
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
> index 29f7510..24baf2c 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
> @@ -3485,13 +3485,10 @@ static struct pci_device_id iwl_hw_card_ids[] = {
>        {IWL_PCI_DEVICE(0x4239, 0x1316, iwl6000i_2abg_cfg)},
>
>  /* 6x50 WiFi/WiMax Series */
> -       {IWL_PCI_DEVICE(0x0086, 0x1101, iwl6050_3agn_cfg)},
> -       {IWL_PCI_DEVICE(0x0086, 0x1121, iwl6050_3agn_cfg)},
>        {IWL_PCI_DEVICE(0x0087, 0x1301, iwl6050_2agn_cfg)},
>        {IWL_PCI_DEVICE(0x0087, 0x1306, iwl6050_2abg_cfg)},
>        {IWL_PCI_DEVICE(0x0087, 0x1321, iwl6050_2agn_cfg)},
>        {IWL_PCI_DEVICE(0x0087, 0x1326, iwl6050_2abg_cfg)},
> -       {IWL_PCI_DEVICE(0x0088, 0x1111, iwl6050_3agn_cfg)},
>        {IWL_PCI_DEVICE(0x0089, 0x1311, iwl6050_2agn_cfg)},
>        {IWL_PCI_DEVICE(0x0089, 0x1316, iwl6050_2abg_cfg)},
>
> diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
> index d0f0915..273adee 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-dev.h
> +++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
> @@ -64,7 +64,6 @@ extern struct iwl_cfg iwl6000i_2bg_cfg;
>  extern struct iwl_cfg iwl6000_3agn_cfg;
>  extern struct iwl_cfg iwl6050_2agn_cfg;
>  extern struct iwl_cfg iwl6050_2abg_cfg;
> -extern struct iwl_cfg iwl6050_3agn_cfg;
>  extern struct iwl_cfg iwl1000_bgn_cfg;
>  extern struct iwl_cfg iwl1000_bg_cfg;
>
> --
> 1.5.6.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
