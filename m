Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23775 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbXH0FZ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2007 01:25:27 -0400
Subject: [PATCH V2] Add iwlwifi wireless drivers
From: Zhu Yi <yi.zhu@intel.com>
To: linux-wireless@vger.kernel.org
Cc: "John W.Linville" <linville@tuxdriver.com>,
	Jeff Garzik <jgarzik@pobox.com>
Content-Type: text/plain
Date: Mon, 27 Aug 2007 13:20:12 +0800
Message-Id: <1188192012.13078.177.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

This is the second version of the patch (still against 2.6.23-rc3) adds
the mac80211 based wireless drivers for the Intel PRO/Wireless
3945ABG/BG Network Connection and Intel Wireless WiFi Link AGN (4965)
adapters. You can find it from:
http://intellinuxwireless.org/iwlwifi/v5-Add-iwlwifi-wireless-drivers.patch

I list the changes against the first version I submitted to the list on
8/17 in case you have reviewed the previous version and only want to see
the diff. You can find the overall patch here:
http://intellinuxwireless.org/iwlwifi/iwlwifi-v4_to_v5.patch
and the broken out patches here:
http://intellinuxwireless.org/iwlwifi/patches/iwlwifi-v5-v4-patches/


Ben M Cahill (5):
      iwlwifi: remove unused 3945-only struct from 4965 build
      iwlwifi: move all uCode API structs into iwl-command.h
      iwlwifi: replace iwl_scanstart_notification with
iwl_scanreq_notification
      iwlwifi: add struct iwl_card_state_cmd as documentation
      iwlwifi: add BSM_DRAM_INST_LOAD definition

Johannes Berg (1):
      iwlwifi: remove atheros turbo modes

Johannes Engel (1):
      iwlwifi: fix iwl-3945-rs.c typo

Mohamed Abbas (3):
      iwlwifi: fix rs_get_best_rate to pick up the right rate
      iwlwifi: fix 11n connection problem
      iwlwifi: fix aggregation problem

Tomas Winkler (11):
      iwlwifi: adding queues_num module parameter
      iwlwifi: iwl_get_sta_id AP mode fix
      iwlwifi: EEPROM band 5 endianity fix
      iwlwifi: AP mode beacon update
      iwlwifi: kill iwl_rate union
      iwlwifi: simplifying reclaim flow
      iwlwifi: removing while loop from iwl_print_hex_dump
      iwlwifi: typo fix for CONFIG_IWLWIFI_SPECTRUM_MEASUREMENY
      iwlwifi: remove unused code
      iwlwifi: rate scaling - up scaling fix
      iwlwifi: rate scale quality command fix

Zhu Yi (10):
      iwlwifi: replace lock_flags into simpler flags
      iwlwifi: split priv->hcmd_lock from priv->lock to protect hcmd
queue
      iwlwifi: iwl_mac_set_key cleanup
      iwlwifi: fix priv->hcmd_lock uninitialized problem
      iwlwifi: Update version iwl-base.c stamp to 0.1.9
      iwlwifi: fix iwl_grab_restricted_access return code
      iwlwifi: Update version iwl-base.c stamp to 0.1.10
      iwlwifi: add a parameter to functions
iwl_rate_control_[un]register
      iwlwifi: Update version iwl-base.c stamp to 0.1.11
      iwlwifi: fix iwl_send_cmd_async return value bug
