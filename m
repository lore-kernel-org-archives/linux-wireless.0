Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:35394 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbbGIPHb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2015 11:07:31 -0400
Received: by labgy5 with SMTP id gy5so95974255lab.2
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2015 08:07:30 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] brcmfmac: set wiphy's addresses to provide valid MACs
Date: Thu,  9 Jul 2015 17:07:08 +0200
Message-Id: <1436454428-24077-1-git-send-email-zajec5@gmail.com> (sfid-20150709_170735_480687_1C142AF7)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Broadcom's firmware requires every BSS to use MAC address with unique
last few bits. The amount of bits may depend on a particular firmware,
it was verified to be 2 for BCM43602 one.
If this condition won't be fulfilled firmware will reject such MAC:
brcmfmac: _brcmf_set_mac_address: Setting cur_etheraddr failed, -52

We don't want to simply set addr_mask as it would also disallow using
locally administrated bit. Instead let's build a list of addresses
manually enabling 0x2 bit for extra interfaces.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 14 ++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/core.h     |  3 +++
 2 files changed, 17 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index d86d1f1..ffe5260 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -5785,6 +5785,7 @@ static void brcmf_wiphy_wowl_params(struct wiphy *wiphy)
 
 static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 {
+	struct brcmf_pub *drvr = ifp->drvr;
 	struct ieee80211_supported_band *band;
 	__le32 bandlist[3];
 	u32 n_bands;
@@ -5798,6 +5799,19 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 	if (err)
 		return err;
 
+	for (i = 0; i < wiphy->iface_combinations->max_interfaces &&
+	     i < ARRAY_SIZE(drvr->addresses); i++) {
+		u8 *addr = drvr->addresses[i].addr;
+
+		memcpy(addr, drvr->mac, ETH_ALEN);
+		if (i) {
+			addr[0] |= BIT(1);
+			addr[ETH_ALEN - 1] ^= i;
+		}
+	}
+	wiphy->addresses = drvr->addresses;
+	wiphy->n_addresses = i;
+
 	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
 	wiphy->cipher_suites = __wl_cipher_suites;
 	wiphy->n_cipher_suites = ARRAY_SIZE(__wl_cipher_suites);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.h b/drivers/net/wireless/brcm80211/brcmfmac/core.h
index fd74a9c..7463041 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.h
@@ -21,6 +21,7 @@
 #ifndef BRCMFMAC_CORE_H
 #define BRCMFMAC_CORE_H
 
+#include <net/cfg80211.h>
 #include "fweh.h"
 
 #define TOE_TX_CSUM_OL		0x00000001
@@ -118,6 +119,8 @@ struct brcmf_pub {
 	/* Multicast data packets sent to dongle */
 	unsigned long tx_multicast;
 
+	struct mac_address addresses[BRCMF_MAX_IFS];
+
 	struct brcmf_if *iflist[BRCMF_MAX_IFS];
 
 	struct mutex proto_block;
-- 
1.8.4.5

