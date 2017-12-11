Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bn3nam01on0125.outbound.protection.outlook.com ([104.47.33.125]:18656
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751307AbdLKHig (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 02:38:36 -0500
From: Wright Feng <wright.feng@cypress.com>
To: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@codeaurora.org,
        chi-hsien.lin@cypress.com
Cc: wright.feng@cypress.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com
Subject: [PATCH] brcmfmac: enlarge buffer size of caps to 512 bytes
Date: Mon, 11 Dec 2017 15:38:21 +0800
Message-Id: <1512977901-12726-1-git-send-email-wright.feng@cypress.com> (sfid-20171211_083841_186772_EB726480)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The buffer size of return of cap iovar is greater than 256 bytes in some
firmwares. For instance, the return size of cap iovar is 271 bytes in 4373
13.10.246.79 firmare. It makes feature capability parsing failed because
caps buffer is default value.
So we enlarge caps buffer size to 512 bytes and add the error print for
cap iovar error.

Signed-off-by: Wright Feng <wright.feng@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index 53ae302..47de35a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -130,13 +130,19 @@ static void brcmf_feat_iovar_data_set(struct brcmf_if *ifp,
 	}
 }
 
+#define MAX_CAPS_BUFFER_SIZE	512
 static void brcmf_feat_firmware_capabilities(struct brcmf_if *ifp)
 {
-	char caps[256];
+	char caps[MAX_CAPS_BUFFER_SIZE];
 	enum brcmf_feat_id id;
-	int i;
+	int i, err;
+
+	err = brcmf_fil_iovar_data_get(ifp, "cap", caps, sizeof(caps));
+	if (err) {
+		brcmf_err("could not get firmware cap (%d)\n", err);
+		return;
+	}
 
-	brcmf_fil_iovar_data_get(ifp, "cap", caps, sizeof(caps));
 	brcmf_dbg(INFO, "[ %s]\n", caps);
 
 	for (i = 0; i < ARRAY_SIZE(brcmf_fwcap_map); i++) {
-- 
1.9.1
