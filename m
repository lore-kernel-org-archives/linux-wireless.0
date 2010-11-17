Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:31659 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934939Ab0KQRLW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 12:11:22 -0500
Subject: Please revert "iwlwifi: fix modular legacy build errors" patch
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1290011797.12056.255.camel@wwguy-huron>
References: <1290011797.12056.255.camel@wwguy-huron>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 09:06:28 -0800
Message-ID: <1290013588.12056.258.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

iwlwifi should compile after

commit ae79d23d0b2c16998e60f49a16dae53521c76a45
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Wed Nov 10 09:56:38 2010 -0800

    iwlagn: fix non-5000+ build


Please revert "dd0dd411f7178a20ea93a3cfa39123f078a07e25 iwlwifi: fix
modular legacy build errors"

Thanks
Wey


On Wed, 2010-11-17 at 08:36 -0800, Guy, Wey-Yi wrote:
> Hi Randy,
> 
> the "iwlwifi: fix modular legacy build errors" patch cause the following
> WARNING when compile 
> 
> WARNING: drivers/net/wireless/iwlwifi/iwlagn:
> 'iwl_legacy_tx_cmd_protection' exported twice. Previous export was in
> drivers/net/wireless/iwlwifi/iwl3945.ko
> WARNING: drivers/net/wireless/iwlwifi/iwlagn: 'iwl_isr_legacy' exported
> twice. Previous export was in drivers/net/wireless/iwlwifi/iwl3945.ko
> WARNING: drivers/net/wireless/iwlwifi/iwlagn:
> 'iwl_legacy_mac_bss_info_changed' exported twice. Previous export was in
> drivers/net/wireless/iwlwifi/iwl3945.ko
> WARNING: drivers/net/wireless/iwlwifi/iwlagn: 'iwl_legacy_mac_reset_tsf'
> exported twice. Previous export was in
> drivers/net/wireless/iwlwifi/iwl3945.ko
> WARNING: drivers/net/wireless/iwlwifi/iwlagn: 'iwl_legacy_mac_config'
> exported twice. Previous export was in
> drivers/net/wireless/iwlwifi/iwl3945.ko
> 
> The .config option are
> 
> #
> # Debugging Options
> #
> CONFIG_IWLWIFI_DEBUG=y
> CONFIG_IWLWIFI_DEBUGFS=y
> CONFIG_IWLWIFI_DEVICE_TRACING=y
> CONFIG_IWLAGN=m
> CONFIG_IWL4965=y
> CONFIG_IWL5000=y
> CONFIG_IWL3945=m
> 
> Wey
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


