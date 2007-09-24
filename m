Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:54466 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750878AbXIXWNR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 18:13:17 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 2/6] adm8211: Improve writing of mac addrs to registers
Date: Mon, 24 Sep 2007 18:10:25 -0400
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20070924221025.6870.67251.stgit@magic.sourmilk.net>
In-Reply-To: <20070924221025.6870.53754.stgit@magic.sourmilk.net>
References: <20070924221025.6870.53754.stgit@magic.sourmilk.net>
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

The mac address write is broken for big endian and the bssid write can be
simplified. This patch does both.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/adm8211.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index 0893d0d..4c43cdb 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -1283,8 +1283,7 @@ static void adm8211_set_bssid(struct ieee80211_hw *dev, const u8 *bssid)
 	struct adm8211_priv *priv = dev->priv;
 	u32 reg;
 
-	reg = bssid[0] | (bssid[1] << 8) | (bssid[2] << 16) | (bssid[3] << 24);
-	ADM8211_CSR_WRITE(BSSID0, reg);
+	ADM8211_CSR_WRITE(BSSID0, le32_to_cpu(*(__le32 *)bssid));
 	reg = ADM8211_CSR_READ(ABDA1);
 	reg &= 0x0000ffff;
 	reg |= (bssid[4] << 16) | (bssid[5] << 24);
@@ -1414,8 +1413,8 @@ static int adm8211_add_interface(struct ieee80211_hw *dev,
 
 	ADM8211_IDLE();
 
-	ADM8211_CSR_WRITE(PAR0, *(u32 *)conf->mac_addr);
-	ADM8211_CSR_WRITE(PAR1, *(u16 *)(conf->mac_addr + 4));
+	ADM8211_CSR_WRITE(PAR0, le32_to_cpu(*(__le32 *)conf->mac_addr));
+	ADM8211_CSR_WRITE(PAR1, le16_to_cpu(*(__le16 *)(conf->mac_addr + 4)));
 
 	adm8211_update_mode(dev);
 

