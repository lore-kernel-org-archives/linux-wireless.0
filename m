Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:7088 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757233Ab0EJWrU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:47:20 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1005954fgg.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 May 2010 15:47:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1273530498-11876-2-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
	<1273530498-11876-2-git-send-email-reinette.chatre@intel.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 11 May 2010 00:46:58 +0200
Message-ID: <z2l69e28c911005101546zeb388411pc3f8bb7f4325de78@mail.gmail.com>
Subject: Re: [PATCH 01/47] iwlwifi: rename 6000 series Gen2 devices to Gen2a
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Shanyu Zhao <shanyu.zhao@intel.com>,
	Jay Sternberg <jay.e.sternberg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What is the reason behind this change? Is Gen2b planned?

On Tue, May 11, 2010 at 12:27 AM, Reinette Chatre
<reinette.chatre@intel.com> wrote:
> From: Shanyu Zhao <shanyu.zhao@intel.com>
>
> Rename the current 6000 series Gen2 devices to Gen2a.
> Rename the ucode name prefix to iwlwifi-6000g2a.
> Also corrected the device IDs for Gen2a series devices.
>
> Signed-off-by: Jay Sternberg <jay.e.sternberg@intel.com>
> Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-6000.c |   24 +++++++++++++-----------
>  drivers/net/wireless/iwlwifi/iwl-agn.c  |    9 ++++-----
>  drivers/net/wireless/iwlwifi/iwl-dev.h  |    2 +-
>  3 files changed, 18 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
> index 7acef70..f057087 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-6000.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
> @@ -67,9 +67,10 @@
>  #define _IWL6050_MODULE_FIRMWARE(api) IWL6050_FW_PRE #api ".ucode"
>  #define IWL6050_MODULE_FIRMWARE(api) _IWL6050_MODULE_FIRMWARE(api)
>
> -#define IWL6000G2_FW_PRE "iwlwifi-6005-"
> -#define _IWL6000G2_MODULE_FIRMWARE(api) IWL6000G2_FW_PRE #api ".ucode"
> -#define IWL6000G2_MODULE_FIRMWARE(api) _IWL6000G2_MODULE_FIRMWARE(api)
> +#define IWL6000G2A_FW_PRE "iwlwifi-6000g2a-"
> +#define _IWL6000G2A_MODULE_FIRMWARE(api) IWL6000G2A_FW_PRE #api ".ucode"
> +#define IWL6000G2A_MODULE_FIRMWARE(api) _IWL6000G2A_MODULE_FIRMWARE(api)
> +
>
>  static void iwl6000_set_ct_threshold(struct iwl_priv *priv)
>  {
> @@ -408,12 +409,10 @@ static const struct iwl_ops iwl6050_ops = {
>        .led = &iwlagn_led_ops,
>  };
>
> -/*
> - * "i": Internal configuration, use internal Power Amplifier
> - */
> -struct iwl_cfg iwl6000g2_2agn_cfg = {
> -       .name = "6000 Series 2x2 AGN Gen2",
> -       .fw_name_pre = IWL6000G2_FW_PRE,
> +
> +struct iwl_cfg iwl6000g2a_2agn_cfg = {
> +       .name = "6000 Series 2x2 AGN Gen2a",
> +       .fw_name_pre = IWL6000G2A_FW_PRE,
>        .ucode_api_max = IWL6000G2_UCODE_API_MAX,
>        .ucode_api_min = IWL6000G2_UCODE_API_MIN,
>        .sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
> @@ -442,9 +441,12 @@ struct iwl_cfg iwl6000g2_2agn_cfg = {
>        .plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
>        .chain_noise_scale = 1000,
>        .monitor_recover_period = IWL_MONITORING_PERIOD,
> -       .max_event_log_size = 1024,
> +       .max_event_log_size = 512,
>  };
>
> +/*
> + * "i": Internal configuration, use internal Power Amplifier
> + */
>  struct iwl_cfg iwl6000i_2agn_cfg = {
>        .name = "Intel(R) Centrino(R) Advanced-N 6200 AGN",
>        .fw_name_pre = IWL6000_FW_PRE,
> @@ -645,4 +647,4 @@ struct iwl_cfg iwl6000_3agn_cfg = {
>
>  MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
>  MODULE_FIRMWARE(IWL6050_MODULE_FIRMWARE(IWL6050_UCODE_API_MAX));
> -MODULE_FIRMWARE(IWL6000G2_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));
> +MODULE_FIRMWARE(IWL6000G2A_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
> index dc28376..5cf3822 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
> @@ -3789,11 +3789,10 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
>        {IWL_PCI_DEVICE(0x4239, 0x1311, iwl6000i_2agn_cfg)},
>        {IWL_PCI_DEVICE(0x4239, 0x1316, iwl6000i_2abg_cfg)},
>
> -/* 6x00 Series Gen2 */
> -       {IWL_PCI_DEVICE(0x0082, 0x1201, iwl6000g2_2agn_cfg)},
> -       {IWL_PCI_DEVICE(0x0082, 0x1301, iwl6000g2_2agn_cfg)},
> -       {IWL_PCI_DEVICE(0x0082, 0x1321, iwl6000g2_2agn_cfg)},
> -       {IWL_PCI_DEVICE(0x0085, 0x1311, iwl6000g2_2agn_cfg)},
> +/* 6x00 Series Gen2a */
> +       {IWL_PCI_DEVICE(0x0082, 0x1201, iwl6000g2a_2agn_cfg)},
> +       {IWL_PCI_DEVICE(0x0085, 0x1211, iwl6000g2a_2agn_cfg)},
> +       {IWL_PCI_DEVICE(0x0082, 0x1221, iwl6000g2a_2agn_cfg)},
>
>  /* 6x50 WiFi/WiMax Series */
>        {IWL_PCI_DEVICE(0x0087, 0x1301, iwl6050_2agn_cfg)},
> diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
> index cd3b932..e485465 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-dev.h
> +++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
> @@ -57,8 +57,8 @@ extern struct iwl_cfg iwl5100_bgn_cfg;
>  extern struct iwl_cfg iwl5100_abg_cfg;
>  extern struct iwl_cfg iwl5150_agn_cfg;
>  extern struct iwl_cfg iwl5150_abg_cfg;
> +extern struct iwl_cfg iwl6000g2a_2agn_cfg;
>  extern struct iwl_cfg iwl6000i_2agn_cfg;
> -extern struct iwl_cfg iwl6000g2_2agn_cfg;
>  extern struct iwl_cfg iwl6000i_2abg_cfg;
>  extern struct iwl_cfg iwl6000i_2bg_cfg;
>  extern struct iwl_cfg iwl6000_3agn_cfg;
> --
> 1.6.3.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
