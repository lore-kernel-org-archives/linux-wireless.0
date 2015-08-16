Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:35395 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbbHPFaq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Aug 2015 01:30:46 -0400
From: =?UTF-8?q?Rapha=C3=ABl=20Beamonte?= <raphael.beamonte@gmail.com>
To: Johnny Kim <johnny.kim@atmel.com>
Cc: =?UTF-8?q?Rapha=C3=ABl=20Beamonte?= <raphael.beamonte@gmail.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] staging: wilc1000: code style: fix open brace { on wrong line
Date: Sun, 16 Aug 2015 01:30:14 -0400
Message-Id: <4ff9d3514f6e035a1e872ade6ae78e5f87c6aff2.1439702894.git.raphael.beamonte@gmail.com> (sfid-20150816_073128_788590_0F3F1093)
In-Reply-To: <cover.1439702894.git.raphael.beamonte@gmail.com>
References: <cover.1439702894.git.raphael.beamonte@gmail.com>
In-Reply-To: <cover.1439702894.git.raphael.beamonte@gmail.com>
References: <cover.1439702894.git.raphael.beamonte@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Open braces should be on the same line as if and for statements.

Signed-off-by: Raphaël Beamonte <raphael.beamonte@gmail.com>
---
 drivers/staging/wilc1000/linux_wlan.c             | 3 +--
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 7eacc2f..040e55d 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -2103,8 +2103,7 @@ static void wilc_set_multicast_list(struct net_device *dev)
 	}
 
 	/* Store all of the multicast addresses in the hardware filter */
-	netdev_for_each_mc_addr(ha, dev)
-	{
+	netdev_for_each_mc_addr(ha, dev) {
 		memcpy(gau8MulticastMacAddrList[i], ha->addr, ETH_ALEN);
 		PRINT_D(INIT_DBG, "Entry[%d]: %x:%x:%x:%x:%x:%x\n", i,
 			gau8MulticastMacAddrList[i][0], gau8MulticastMacAddrList[i][1], gau8MulticastMacAddrList[i][2], gau8MulticastMacAddrList[i][3], gau8MulticastMacAddrList[i][4], gau8MulticastMacAddrList[i][5]);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index c2f8d60..29f43d6 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1527,8 +1527,7 @@ static int WILC_WFI_get_key(struct wiphy *wiphy, struct net_device *netdev, u8 k
 	priv = wiphy_priv(wiphy);
 
 
-	if (!pairwise)
-	{
+	if (!pairwise) {
 		PRINT_D(CFG80211_DBG, "Getting group key idx: %x\n", key_index);
 
 		key_params.key = priv->wilc_gtk[key_index]->key;
-- 
2.1.4

