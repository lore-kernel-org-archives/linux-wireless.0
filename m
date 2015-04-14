Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:21965 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050AbbDNSLN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2015 14:11:13 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 02/10] brcmfmac: update wiphy band information upon updating regulatory domain
Date: Tue, 14 Apr 2015 20:10:25 +0200
Message-ID: <1429035033-14076-3-git-send-email-arend@broadcom.com> (sfid-20150414_201136_862772_2316F2A7)
In-Reply-To: <1429035033-14076-1-git-send-email-arend@broadcom.com>
References: <1429035033-14076-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When change the country code the available channels may change. So
the wiphy bands should be updated accordingly.

Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index 76dff0e..84d9ab1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -6023,7 +6023,11 @@ static void brcmf_cfg80211_reg_notifier(struct wiphy *wiphy,
 	memset(&ccreq, 0, sizeof(ccreq));
 	ccreq.rev = cpu_to_le32(-1);
 	memcpy(ccreq.ccode, req->alpha2, sizeof(req->alpha2));
-	brcmf_fil_iovar_data_set(ifp, "country", &ccreq, sizeof(ccreq));
+	if (brcmf_fil_iovar_data_set(ifp, "country", &ccreq, sizeof(ccreq))) {
+		brcmf_err("firmware rejected country setting\n");
+		return;
+	}
+	brcmf_setup_wiphybands(wiphy);
 }
 
 static void brcmf_free_wiphy(struct wiphy *wiphy)
-- 
1.9.1

