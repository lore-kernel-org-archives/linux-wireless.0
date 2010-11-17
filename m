Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49881 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934890Ab0KQQla (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 11:41:30 -0500
Subject: iwlwifi: fix modular legacy build errors
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: randy.dunlap@oracle.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 08:36:37 -0800
Message-ID: <1290011797.12056.255.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Randy,

the "iwlwifi: fix modular legacy build errors" patch cause the following
WARNING when compile 

WARNING: drivers/net/wireless/iwlwifi/iwlagn:
'iwl_legacy_tx_cmd_protection' exported twice. Previous export was in
drivers/net/wireless/iwlwifi/iwl3945.ko
WARNING: drivers/net/wireless/iwlwifi/iwlagn: 'iwl_isr_legacy' exported
twice. Previous export was in drivers/net/wireless/iwlwifi/iwl3945.ko
WARNING: drivers/net/wireless/iwlwifi/iwlagn:
'iwl_legacy_mac_bss_info_changed' exported twice. Previous export was in
drivers/net/wireless/iwlwifi/iwl3945.ko
WARNING: drivers/net/wireless/iwlwifi/iwlagn: 'iwl_legacy_mac_reset_tsf'
exported twice. Previous export was in
drivers/net/wireless/iwlwifi/iwl3945.ko
WARNING: drivers/net/wireless/iwlwifi/iwlagn: 'iwl_legacy_mac_config'
exported twice. Previous export was in
drivers/net/wireless/iwlwifi/iwl3945.ko

The .config option are

#
# Debugging Options
#
CONFIG_IWLWIFI_DEBUG=y
CONFIG_IWLWIFI_DEBUGFS=y
CONFIG_IWLWIFI_DEVICE_TRACING=y
CONFIG_IWLAGN=m
CONFIG_IWL4965=y
CONFIG_IWL5000=y
CONFIG_IWL3945=m

Wey


