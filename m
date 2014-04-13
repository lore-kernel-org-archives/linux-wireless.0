Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:51647 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336AbaDMTUd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:20:33 -0400
Received: by mail-wg0-f51.google.com with SMTP id k14so7420863wgh.22
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:20:32 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/47] iwlwifi: mvm: propagate the beamforming status from firmware
Date: Sun, 13 Apr 2014 22:19:30 +0300
Message-Id: <1397416802-32403-15-git-send-email-egrumbach@gmail.com> (sfid-20140413_212218_492070_1AE3FA32)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The firmware tells us if an Rx packet was beamformed or not.
Propagate this data to mac80211's rx_status.vht_flags.
The main user of this data is the radiotap header.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index ac9a84e..40fd5dc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -393,6 +393,8 @@ int iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 		rx_status.rate_idx = rate_n_flags & RATE_VHT_MCS_RATE_CODE_MSK;
 		rx_status.flag |= RX_FLAG_VHT;
 		rx_status.flag |= stbc << RX_FLAG_STBC_SHIFT;
+		if (rate_n_flags & RATE_MCS_BF_MSK)
+			rx_status.vht_flag |= RX_VHT_FLAG_BF;
 	} else {
 		rx_status.rate_idx =
 			iwl_mvm_legacy_rate_to_mac80211_idx(rate_n_flags,
-- 
1.8.3.2

