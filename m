Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:20717 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659AbaLAOoy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 09:44:54 -0500
Subject: [PATCH v3 0/7] ath10k: add support for new wmi-tlv backend
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Date: Mon, 1 Dec 2014 16:44:42 +0200
Message-ID: <20141201144400.18248.62714.stgit@potku.adurom.net> (sfid-20141201_154457_116437_AEEB2850)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

here's v3 of Michal's patches to add WMI TLV interface support to
ath10k.

v3:

* add ATH10K_FW_IE_WMI_OP_VERSION

* deprecate ATH10K_FW_FEATURE_WMI_10* feature flags

* remove ATH10K_FW_FEATURE_WMI_TLV, functionality replaced by
  ATH10K_FW_IE_WMI_OP_VERSION

* remove struct ieee80211_iface_combination ath10k_tlv_if_comb[] & co.
  Those can be added in a different patch.

* add SVCSTR() for STA_RX_IPA_OFFLOAD_SUPPORT, MDNS_OFFLOAD and SAP_AUTH_OFFLOAD

---

Kalle Valo (3):
      ath10k: create ath10k_core_init_features()
      ath10k: add ATH10K_FW_IE_WMI_OP_VERSION
      ath10k: set max_num_pending_tx in ath10k_core_init_firmware_features()

Michal Kazior (4):
      ath10k: implement intermediate event args
      ath10k: introduce wmi ops
      ath10k: make some wmi functions public
      ath10k: implement wmi-tlv backend


 drivers/net/wireless/ath/ath10k/Makefile   |    1 
 drivers/net/wireless/ath/ath10k/ce.c       |    2 
 drivers/net/wireless/ath/ath10k/core.c     |   62 +
 drivers/net/wireless/ath/ath10k/core.h     |   10 
 drivers/net/wireless/ath/ath10k/debug.c    |    1 
 drivers/net/wireless/ath/ath10k/htt_tx.c   |    5 
 drivers/net/wireless/ath/ath10k/hw.h       |   20 
 drivers/net/wireless/ath/ath10k/mac.c      |    2 
 drivers/net/wireless/ath/ath10k/spectral.c |    1 
 drivers/net/wireless/ath/ath10k/testmode.c |    5 
 drivers/net/wireless/ath/ath10k/wmi-ops.h  |  821 ++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c  | 2218 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h  | 1380 +++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c      | 1375 +++++++++++------
 drivers/net/wireless/ath/ath10k/wmi.h      |  268 +++
 15 files changed, 5560 insertions(+), 611 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/wmi-ops.h
 create mode 100644 drivers/net/wireless/ath/ath10k/wmi-tlv.c
 create mode 100644 drivers/net/wireless/ath/ath10k/wmi-tlv.h
