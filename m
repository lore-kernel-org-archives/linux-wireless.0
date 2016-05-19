Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:35014 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895AbcESN7Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2016 09:59:25 -0400
From: Muhammad Falak R Wani <falakreyaz@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] brcmfmac: use kmemdup
Date: Thu, 19 May 2016 19:29:03 +0530
Message-Id: <1463666357-16719-1-git-send-email-falakreyaz@gmail.com> (sfid-20160519_155945_576298_8AA9D2BA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use kmemdup when some other buffer is immediately copied into allocated
region. It replaces call to allocation followed by memcpy, by a single
call to kmemdup.

Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index d0631b6..705adaa 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6699,11 +6699,10 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 		return NULL;
 	}
 
-	ops = kzalloc(sizeof(*ops), GFP_KERNEL);
+	ops = kmemdup(&brcmf_cfg80211_ops, sizeof(*ops), GFP_KERNEL);
 	if (!ops)
 		return NULL;
 
-	memcpy(ops, &brcmf_cfg80211_ops, sizeof(*ops));
 	ifp = netdev_priv(ndev);
 #ifdef CONFIG_PM
 	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_WOWL_GTK))
-- 
1.9.1

