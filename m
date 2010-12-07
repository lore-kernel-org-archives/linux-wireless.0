Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:63392 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039Ab0LGRoE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 12:44:04 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/3] iwlwifi fix for 2.6.37
Date: Tue,  7 Dec 2010 09:37:05 -0800
Message-Id: <1291743428-19642-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The original method used to parsing EEPROM Tx Power Table was hardcode and
not forward compatible with newer devices. Fix it here to be layout agnostic

Johannes Berg (2):
  iwlagn: rename enhanced txpower fields
  iwlagn: implement layout-agnostic EEPROM reading

Wey-Yi Guy (1):
  iwlwifi: minor txp entries fix

these patches are also available from wireless-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c |  265 ++++++-------------------
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c    |    6 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.h     |   25 ++-
 3 files changed, 87 insertions(+), 209 deletions(-)

