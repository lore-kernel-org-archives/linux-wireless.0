Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:49503 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073Ab1AWSYO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Jan 2011 13:24:14 -0500
Subject: Re: [PATCH 04/14]  iwlagn: 2000 series devices support
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Bernhard Schmidt <bschmidt@techwires.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <201101231225.03056.bschmidt@techwires.net>
References: <1295654809-5790-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1295654809-5790-5-git-send-email-wey-yi.w.guy@intel.com>
	 <201101231225.03056.bschmidt@techwires.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 23 Jan 2011 10:12:27 -0800
Message-ID: <1295806347.3591.59.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-01-23 at 03:25 -0800, Bernhard Schmidt wrote:
> On Saturday 22 January 2011 01:06:39 Wey-Yi Guy wrote:
> > From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > 
> > Adding 2000 series devices supports, the 2000 series devices has
> > many different SKUs which includes 1x1 and 2x2 devices,also with
> > and without BT combo.
> > 
> > Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > [..]
> > +
> > +#define IWL_DEVICE_2030						\
> > +	.fw_name_pre = IWL2030_FW_PRE,				\
> > +	.ucode_api_max = IWL2030_UCODE_API_MAX,			\
> > +	.ucode_api_min = IWL2030_UCODE_API_MIN,			\
> > +	.eeprom_ver = EEPROM_2000_EEPROM_VERSION,		\
> > +	.eeprom_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
> > +	.ops = &iwl2030_ops,					\
> > +	.mod_params = &iwlagn_mod_params,			\
> > +	.base_params = &iwl2030_base_params,			\
> > +	.bt_params = &iwl2030_bt_params,			\
> > +	.need_dc_calib = true,					\
> > +	.need_temp_offset_calib = true,				\
> > +	.led_mode = IWL_LED_RF_STATE,				\
> > +	.adv_pm = true						\
> > +
> > +struct iwl_cfg iwl2030_2bgn_cfg = {
> > +	.name = "2000 Series 2x2 BGN/BT",
> > +	IWL_DEVICE_2000,
> > +	.ht_params = &iwl2000_ht_params,
> > +};
> > +
> > +struct iwl_cfg iwl2030_2bg_cfg = {
> > +	.name = "2000 Series 2x2 BG/BT",
> > +	IWL_DEVICE_2000,
> > +};
> 
> Shouldn't these use the IWL_DEVICE_2030 macro?
> 
good catch, thank you very much, will submit separated patch to address
it

Wey



