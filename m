Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:17274 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbXIDDKW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Sep 2007 23:10:22 -0400
Subject: [PATCH V3] Add iwlwifi wireless drivers
From: Zhu Yi <yi.zhu@intel.com>
To: linux-wireless@vger.kernel.org
Cc: "John W.Linville" <linville@tuxdriver.com>
Content-Type: text/plain
Date: Tue, 04 Sep 2007 11:04:17 +0800
Message-Id: <1188875058.13078.428.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This is the third version of the patch (against 2.6.23-rc4) adds
the mac80211 based wireless drivers for the Intel PRO/Wireless
3945ABG/BG Network Connection and Intel Wireless WiFi Link AGN (4965)
adapters. You can find it from:
http://intellinuxwireless.org/iwlwifi/v6-Add-iwlwifi-wireless-drivers.patch

I list the changes against the last version I submitted to the list last
week in case you have reviewed the previous version and only want to see
the diff. You can find the overall patch here:
http://intellinuxwireless.org/iwlwifi/iwlwifi-v5_to_v6.patch

In this version, we replace the "comiple iwl-base.c twice for two
drivers" scheme with separating the two drivers into two code base. In
the future, we will abstract a common layer for all the iwl based
drivers and make it a separate module for better maintenance.

Note, the #include "../net/mac80211/ieee80211_rate.h" still existed in
this version of the driver. We are discussing how to abstract the
mac80211 rate scaling interface in another thread in this ML.


Signed-off-by: Zhu Yi <yi.zhu@intel.com>

Adrian Bunk (1):
      iwl-base.c bugfixes

Ben Cahill (3):
      iwlwifi: unify definitions (3945/4965) of struct
iwl_txpowertable_cmd
      iwlwifi: remove unused definitions in iwl-4965-hw.h
      iwlwifi: move 4965 Rx API stuff into iwl-commands.h

Mohamed Abbas (2):
      iwlwifi: fix assert when calling LinkQuality command
      iwlwifi: fix aggregation tx status

Tomas Winkler (14):
      iwlwifi: kill legacy fields from iwl_cmd_meta
      iwlwifi: kill __iwl_send_cmd
      iwlwifi: add file iwl-prph.h
      iwlwifi: CSR registers cleanup
      iwlwifi: add Makefile sparse target
      iwlwifi: iwl_mac_conf_tx remove casting to restricted
      iwlwifi: setting RAxTID endianity fix
      iwlwifi: AP setup qos and tx_conf bug fix
      iwlwifi: move defines from iwl-4965.c to iwl-commands.h
      iwlwifi: remove unnecessary condition check
      iwlwifi: fixing LQ command changes in AP mode
      iwlwifi: FAT channel bug fix for zero relevant bits
      iwlwifi: Control channel fix for FAT channel
      iwlwifi: move APMG registers to Periphery section

Zhu Yi (4):
      iwlwifi: make "ipw going down" debug message depends on
IWL_DL_INFO
      iwlwifi: fix IBSS connection problem caused by LinkQuality cmd
change
      iwlwifi: Update version iwl-base.c stamp to 0.1.14
      iwlwifi: move macros defines from *.c to *.h
      
ian (1):
      avoid kernel oops in monitor mode with debug enabled
