Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65196 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab1AWL1z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Jan 2011 06:27:55 -0500
Received: by bwz15 with SMTP id 15so2812553bwz.19
        for <linux-wireless@vger.kernel.org>; Sun, 23 Jan 2011 03:27:53 -0800 (PST)
From: Bernhard Schmidt <bschmidt@techwires.net>
To: "Wey-Yi Guy" <wey-yi.w.guy@intel.com>
Subject: Re: [PATCH 04/14]  iwlagn: 2000 series devices support
Date: Sun, 23 Jan 2011 12:25:02 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
References: <1295654809-5790-1-git-send-email-wey-yi.w.guy@intel.com> <1295654809-5790-5-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1295654809-5790-5-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201101231225.03056.bschmidt@techwires.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 22 January 2011 01:06:39 Wey-Yi Guy wrote:
> From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> 
> Adding 2000 series devices supports, the 2000 series devices has
> many different SKUs which includes 1x1 and 2x2 devices,also with
> and without BT combo.
> 
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> [..]
> +
> +#define IWL_DEVICE_2030						\
> +	.fw_name_pre = IWL2030_FW_PRE,				\
> +	.ucode_api_max = IWL2030_UCODE_API_MAX,			\
> +	.ucode_api_min = IWL2030_UCODE_API_MIN,			\
> +	.eeprom_ver = EEPROM_2000_EEPROM_VERSION,		\
> +	.eeprom_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
> +	.ops = &iwl2030_ops,					\
> +	.mod_params = &iwlagn_mod_params,			\
> +	.base_params = &iwl2030_base_params,			\
> +	.bt_params = &iwl2030_bt_params,			\
> +	.need_dc_calib = true,					\
> +	.need_temp_offset_calib = true,				\
> +	.led_mode = IWL_LED_RF_STATE,				\
> +	.adv_pm = true						\
> +
> +struct iwl_cfg iwl2030_2bgn_cfg = {
> +	.name = "2000 Series 2x2 BGN/BT",
> +	IWL_DEVICE_2000,
> +	.ht_params = &iwl2000_ht_params,
> +};
> +
> +struct iwl_cfg iwl2030_2bg_cfg = {
> +	.name = "2000 Series 2x2 BG/BT",
> +	IWL_DEVICE_2000,
> +};

Shouldn't these use the IWL_DEVICE_2030 macro?

-- 
Bernhard
