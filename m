Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35791 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751524AbcLEVwy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 16:52:54 -0500
Received: by mail-wm0-f65.google.com with SMTP id a20so18361437wme.2
        for <linux-wireless@vger.kernel.org>; Mon, 05 Dec 2016 13:52:48 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 2/2] ath10k: fix potential memory leak in ath10k_wmi_tlv_op_pull_fw_stats()
Date: Mon,  5 Dec 2016 22:52:46 +0100
Message-Id: <e0909741dfae742197d5f5d60709d225cc179b42.1480974623.git.chunkeey@googlemail.com> (sfid-20161205_225258_989667_0364D06F)
In-Reply-To: <992a4e2676037a06f482cdbe2d3d39e287530be5.1480974623.git.chunkeey@googlemail.com>
References: <992a4e2676037a06f482cdbe2d3d39e287530be5.1480974623.git.chunkeey@googlemail.com>
In-Reply-To: <992a4e2676037a06f482cdbe2d3d39e287530be5.1480974623.git.chunkeey@googlemail.com>
References: <992a4e2676037a06f482cdbe2d3d39e287530be5.1480974623.git.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath10k_wmi_tlv_op_pull_fw_stats() uses tb = ath10k_wmi_tlv_parse_alloc(...)
function, which allocates memory. If any of the three error-paths are
taken, this tb needs to be freed.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index f304f6632c4f..1f6bb9e8bb01 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1105,8 +1105,10 @@ static int ath10k_wmi_tlv_op_pull_fw_stats(struct ath10k *ar,
 		struct ath10k_fw_stats_pdev *dst;
 
 		src = data;
-		if (data_len < sizeof(*src))
+		if (data_len < sizeof(*src)) {
+			kfree(tb);
 			return -EPROTO;
+		}
 
 		data += sizeof(*src);
 		data_len -= sizeof(*src);
@@ -1126,8 +1128,10 @@ static int ath10k_wmi_tlv_op_pull_fw_stats(struct ath10k *ar,
 		struct ath10k_fw_stats_vdev *dst;
 
 		src = data;
-		if (data_len < sizeof(*src))
+		if (data_len < sizeof(*src)) {
+			kfree(tb);
 			return -EPROTO;
+		}
 
 		data += sizeof(*src);
 		data_len -= sizeof(*src);
@@ -1145,8 +1149,10 @@ static int ath10k_wmi_tlv_op_pull_fw_stats(struct ath10k *ar,
 		struct ath10k_fw_stats_peer *dst;
 
 		src = data;
-		if (data_len < sizeof(*src))
+		if (data_len < sizeof(*src)) {
+			kfree(tb);
 			return -EPROTO;
+		}
 
 		data += sizeof(*src);
 		data_len -= sizeof(*src);
-- 
2.11.0
