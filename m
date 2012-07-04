Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab2GDL7j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 07:59:39 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Paul Bolle <pebolle@tiscali.nl>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 3.5] iwlegacy: don't mess up the SCD when removing a key
Date: Wed,  4 Jul 2012 13:59:08 +0200
Message-Id: <1341403148-3360-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20120704_135948_361242_A1F2E61E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we remove a key, we put a key index which was supposed
to tell the fw that we are actually removing the key. But
instead the fw took that index as a valid index and messed
up the SRAM of the device.

This memory corruption on the device mangled the data of
the SCD. The impact on the user is that SCD queue 2 got
stuck after having removed keys.

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Cc: stable@vger.kernel.org
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
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

