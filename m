Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:53976 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378Ab1BRVOC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 16:14:02 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 13:13:41 -0800
From: Vipin Mehta <vmehta@atheros.com>
To: <greg@kroah.com>
CC: <linux-wireless@vger.kernel.org>, <vmehta@atheros.com>,
	<devel@driverdev.osuosl.org>
Subject: [PATCH 02/15] staging: ath6kl: Fixing key settings for WPA/WPA2
Date: Fri, 18 Feb 2011 13:13:03 -0800
Message-ID: <1298063596-2096-2-git-send-email-vmehta@atheros.com>
In-Reply-To: <1298063596-2096-1-git-send-email-vmehta@atheros.com>
References: <1298063596-2096-1-git-send-email-vmehta@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A bug was observed during the reconnection phase in the WPA/WPA2-PSK scenario
where the EAPOL frames were going encrypted during an auto reconnection
attempt. The initial 4-way handshake would go fine but then the driver
was getting a command to set default keys sometime later. Setting of an
incorrect flag (TX_USAGE) in the hadrware was causing the EAPOL frames during
the subsequent 4-way handshake attempts to go encrypted causing the AP to
reject the station.

Signed-off-by: Vipin Mehta <vmehta@atheros.com>
---
 drivers/staging/ath6kl/os/linux/cfg80211.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/cfg80211.c b/drivers/staging/ath6kl/os/linux/cfg80211.c
index 1a4e315..b7742d4 100644
--- a/drivers/staging/ath6kl/os/linux/cfg80211.c
+++ b/drivers/staging/ath6kl/os/linux/cfg80211.c
@@ -983,6 +983,7 @@ ar6k_cfg80211_set_default_key(struct wiphy *wiphy, struct net_device *ndev,
     AR_SOFTC_T *ar = (AR_SOFTC_T *)ar6k_priv(ndev);
     struct ar_key *key = NULL;
     int status = 0;
+    u8 key_usage;
 
     AR_DEBUG_PRINTF(ATH_DEBUG_INFO, ("%s: index %d\n", __func__, key_index));
 
@@ -1011,8 +1012,13 @@ ar6k_cfg80211_set_default_key(struct wiphy *wiphy, struct net_device *ndev,
 
     ar->arDefTxKeyIndex = key_index;
     key = &ar->keys[ar->arDefTxKeyIndex];
+    key_usage = GROUP_USAGE;
+    if (WEP_CRYPT == ar->arPairwiseCrypto) {
+        key_usage |= TX_USAGE;
+    }
+
     status = wmi_addKey_cmd(ar->arWmi, ar->arDefTxKeyIndex,
-                            ar->arPairwiseCrypto, GROUP_USAGE | TX_USAGE,
+                            ar->arPairwiseCrypto, key_usage,
                             key->key_len, key->seq, key->key, KEY_OP_INIT_VAL,
                             NULL, SYNC_BOTH_WMIFLAG);
     if (status) {
-- 
1.6.3.3

