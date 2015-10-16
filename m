Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:34600 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbbJPJYM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 05:24:12 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 09/13] staging: wilc1000: add_key: use netdev private wilc instead of wl
Date: Fri, 16 Oct 2015 18:23:05 +0900
Message-ID: <1444987389-14151-9-git-send-email-tony.cho@atmel.com> (sfid-20151016_112425_752324_E52D3E6B)
In-Reply-To: <1444987389-14151-1-git-send-email-tony.cho@atmel.com>
References: <1444987389-14151-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

Use netdev private data member wilc instead of global variable wl.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 97d9929..f96f5b8 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1083,8 +1083,12 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 	u8 u8gmode = NO_ENCRYPT;
 	u8 u8pmode = NO_ENCRYPT;
 	enum AUTHTYPE tenuAuth_type = ANY;
+	struct wilc *wl;
+	perInterface_wlan_t *nic;
 
 	priv = wiphy_priv(wiphy);
+	nic = netdev_priv(netdev);
+	wl = nic->wilc;
 
 	PRINT_D(CFG80211_DBG, "Adding key with cipher suite = %x\n", params->cipher);
 
-- 
1.9.1

