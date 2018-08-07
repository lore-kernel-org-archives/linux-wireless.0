Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0118.outbound.protection.outlook.com ([104.47.41.118]:1880
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733061AbeHGIbQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Aug 2018 04:31:16 -0400
From: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
To: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Winnie Chang <winnie.chang@cypress.com>
Subject: [PATCH] brcmfmac: fix brcmf_wiphy_wowl_params() NULL pointer dereference
Date: Tue,  7 Aug 2018 01:18:06 -0500
Message-Id: <1533622686-145733-1-git-send-email-chi-hsien.lin@cypress.com> (sfid-20180807_081930_809181_28361BE3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winnie Chang <winnie.chang@cypress.com>

The kernel BUG happens when wowl is enabled from firmware. In
brcmf_wiphy_wowl_params(), cfg is a NULL pointer because it is
drvr->config returned from wiphy_to_cfg(), and drvr->config is not set
yet. To fix it, set drvr->config before brcmf_setup_wiphy() which
calls brcmf_wiphy_wowl_params().

The kernel panic is introduced in below commit:
commit id: 856d5a011c86b59f6564be4508912fb1d866adfc
brcmfmac: allocate struct brcmf_pub instance using wiphy_new()

Signed-off-by: Winnie Chang <winnie.chang@cypress.com>
Reviewed-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 24c4e18..5444e62 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6926,15 +6926,15 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 	cfg->d11inf.io_type = (u8)io_type;
 	brcmu_d11_attach(&cfg->d11inf);
 
-	err = brcmf_setup_wiphy(wiphy, ifp);
-	if (err < 0)
-		goto priv_out;
-
 	/* regulatory notifer below needs access to cfg so
 	 * assign it now.
 	 */
 	drvr->config = cfg;
 
+	err = brcmf_setup_wiphy(wiphy, ifp);
+	if (err < 0)
+		goto priv_out;
+
 	brcmf_dbg(INFO, "Registering custom regulatory\n");
 	wiphy->reg_notifier = brcmf_cfg80211_reg_notifier;
 	wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG;
-- 
2.1.0
