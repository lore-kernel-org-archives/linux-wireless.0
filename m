Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55430 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2LVOq2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2012 09:46:28 -0500
Received: by mail-wi0-f172.google.com with SMTP id o1so5626518wic.5
        for <linux-wireless@vger.kernel.org>; Sat, 22 Dec 2012 06:46:27 -0800 (PST)
Message-Id: <77b183fe375c0cb455f4533f9cb69ef489476d40.1356186145.git.chunkeey@googlemail.com> (sfid-20121222_154634_054588_3FCAAF64)
In-Reply-To: <8f92b38a456c1dd901ce2022fcb66609a5b8ac4b.1356186145.git.chunkeey@googlemail.com>
References: <8f92b38a456c1dd901ce2022fcb66609a5b8ac4b.1356186145.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Mon, 17 Dec 2012 14:54:19 +0100
Subject: [PATCH 2/8] carl9170: Only specify interface combinations if more
 than one interface is possible
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Otherwise carl9170 triggers a warning in cfg80211, from net/wireless/core.c

	/* Combinations with just one interface aren't real */
	if (WARN_ON(c->max_interfaces < 2))

Note: The number of supported interfaces is set by
the carl9170 firmware. The default number of
supported interfaces for all current firmwares is 2.
Therefore this warning can only be observed with
custom firmwares.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/fw.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/fw.c b/drivers/net/wireless/ath/carl9170/fw.c
index 5a8a9f8..401a080 100644
--- a/drivers/net/wireless/ath/carl9170/fw.c
+++ b/drivers/net/wireless/ath/carl9170/fw.c
@@ -215,6 +215,24 @@ static int carl9170_fw_tx_sequence(struct ar9170 *ar)
 	return 0;
 }
 
+static void carl9170_fw_set_if_combinations(struct ar9170 *ar,
+					    u16 if_comb_types)
+{
+	if (ar->fw.vif_num < 2)
+		return;
+
+	ar->if_comb_limits[0].max = ar->fw.vif_num;
+	ar->if_comb_limits[0].types = if_comb_types;
+
+	ar->if_combs[0].num_different_channels = 1;
+	ar->if_combs[0].max_interfaces = ar->fw.vif_num;
+	ar->if_combs[0].limits = ar->if_comb_limits;
+	ar->if_combs[0].n_limits = ARRAY_SIZE(ar->if_comb_limits);
+
+	ar->hw->wiphy->iface_combinations = ar->if_combs;
+	ar->hw->wiphy->n_iface_combinations = ARRAY_SIZE(ar->if_combs);
+}
+
 static int carl9170_fw(struct ar9170 *ar, const __u8 *data, size_t len)
 {
 	const struct carl9170fw_otus_desc *otus_desc;
@@ -341,16 +359,7 @@ static int carl9170_fw(struct ar9170 *ar, const __u8 *data, size_t len)
 		}
 	}
 
-	ar->if_comb_limits[0].max = ar->fw.vif_num;
-	ar->if_comb_limits[0].types = if_comb_types;
-
-	ar->if_combs[0].num_different_channels = 1;
-	ar->if_combs[0].max_interfaces = ar->fw.vif_num;
-	ar->if_combs[0].limits = ar->if_comb_limits;
-	ar->if_combs[0].n_limits = ARRAY_SIZE(ar->if_comb_limits);
-
-	ar->hw->wiphy->iface_combinations = ar->if_combs;
-	ar->hw->wiphy->n_iface_combinations = ARRAY_SIZE(ar->if_combs);
+	carl9170_fw_set_if_combinations(ar, if_comb_types);
 
 	ar->hw->wiphy->interface_modes |= if_comb_types;
 
-- 
1.7.10.4

