Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753595Ab0BBOhr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2010 09:37:47 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: stable@kernel.org, "John W. Linville" <linville@tuxdriver.com>,
	Chris Siebenmann <cks-rhbugzilla@cs.toronto.edu>,
	Dan Williams <dcbw@redhat.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] airo: fix setting zero length WEP key
Date: Tue,  2 Feb 2010 15:34:50 +0100
Message-Id: <1265121290-2969-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch prevents call set_wep_key() with zero key length. That fix long
standing regression since commit c0380693520b1a1e4f756799a0edc379378b462a
"airo: clean up WEP key operations". Additionally print call trace when
someone will try to use improper parameters, and remove key.len = 0
assignment, because it is in not possible code path.

Reported-and-bisected-by: Chris Siebenmann <cks-rhbugzilla@cs.toronto.edu>
Cc: Dan Williams <dcbw@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/airo.c |   34 ++++++++++++++++++----------------
 1 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 4331d67..2a9f029 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -5254,11 +5254,7 @@ static int set_wep_key(struct airo_info *ai, u16 index, const char *key,
 	WepKeyRid wkr;
 	int rc;
 
-	if (keylen == 0) {
-		airo_print_err(ai->dev->name, "%s: key length to set was zero",
-			       __func__);
-		return -1;
-	}
+	WARN_ON(keylen == 0);
 
 	memset(&wkr, 0, sizeof(wkr));
 	wkr.len = cpu_to_le16(sizeof(wkr));
@@ -6405,11 +6401,7 @@ static int airo_set_encode(struct net_device *dev,
 		if (dwrq->length > MIN_KEY_SIZE)
 			key.len = MAX_KEY_SIZE;
 		else
-			if (dwrq->length > 0)
-				key.len = MIN_KEY_SIZE;
-			else
-				/* Disable the key */
-				key.len = 0;
+			key.len = MIN_KEY_SIZE;
 		/* Check if the key is not marked as invalid */
 		if(!(dwrq->flags & IW_ENCODE_NOKEY)) {
 			/* Cleanup */
@@ -6590,12 +6582,22 @@ static int airo_set_encodeext(struct net_device *dev,
 		default:
 			return -EINVAL;
 		}
-		/* Send the key to the card */
-		rc = set_wep_key(local, idx, key.key, key.len, perm, 1);
-		if (rc < 0) {
-			airo_print_err(local->dev->name, "failed to set WEP key"
-			               " at index %d: %d.", idx, rc);
-			return rc;
+		if (key.len == 0) {
+			rc = set_wep_tx_idx(local, idx, perm, 1);
+			if (rc < 0) {
+				airo_print_err(local->dev->name,
+					       "failed to set WEP transmit index to %d: %d.",
+					       idx, rc);
+				return rc;
+			}
+		} else {
+			rc = set_wep_key(local, idx, key.key, key.len, perm, 1);
+			if (rc < 0) {
+				airo_print_err(local->dev->name,
+					       "failed to set WEP key at index %d: %d.",
+					       idx, rc);
+				return rc;
+			}
 		}
 	}
 
-- 
1.6.2.5

