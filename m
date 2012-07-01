Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:52000 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab2GAKJO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jul 2012 06:09:14 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Paul Bolle <pebolle@tiscali.nl>
Subject: [RFT] iwlegacy: don't mess up the SCD when removing a key
Date: Sun,  1 Jul 2012 16:07:03 +0300
Message-Id: <1341148023-17673-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20120701_120950_434668_3B316AC4)
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

Cc: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
Paul, can you please test ?
If it solve the issues for you, I will send as a patch and Cc stable
Totally not tested
---

 drivers/net/wireless/iwlegacy/4965-mac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index d24eaf8..9981f09 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
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

