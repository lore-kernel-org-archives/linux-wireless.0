Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:53213 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S969960AbXFIAQG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 20:16:06 -0400
Message-ID: <4669D4EA.3010401@linux.intel.com>
Date: Fri, 08 Jun 2007 15:15:06 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Zhu Yi <yi.zhu@intel.com>
Subject: Please pull patch-bomb for iwlwifi
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series catches wireless-dev up to the stand-alone 
iwlwifi tree.

I don't have a kernel tree for pulls to be made against.  The commit 
series for the changes below can be found in the patch bomb:

    iwlwifi-8af8d95343e10cae5876907dc5b75b536c53bcb3.tgz
at
    http://intellinuxwireless.org/iwlwifi/patches/

This is based on wireless-dev commit:

    3480b61c08559777c57b95e346507b26253ca8bb

Signed-off-by: James Ketrenos <jketreno@linux.intel.com>
---
 drivers/net/wireless/mac80211/iwlwifi/Makefile       |    6 
 drivers/net/wireless/mac80211/iwlwifi/base.c         |  809 +++++--
 drivers/net/wireless/mac80211/iwlwifi/iwl-3945-rs.c  |  969 +++++++++
 drivers/net/wireless/mac80211/iwlwifi/iwl-3945-rs.h  |   72 
 drivers/net/wireless/mac80211/iwlwifi/iwl-3945.c     |   33 
 drivers/net/wireless/mac80211/iwlwifi/iwl-4965-hw.h  |  263 +-
 drivers/net/wireless/mac80211/iwlwifi/iwl-4965-rs.c  | 2013 +++++++++++++++++++
 drivers/net/wireless/mac80211/iwlwifi/iwl-4965-rs.h  |  285 ++
 drivers/net/wireless/mac80211/iwlwifi/iwl-4965.c     | 1586 ++++++++++----
 drivers/net/wireless/mac80211/iwlwifi/iwl-4965.h     |   88 
 drivers/net/wireless/mac80211/iwlwifi/iwl-channel.h  |   26 
 drivers/net/wireless/mac80211/iwlwifi/iwl-commands.h |   55 
 drivers/net/wireless/mac80211/iwlwifi/iwl-debug.h    |    6 
 drivers/net/wireless/mac80211/iwlwifi/iwl-eeprom.h   |   44 
 drivers/net/wireless/mac80211/iwlwifi/iwl-helpers.h  |  117 -
 drivers/net/wireless/mac80211/iwlwifi/iwl-hw.h       |   91 
 drivers/net/wireless/mac80211/iwlwifi/iwl-io.h       |   38 
 drivers/net/wireless/mac80211/iwlwifi/iwl-priv.h     |   17 
 drivers/net/wireless/mac80211/iwlwifi/iwlwifi.h      |   37 
 19 files changed, 5532 insertions(+), 1023 deletions(-)
---
Ben M Cahill (1):
      iwlwifi: Improve readability and content of 4965 error log.

Hong Liu (12):
      iwlwifi: remove priv->down and add priv->restart
      iwlwifi: fix rf-kill problem
      iwlwifi: rf-kill resume fix
      iwlwifi: fix wireless interface missing after resume
      iwlwifi: station manipulation functions cleanup
      iwlwifi: reformat function iwl_sync_staion
      iwlwifi: replace warn_unused_result with __must_check
      iwlwifi: kill magic nums in iwl_eeprom_init
      iwlwifi: free ucode_data_backup
      iwlwifi: remove IWL == 3945 block in iwl-4965.c
      iwlwifi: fix iwl_read_ucode endian issue
      iwlwifi: remove FREE_FRAME_THRESHOLD reference

James Ketrenos (14):
      iwlwifi: Removed iwl_link_up and repurposed iwl_link_down
      iwlwifi: Add 3945 specific rate control algorithm back in
      iwlwifi: Added comment indicating why pci.h is needed in iwlwifi.h
      iwlwifi: Update version base.c stamp to 0.0.22
      iwlwifi: Leading whitespace problem typo.
      iwlwifi: Update version base.c stamp to 0.0.24
      iwlwifi: Fix warning in iwl_set_bits on 32-bit boundary bit-fields
      iwlwifi: Removed old comment about iwl-4965.c not being functional
      iwlwifi: whitespace fixes for labels incorrectly indented
      iwlwifi: Fixed clean_whitespace to correct leading spaces vs. tabs
      iwlwifi: Fixed leading space vs. tab inconsistencies
      iwlwifi: Fixed problem with building when CONFIG_IWLWIFI_HT=n
      iwlwifi: Resolve style issues reported by checkpatch.pl
      iwlwifi: Update version base.c stamp to 0.0.25

Mohamed Abbas (2):
      iwlwifi: add iwl4965 rate scaling
      iwlwifi: add 11n connection support

Tomas Winkler (6):
      iwlwifi: removed unused constant MAX_REAL_TX_QUEUE_NUM
      iwlwifi: RTS_DEFAULT_RETRY_LIMIT FIX (4965)
      iwlwifi: correct tx cmd byte count constants
      iwlwifi: iwlwifif: iwl4965_kw_free fix
      iwlwifi: ieee80211_get_qos_ctrl - corrected
      iwlwifi: iwl_dma_addr2rbd_ptr - commit

mabbas (6):
      iwlwifi: Calculate 4965 temperature immediately after "initialize" alive
      iwlwifi: Replace "-", which could easily be misread as a negative sign, with ":"
      iwlwifi: fix stabilty with switching between AP
      iwlwifi: reset 11n data on startup
      iwlwifi: add sensitivity calibration
      iwlwifi: add ibss connection support
