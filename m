Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34479 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756930Ab0LIS0t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 13:26:49 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/2] iwlwifi fix for 2.6.37
Date: Thu,  9 Dec 2010 10:19:38 -0800
Message-Id: <1291918780-10882-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The original method used to parsing EEPROM Tx Power Table was hardcode and
not forward compatible with newer devices. Fix it here to be layout agnostic

John, we split EEPROM reading patches to two stage, for .37 release,
the existing devices will not change, only the newer devices will use
the new EEPROM reading method; we will remove the old EEPROM reading method
all together in separated patch for .38 release. Please let me know if this
is ok

Johannes Berg (1):
  iwlagn: rename enhanced txpower fields

Wey-Yi Guy (1):
  iwlagn: implement layout-agnostic EEPROM reading

these patches are also available from wireless-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-1000.c       |    2 +
 drivers/net/wireless/iwlwifi/iwl-6000.c       |   12 ++++
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c |   88 ++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c    |    6 ++
 drivers/net/wireless/iwlwifi/iwl-core.h       |    1 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.h     |   25 ++++++-
 6 files changed, 128 insertions(+), 6 deletions(-)

