Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366AbcB2WFx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:53 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 008/113] rtl8xxxu: Init the LLT after we start the firmware
Date: Mon, 29 Feb 2016 17:04:06 -0500
Message-Id: <1456783551-28315-9-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232952_335623_3836876C)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

To match the flow of the vendor driver, move the LLT init to after the
firmware is started.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index a17d88e..a817208 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -4342,6 +4342,15 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		rtl8xxxu_write8(priv, REG_TDECTRL + 1, val8);
 	}
 
+	ret = rtl8xxxu_download_firmware(priv);
+	dev_dbg(dev, "%s: download_fiwmare %i\n", __func__, ret);
+	if (ret)
+		goto exit;
+	ret = rtl8xxxu_start_firmware(priv);
+	dev_dbg(dev, "%s: start_fiwmare %i\n", __func__, ret);
+	if (ret)
+		goto exit;
+
 	ret = rtl8xxxu_init_queue_priority(priv);
 	dev_dbg(dev, "%s: init_queue_priority %i\n", __func__, ret);
 	if (ret)
@@ -4356,15 +4365,6 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		}
 	}
 
-	ret = rtl8xxxu_download_firmware(priv);
-	dev_dbg(dev, "%s: download_fiwmare %i\n", __func__, ret);
-	if (ret)
-		goto exit;
-	ret = rtl8xxxu_start_firmware(priv);
-	dev_dbg(dev, "%s: start_fiwmare %i\n", __func__, ret);
-	if (ret)
-		goto exit;
-
 	ret = rtl8xxxu_init_mac(priv, rtl8723a_mac_init_table);
 	dev_dbg(dev, "%s: init_mac %i\n", __func__, ret);
 	if (ret)
-- 
2.5.0

