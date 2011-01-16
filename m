Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45476 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab1APJHD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Jan 2011 04:07:03 -0500
Received: by fxm20 with SMTP id 20so4652221fxm.19
        for <linux-wireless@vger.kernel.org>; Sun, 16 Jan 2011 01:07:02 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] wl12xx: fix some endianess bugs
Date: Sun, 16 Jan 2011 11:07:10 +0200
Message-Id: <1295168830-4637-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pointed out by sparse warnings:

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
v1->v2: 
	don't use the underscore versions of the casting functions
	rephrase commit message

 drivers/net/wireless/wl12xx/acx.c |    2 +-
 drivers/net/wireless/wl12xx/cmd.c |    2 +-
 drivers/net/wireless/wl12xx/tx.c  |    6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index 646d278..679bb37 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -813,7 +813,7 @@ int wl1271_acx_ap_rate_policy(struct wl1271 *wl, struct conf_tx_rate_class *c,
 	acx->rate_policy.long_retry_limit = c->long_retry_limit;
 	acx->rate_policy.aflags = c->aflags;
 
-	acx->rate_policy_idx = idx;
+	acx->rate_policy_idx = cpu_to_le32(idx);
 
 	ret = wl1271_cmd_configure(wl, ACX_RATE_POLICY, acx, sizeof(*acx));
 	if (ret < 0) {
diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index e28d9ca..1bb8be5 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -984,7 +984,7 @@ int wl1271_cmd_start_bss(struct wl1271 *wl)
 
 	memcpy(cmd->bssid, bss_conf->bssid, ETH_ALEN);
 
-	cmd->aging_period = WL1271_AP_DEF_INACTIV_SEC;
+	cmd->aging_period = cpu_to_le16(WL1271_AP_DEF_INACTIV_SEC);
 	cmd->bss_index = WL1271_AP_BSS_INDEX;
 	cmd->global_hlid = WL1271_AP_GLOBAL_HLID;
 	cmd->broadcast_hlid = WL1271_AP_BROADCAST_HLID;
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 2347f25..3507c81 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -195,9 +195,9 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 	desc->tx_attr = cpu_to_le16(tx_attr);
 
 	wl1271_debug(DEBUG_TX, "tx_fill_hdr: pad: %d hlid: %d "
-		"tx_attr: 0x%x len: %d life: %d mem: %d", pad, (int)desc->hlid,
-		(int)desc->tx_attr, (int)desc->length, (int)desc->life_time,
-		(int)desc->total_mem_blocks);
+		"tx_attr: 0x%x len: %d life: %d mem: %d", pad, desc->hlid,
+		le16_to_cpu(desc->tx_attr), le16_to_cpu(desc->length),
+		le16_to_cpu(desc->life_time), desc->total_mem_blocks);
 }
 
 /* caller must hold wl->mutex */
-- 
1.7.0.4

