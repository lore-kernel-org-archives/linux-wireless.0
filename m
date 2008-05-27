Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.233]:14631 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbYE0FNg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2008 01:13:36 -0400
Received: by rv-out-0506.google.com with SMTP id l9so2745950rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 May 2008 22:13:36 -0700 (PDT)
From: Joonwoo Park <joonwpark81@gmail.com>
Cc: Joonwoo Park <joonwpark81@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] iwlwifi: fix oops on wep key insertion
Date: Mon, 26 May 2008 22:13:34 -0700
Message-Id: <1211865214-1640-1-git-send-email-joonwpark81@gmail.com> (sfid-20080527_071400_683903_9A8844A5)
In-Reply-To: <>
References: <>
To: Zhu Yi <yi.zhu@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix overflow which is occured by long wep key configuring.
Also, this patch contains some cleanup for not to do memcpy with
zero size.

$sudo iwconfig wlan0 enc AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA

BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [memcpy_c+0xb/0x20] memcpy_c+0xb/0x20
PGD 13a590067 PUD 12e471067 PMD 0
Oops: 0000 [1] PREEMPT SMP
CPU 1
...
Pid: 10, comm: events/1 Not tainted 2.6.26-rc2 #9
...
Call Trace:
 [iwl4965:iwl4965_rx_scan_start_notif+0xb/0x20] ? :iwl4965:iwl4965_enqueue_hcmd+0x12b/0x220
 [hci_usb:init_module+0xe97/0x28cb0] :iwlcore:iwl_send_cmd_sync+0x67/0x290
 [save_trace+0x3f/0xb0] ? save_trace+0x3f/0xb0
...

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
---
 drivers/net/wireless/iwlwifi/iwl-sta.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index e4fdfaa..c3dd138 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -51,7 +51,7 @@ int iwl_get_free_ucode_key_index(struct iwl_priv *priv)
 
 int iwl_send_static_wepkey_cmd(struct iwl_priv *priv, u8 send_if_empty)
 {
-	int i, not_empty = 0;
+	int i, left, not_empty = 0;
 	u8 buff[sizeof(struct iwl_wep_cmd) +
 		sizeof(struct iwl_wep_key) * WEP_KEYS_MAX];
 	struct iwl_wep_cmd *wep_cmd = (struct iwl_wep_cmd *)buff;
@@ -67,16 +67,20 @@ int iwl_send_static_wepkey_cmd(struct iwl_priv *priv, u8 send_if_empty)
 
 	for (i = 0; i < WEP_KEYS_MAX ; i++) {
 		wep_cmd->key[i].key_index = i;
-		if (priv->wep_keys[i].key_size) {
+		wep_cmd->key[i].key_size = priv->wep_keys[i].key_size;
+		left = sizeof(wep_cmd->key[i].key)
+			- sizeof(wep_cmd->key[i].key[0]) * 3;
+		BUG_ON(left < 0);
+
+		if (wep_cmd->key[i].key_size
+		    && left >= wep_cmd->key[i].key_size) {
 			wep_cmd->key[i].key_offset = i;
 			not_empty = 1;
+			memcpy(&wep_cmd->key[i].key[3], priv->wep_keys[i].key,
+				wep_cmd->key[i].key_size);
 		} else {
 			wep_cmd->key[i].key_offset = WEP_INVALID_OFFSET;
 		}
-
-		wep_cmd->key[i].key_size = priv->wep_keys[i].key_size;
-		memcpy(&wep_cmd->key[i].key[3], priv->wep_keys[i].key,
-				priv->wep_keys[i].key_size);
 	}
 
 	wep_cmd->global_key_type = WEP_KEY_WEP_TYPE;
-- 
1.5.4.3

