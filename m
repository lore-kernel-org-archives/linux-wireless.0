Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45044 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab1EMWfN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 18:35:13 -0400
Received: by fxm17 with SMTP id 17so2049169fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 15:35:12 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] carl9170: advertise interface combinations
Date: Sat, 14 May 2011 00:35:06 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>, linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201105140035.06559.chunkeey@googlemail.com> (sfid-20110514_003523_620123_7A143A41)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to provide multiple interfaces for a single device,
the driver is now required to advertise all possible
interface configurations to the stack.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
with the standard firmware, iw now displays:
	[...]
        valid interface combinations:
                 * #{ IBSS, managed, AP, P2P-client, P2P-GO } <= 2,
                   total <= 2, #channels <= 1
	[...]
---
diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index 71d6d07..dbce999 100644
--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -287,6 +287,10 @@ struct ar9170 {
 		unsigned int tx_seq_table;
 	} fw;
 
+	/* interface configuration combinations */
+	struct ieee80211_iface_limit if_comb_limits[1];
+	struct ieee80211_iface_combination if_combs[1];
+
 	/* reset / stuck frames/queue detection */
 	struct work_struct restart_work;
 	struct work_struct ping_work;
diff --git a/drivers/net/wireless/ath/carl9170/fw.c b/drivers/net/wireless/ath/carl9170/fw.c
index 9517ede..8ec27b8 100644
--- a/drivers/net/wireless/ath/carl9170/fw.c
+++ b/drivers/net/wireless/ath/carl9170/fw.c
@@ -300,6 +300,17 @@ static int carl9170_fw(struct ar9170 *ar, const __u8 *data, size_t len)
 		}
 	}
 
+	ar->if_comb_limits[0].max = ar->fw.vif_num;
+	ar->if_comb_limits[0].types = ar->hw->wiphy->interface_modes;
+
+	ar->if_combs[0].num_different_channels = 1;
+	ar->if_combs[0].max_interfaces = ar->fw.vif_num;
+	ar->if_combs[0].limits = ar->if_comb_limits;
+	ar->if_combs[0].n_limits = ARRAY_SIZE(ar->if_comb_limits);
+
+	ar->hw->wiphy->iface_combinations = ar->if_combs;
+	ar->hw->wiphy->n_iface_combinations = ARRAY_SIZE(ar->if_combs);
+
 	txsq_desc = carl9170_fw_find_desc(ar, TXSQ_MAGIC,
 		sizeof(*txsq_desc), CARL9170FW_TXSQ_DESC_CUR_VER);
 
