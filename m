Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:45476 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334Ab2GBIda (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 04:33:30 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] iwlegacy: don't mess up the SCD when removing a key
Date: Mon,  2 Jul 2012 14:31:21 +0300
Message-Id: <1341228681-19358-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20120702_103334_348648_AFB8D292)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we remove a key, we put a key index which was supposed
to tell the fw that we are actually removing the key. But
instead the fw took that index as a valid index and messed
up the SRAM of the device.

This memory corruption on the device mangled the data of
the SCD. The impact on the user is that SCD queue 2 got
stuck after having removed keys.

Change-Id: I721f71c1a3a0af6058abe1975cebd9b613c7ff2b
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
Paul, can you please test ?
If it solve the issues for you, I will send as a patch and Cc stable Totally not tested
v2: first hunk of this patch thanks to Stanislaw's review
---
 drivers/net/wireless/iwlegacy/4965-mac.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index d24eaf8..34f61a0 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -3405,7 +3405,7 @@ il4965_remove_dynamic_key(struct il_priv *il,
 		return 0;
 	}
 
-	if (il->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET) {
+	if (il->stations[sta_id].sta.key.key_flags & STA_KEY_FLG_INVALID) {
 		IL_WARN("Removing wrong key %d 0x%x\n", keyconf->keyidx,
 			key_flags);
 		spin_unlock_irqrestore(&il->sta_lock, flags);
@@ -3420,7 +3420,7 @@ il4965_remove_dynamic_key(struct il_priv *il,
 	memset(&il->stations[sta_id].sta.key, 0, sizeof(struct il4965_keyinfo));
 	il->stations[sta_id].sta.key.key_flags =
 	    STA_KEY_FLG_NO_ENC | STA_KEY_FLG_INVALID;
-	il->stations[sta_id].sta.key.key_offset = WEP_INVALID_OFFSET;
+	il->stations[sta_id].sta.key.key_offset = keyconf->hw_key_idx;
 	il->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
 	il->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 
-- 
1.7.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

