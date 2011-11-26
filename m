Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43633 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab1KZAGa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Nov 2011 19:06:30 -0500
Received: by qyk4 with SMTP id 4so271070qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Nov 2011 16:06:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1322248308-5113-5-git-send-email-wey-yi.w.guy@intel.com>
References: <1322248308-5113-1-git-send-email-wey-yi.w.guy@intel.com> <1322248308-5113-5-git-send-email-wey-yi.w.guy@intel.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sat, 26 Nov 2011 01:06:08 +0100
Message-ID: <CA+XFjip+ePyqkFw6sJYLrL+ODGBQcuhmntZ62npzB-HrLqPjnw@mail.gmail.com> (sfid-20111126_010634_262790_73308AE1)
Subject: Re: [PATCH 4/7] iwlagn: allow up to uCode API 6 for 6000 devices
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 25, 2011 at 8:11 PM, Wey-Yi Guy <wey-yi.w.guy@intel.com> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Since the uCode hasn't been released (yet?),

Isn't the 6x00 ucode available on intellinuxwireless.org? I certainly
can see it there.

> warn only if using older than API 4, but load
> anything up to API 6.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-6000.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
> index 09f0378..617ad1c 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-6000.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
> @@ -46,11 +46,12 @@
>  #include "iwl-cfg.h"
>
>  /* Highest firmware API version supported */
> -#define IWL6000_UCODE_API_MAX 4
> +#define IWL6000_UCODE_API_MAX 6
>  #define IWL6050_UCODE_API_MAX 5
>  #define IWL6000G2_UCODE_API_MAX 6
>
>  /* Oldest version we won't warn about */
> +#define IWL6000_UCODE_API_OK 4
>  #define IWL6000G2_UCODE_API_OK 5
>
>  /* Lowest firmware API version supported */
> @@ -457,6 +458,7 @@ struct iwl_cfg iwl130_bg_cfg = {
>  #define IWL_DEVICE_6000i                                       \
>        .fw_name_pre = IWL6000_FW_PRE,                          \
>        .ucode_api_max = IWL6000_UCODE_API_MAX,                 \
> +       .ucode_api_ok = IWL6000_UCODE_API_OK,                   \
>        .ucode_api_min = IWL6000_UCODE_API_MIN,                 \
>        .valid_tx_ant = ANT_BC,         /* .cfg overwrite */    \
>        .valid_rx_ant = ANT_BC,         /* .cfg overwrite */    \
> @@ -535,6 +537,7 @@ struct iwl_cfg iwl6000_3agn_cfg = {
>        .name = "Intel(R) Centrino(R) Ultimate-N 6300 AGN",
>        .fw_name_pre = IWL6000_FW_PRE,
>        .ucode_api_max = IWL6000_UCODE_API_MAX,
> +       .ucode_api_ok = IWL6000_UCODE_API_OK,
>        .ucode_api_min = IWL6000_UCODE_API_MIN,
>        .eeprom_ver = EEPROM_6000_EEPROM_VERSION,
>        .eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,
> @@ -544,7 +547,7 @@ struct iwl_cfg iwl6000_3agn_cfg = {
>        .led_mode = IWL_LED_BLINK,
>  };
>
> -MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
> +MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_OK));
>  MODULE_FIRMWARE(IWL6050_MODULE_FIRMWARE(IWL6050_UCODE_API_MAX));
>  MODULE_FIRMWARE(IWL6005_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));
>  MODULE_FIRMWARE(IWL6030_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
