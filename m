Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:13138 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757249Ab1LBRqR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 12:46:17 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, "Hsu, Kenny" <kenny.hsu@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/16] iwlwifi: add generic chunk size of tm dumpit packet
Date: Fri,  2 Dec 2011 08:48:28 -0800
Message-Id: <1322844520-21149-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111202_184636_905929_D9D4EB76)
In-Reply-To: <1322844520-21149-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1322844520-21149-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hsu, Kenny <kenny.hsu@intel.com>

Use generic chunk size of dumpit packet for
all necessary testmode commands instead of
add declaration individually.

Signed-off-by: Kenny Hsu <kenny.hsu@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-sv-open.c  |   20 ++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-testmode.h |    4 +++-
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sv-open.c b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
index a8d0ef6..4ea64d6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sv-open.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
@@ -575,7 +575,7 @@ static int iwl_testmode_trace(struct ieee80211_hw *hw, struct nlattr **tb)
 		}
 		priv->testmode_trace.num_chunks =
 			DIV_ROUND_UP(priv->testmode_trace.buff_size,
-				     TRACE_CHUNK_SIZE);
+				     DUMP_CHUNK_SIZE);
 		break;
 
 	case IWL_TM_CMD_APP2DEV_END_TRACE:
@@ -607,15 +607,15 @@ static int iwl_testmode_trace_dump(struct ieee80211_hw *hw, struct nlattr **tb,
 		idx = cb->args[4];
 		if (idx >= priv->testmode_trace.num_chunks)
 			return -ENOENT;
-		length = TRACE_CHUNK_SIZE;
+		length = DUMP_CHUNK_SIZE;
 		if (((idx + 1) == priv->testmode_trace.num_chunks) &&
-		    (priv->testmode_trace.buff_size % TRACE_CHUNK_SIZE))
+		    (priv->testmode_trace.buff_size % DUMP_CHUNK_SIZE))
 			length = priv->testmode_trace.buff_size %
-				TRACE_CHUNK_SIZE;
+				DUMP_CHUNK_SIZE;
 
 		NLA_PUT(skb, IWL_TM_ATTR_TRACE_DUMP, length,
 			priv->testmode_trace.trace_addr +
-			(TRACE_CHUNK_SIZE * idx));
+			(DUMP_CHUNK_SIZE * idx));
 		idx++;
 		cb->args[4] = idx;
 		return 0;
@@ -728,7 +728,7 @@ static int iwl_testmode_sram(struct ieee80211_hw *hw, struct nlattr **tb)
 					priv->testmode_sram.buff_addr,
 					priv->testmode_sram.buff_size / 4);
 	priv->testmode_sram.num_chunks =
-		DIV_ROUND_UP(priv->testmode_sram.buff_size, TRACE_CHUNK_SIZE);
+		DIV_ROUND_UP(priv->testmode_sram.buff_size, DUMP_CHUNK_SIZE);
 	priv->testmode_sram.sram_readed = true;
 	return 0;
 }
@@ -746,15 +746,15 @@ static int iwl_testmode_sram_dump(struct ieee80211_hw *hw, struct nlattr **tb,
 			iwl_sram_cleanup(priv);
 			return -ENOENT;
 		}
-		length = TRACE_CHUNK_SIZE;
+		length = DUMP_CHUNK_SIZE;
 		if (((idx + 1) == priv->testmode_sram.num_chunks) &&
-		    (priv->testmode_sram.buff_size % TRACE_CHUNK_SIZE))
+		    (priv->testmode_sram.buff_size % DUMP_CHUNK_SIZE))
 			length = priv->testmode_sram.buff_size %
-				TRACE_CHUNK_SIZE;
+				DUMP_CHUNK_SIZE;
 
 		NLA_PUT(skb, IWL_TM_ATTR_SRAM_DUMP, length,
 			priv->testmode_sram.buff_addr +
-			(TRACE_CHUNK_SIZE * idx));
+			(DUMP_CHUNK_SIZE * idx));
 		idx++;
 		cb->args[4] = idx;
 		return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.h b/drivers/net/wireless/iwlwifi/iwl-testmode.h
index 95c8705..e20f3d3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.h
@@ -250,6 +250,8 @@ enum iwl_tm_attr_t {
 #define TRACE_BUFF_SIZE_MIN	0x20000
 #define TRACE_BUFF_SIZE_DEF	TRACE_BUFF_SIZE_MIN
 #define TRACE_BUFF_PADD		0x2000
-#define TRACE_CHUNK_SIZE	(PAGE_SIZE - 1024)
+
+/* Maximum data size of each dump it packet */
+#define DUMP_CHUNK_SIZE		(PAGE_SIZE - 1024)
 
 #endif
-- 
1.7.0.4

