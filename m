Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:36119 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529AbbEaAwh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 May 2015 20:52:37 -0400
Received: by wgbgq6 with SMTP id gq6so88567157wgb.3
        for <linux-wireless@vger.kernel.org>; Sat, 30 May 2015 17:52:36 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] brcmfmac: set wiphy perm_addr to hardware MAC address
Date: Sun, 31 May 2015 02:52:26 +0200
Message-Id: <1433033546-19214-1-git-send-email-zajec5@gmail.com> (sfid-20150531_025255_199909_404E5C19)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows e.g. user space to use /sys/class/ieee80211/*/macaddress

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index 6fe2b75..955dd0a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -6071,6 +6071,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 		brcmf_err("Could not allocate wiphy device\n");
 		return NULL;
 	}
+	memcpy(wiphy->perm_addr, drvr->mac, ETH_ALEN);
 	set_wiphy_dev(wiphy, busdev);
 
 	cfg = wiphy_priv(wiphy);
-- 
1.8.4.5

