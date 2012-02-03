Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943Ab2BCQc7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 11:32:59 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2 15/25] iwlegacy: move qos_data out of ctx structure
Date: Fri,  3 Feb 2012 17:31:51 +0100
Message-Id: <1328286721-11309-16-git-send-email-sgruszka@redhat.com> (sfid-20120203_173307_613081_6D8EF21D)
In-Reply-To: <1328286721-11309-1-git-send-email-sgruszka@redhat.com>
References: <1328286721-11309-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/common.c |   24 ++++++++++++------------
 drivers/net/wireless/iwlegacy/common.h |    4 ++--
 drivers/net/wireless/iwlegacy/debug.c  |    9 ++++-----
 3 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 7f4c6bf..c93fa1b 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -4496,15 +4496,15 @@ il_mac_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif, u16 queue,
 
 	spin_lock_irqsave(&il->lock, flags);
 
-	il->ctx.qos_data.def_qos_parm.ac[q].cw_min =
+	il->qos_data.def_qos_parm.ac[q].cw_min =
 	    cpu_to_le16(params->cw_min);
-	il->ctx.qos_data.def_qos_parm.ac[q].cw_max =
+	il->qos_data.def_qos_parm.ac[q].cw_max =
 	    cpu_to_le16(params->cw_max);
-	il->ctx.qos_data.def_qos_parm.ac[q].aifsn = params->aifs;
-	il->ctx.qos_data.def_qos_parm.ac[q].edca_txop =
+	il->qos_data.def_qos_parm.ac[q].aifsn = params->aifs;
+	il->qos_data.def_qos_parm.ac[q].edca_txop =
 	    cpu_to_le16((params->txop * 32));
 
-	il->ctx.qos_data.def_qos_parm.ac[q].reserved1 = 0;
+	il->qos_data.def_qos_parm.ac[q].reserved1 = 0;
 
 	spin_unlock_irqrestore(&il->lock, flags);
 
@@ -5230,20 +5230,20 @@ il_update_qos(struct il_priv *il, struct il_rxon_context *ctx)
 	if (!ctx->is_active)
 		return;
 
-	ctx->qos_data.def_qos_parm.qos_flags = 0;
+	il->qos_data.def_qos_parm.qos_flags = 0;
 
-	if (ctx->qos_data.qos_active)
-		ctx->qos_data.def_qos_parm.qos_flags |=
+	if (il->qos_data.qos_active)
+		il->qos_data.def_qos_parm.qos_flags |=
 		    QOS_PARAM_FLG_UPDATE_EDCA_MSK;
 
 	if (ctx->ht.enabled)
-		ctx->qos_data.def_qos_parm.qos_flags |= QOS_PARAM_FLG_TGN_MSK;
+		il->qos_data.def_qos_parm.qos_flags |= QOS_PARAM_FLG_TGN_MSK;
 
 	D_QOS("send QoS cmd with Qos active=%d FLAGS=0x%X\n",
-	      ctx->qos_data.qos_active, ctx->qos_data.def_qos_parm.qos_flags);
+	      il->qos_data.qos_active, il->qos_data.def_qos_parm.qos_flags);
 
 	il_send_cmd_pdu_async(il, C_QOS_PARAM, sizeof(struct il_qosparam_cmd),
-			      &ctx->qos_data.def_qos_parm, NULL);
+			      &il->qos_data.def_qos_parm, NULL);
 }
 
 /**
@@ -5596,7 +5596,7 @@ il_mac_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		unsigned long flags;
 
 		spin_lock_irqsave(&il->lock, flags);
-		ctx->qos_data.qos_active = bss_conf->qos;
+		il->qos_data.qos_active = bss_conf->qos;
 		il_update_qos(il, ctx);
 		spin_unlock_irqrestore(&il->lock, flags);
 	}
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index eddf22d..18375cb 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1165,8 +1165,6 @@ struct il_rxon_context {
 	 */
 	bool always_active, is_active;
 
-	struct il_qos_info qos_data;
-
 	struct {
 		bool non_gf_sta_present;
 		u8 protection;
@@ -1278,6 +1276,8 @@ struct il_priv {
 
 	struct il_rxon_context ctx;
 
+	struct il_qos_info qos_data;
+
 	/*
 	 * We declare this const so it can only be
 	 * changed via explicit cast within the
diff --git a/drivers/net/wireless/iwlegacy/debug.c b/drivers/net/wireless/iwlegacy/debug.c
index f3cb45e..3a9609a 100644
--- a/drivers/net/wireless/iwlegacy/debug.c
+++ b/drivers/net/wireless/iwlegacy/debug.c
@@ -644,7 +644,6 @@ il_dbgfs_qos_read(struct file *file, char __user *user_buf, size_t count,
 		  loff_t *ppos)
 {
 	struct il_priv *il = file->private_data;
-	struct il_rxon_context *ctx = &il->ctx;
 	int pos = 0, i;
 	char buf[256];
 	const size_t bufsz = sizeof(buf);
@@ -656,10 +655,10 @@ il_dbgfs_qos_read(struct file *file, char __user *user_buf, size_t count,
 		pos +=
 		    scnprintf(buf + pos, bufsz - pos,
 			      "AC[%d]\t%u\t%u\t%u\t%u\n", i,
-			      ctx->qos_data.def_qos_parm.ac[i].cw_min,
-			      ctx->qos_data.def_qos_parm.ac[i].cw_max,
-			      ctx->qos_data.def_qos_parm.ac[i].aifsn,
-			      ctx->qos_data.def_qos_parm.ac[i].edca_txop);
+			      il->qos_data.def_qos_parm.ac[i].cw_min,
+			      il->qos_data.def_qos_parm.ac[i].cw_max,
+			      il->qos_data.def_qos_parm.ac[i].aifsn,
+			      il->qos_data.def_qos_parm.ac[i].edca_txop);
 	}
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-- 
1.7.1

