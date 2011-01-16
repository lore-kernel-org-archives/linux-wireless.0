Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32899 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab1APHti (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Jan 2011 02:49:38 -0500
Received: by wyb28 with SMTP id 28so4169280wyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 15 Jan 2011 23:49:37 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: fix some sparse warnings
Date: Sun, 16 Jan 2011 09:49:44 +0200
Message-Id: <1295164184-25592-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

fix the following warnings:

  CHECK   drivers/net/wireless/wl12xx/cmd.c
drivers/net/wireless/wl12xx/cmd.c:987:20: warning: incorrect type in assignment (different base types)
drivers/net/wireless/wl12xx/cmd.c:987:20:    expected restricted __le16 [usertype] aging_period
drivers/net/wireless/wl12xx/cmd.c:987:20:    got int
  CHECK   drivers/net/wireless/wl12xx/tx.c
drivers/net/wireless/wl12xx/tx.c:197:2: warning: cast from restricted __le16
drivers/net/wireless/wl12xx/tx.c:197:2: warning: cast from restricted __le16
drivers/net/wireless/wl12xx/tx.c:197:2: warning: cast from restricted __le16
  CHECK   drivers/net/wireless/wl12xx/acx.c
drivers/net/wireless/wl12xx/acx.c:816:23: warning: incorrect type in assignment (different base types)
drivers/net/wireless/wl12xx/acx.c:816:23:    expected restricted __le32 [usertype] rate_policy_idx
drivers/net/wireless/wl12xx/acx.c:816:23:    got unsigned char [unsigned] [usertype] idx

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c |    2 +-
 drivers/net/wireless/wl12xx/cmd.c |    2 +-
 drivers/net/wireless/wl12xx/tx.c  |    6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index 646d278..df73a21 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -813,7 +813,7 @@ int wl1271_acx_ap_rate_policy(struct wl1271 *wl, struct conf_tx_rate_class *c,
 	acx->rate_policy.long_retry_limit = c->long_retry_limit;
 	acx->rate_policy.aflags = c->aflags;
 
-	acx->rate_policy_idx = idx;
+	acx->rate_policy_idx = __cpu_to_le32(idx);
 
 	ret = wl1271_cmd_configure(wl, ACX_RATE_POLICY, acx, sizeof(*acx));
 	if (ret < 0) {
diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index e28d9ca..6ce188d 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -984,7 +984,7 @@ int wl1271_cmd_start_bss(struct wl1271 *wl)
 
 	memcpy(cmd->bssid, bss_conf->bssid, ETH_ALEN);
 
-	cmd->aging_period = WL1271_AP_DEF_INACTIV_SEC;
+	cmd->aging_period = __cpu_to_le16(WL1271_AP_DEF_INACTIV_SEC);
 	cmd->bss_index = WL1271_AP_BSS_INDEX;
 	cmd->global_hlid = WL1271_AP_GLOBAL_HLID;
 	cmd->broadcast_hlid = WL1271_AP_BROADCAST_HLID;
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 2347f25..209d4db 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -195,9 +195,9 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 	desc->tx_attr = cpu_to_le16(tx_attr);
 
 	wl1271_debug(DEBUG_TX, "tx_fill_hdr: pad: %d hlid: %d "
-		"tx_attr: 0x%x len: %d life: %d mem: %d", pad, (int)desc->hlid,
-		(int)desc->tx_attr, (int)desc->length, (int)desc->life_time,
-		(int)desc->total_mem_blocks);
+		"tx_attr: 0x%x len: %d life: %d mem: %d", pad, desc->hlid,
+		__le16_to_cpu(desc->tx_attr), __le16_to_cpu(desc->length),
+		__le16_to_cpu(desc->life_time), desc->total_mem_blocks);
 }
 
 /* caller must hold wl->mutex */
-- 
1.7.0.4

