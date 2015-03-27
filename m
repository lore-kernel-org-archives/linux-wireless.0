Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:36738 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbbC0IYn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2015 04:24:43 -0400
Received: by labe2 with SMTP id e2so64610476lab.3
        for <linux-wireless@vger.kernel.org>; Fri, 27 Mar 2015 01:24:42 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/2] ath10k: fix arvif->wep_keys clearing
Date: Fri, 27 Mar 2015 08:21:55 +0000
Message-Id: <1427444516-974-1-git-send-email-michal.kazior@tieto.com> (sfid-20150327_092448_563272_CBFE5A65)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The variable should be cleared regardless of
whether there's a peer associated with the key or
not.

This fixes case when user first associates with 2
WEP keys and then disconnects and connects with 1
WEP key. This resulted in WEP key count being 2 in
the driver leading to default keyidx fixup
failure.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 9b8313dcb888..9d873900257d 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4101,6 +4101,13 @@ static int ath10k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	key->hw_key_idx = key->keyidx;
 
+	if (is_wep) {
+		if (cmd == SET_KEY)
+			arvif->wep_keys[key->keyidx] = key;
+		else
+			arvif->wep_keys[key->keyidx] = NULL;
+	}
+
 	/* the peer should not disappear in mid-way (unless FW goes awry) since
 	 * we already hold conf_mutex. we just make sure its there now. */
 	spin_lock_bh(&ar->data_lock);
@@ -4126,11 +4133,6 @@ static int ath10k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		flags |= WMI_KEY_GROUP;
 
 	if (is_wep) {
-		if (cmd == SET_KEY)
-			arvif->wep_keys[key->keyidx] = key;
-		else
-			arvif->wep_keys[key->keyidx] = NULL;
-
 		if (cmd == DISABLE_KEY)
 			ath10k_clear_vdev_key(arvif, key);
 
-- 
2.1.4

