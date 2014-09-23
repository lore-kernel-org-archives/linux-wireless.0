Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:51142 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932570AbaIWVSK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 17:18:10 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 06/10] ath10k: use configured nss instead of max nss.
Date: Tue, 23 Sep 2014 14:17:21 -0700
Message-Id: <1411507045-18973-6-git-send-email-greearb@candelatech.com> (sfid-20140923_231820_253503_20DD9F8E)
In-Reply-To: <1411507045-18973-1-git-send-email-greearb@candelatech.com>
References: <1411507045-18973-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

When re-associating a station, the nss was set back to
maximum value even if user had configured small number
of tx chains.  So, pay attention to user's config in
this case as well.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v2:  No changes from v1.

 drivers/net/wireless/ath/ath10k/mac.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index e75607d..34ec992 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4114,6 +4114,10 @@ ath10k_default_bitrate_mask(struct ath10k *ar,
 	u32 legacy = 0x00ff;
 	u8 ht = 0xff, i;
 	u16 vht = 0x3ff;
+	u16 nrf = ar->num_rf_chains;
+
+	if (ar->cfg_tx_chainmask)
+		nrf = get_nss_from_chainmask(ar->cfg_tx_chainmask);
 
 	switch (band) {
 	case IEEE80211_BAND_2GHZ:
@@ -4129,11 +4133,11 @@ ath10k_default_bitrate_mask(struct ath10k *ar,
 	if (mask->control[band].legacy != legacy)
 		return false;
 
-	for (i = 0; i < ar->num_rf_chains; i++)
+	for (i = 0; i < nrf; i++)
 		if (mask->control[band].ht_mcs[i] != ht)
 			return false;
 
-	for (i = 0; i < ar->num_rf_chains; i++)
+	for (i = 0; i < nrf; i++)
 		if (mask->control[band].vht_mcs[i] != vht)
 			return false;
 
@@ -4384,6 +4388,9 @@ static int ath10k_set_bitrate_mask(struct ieee80211_hw *hw,
 	u8 fixed_nss = ar->num_rf_chains;
 	u8 force_sgi;
 
+	if (ar->cfg_tx_chainmask)
+		fixed_nss = get_nss_from_chainmask(ar->cfg_tx_chainmask);
+
 	force_sgi = mask->control[band].gi;
 	if (force_sgi == NL80211_TXRATE_FORCE_LGI)
 		return -EINVAL;
-- 
1.7.11.7

