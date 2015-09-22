Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33763 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbbIVJfZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 05:35:25 -0400
Received: by pacex6 with SMTP id ex6so4746921pac.0
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2015 02:35:25 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 07/16] staging: wilc1000: make add_virtual_intf static
Date: Tue, 22 Sep 2015 18:34:52 +0900
Message-Id: <1442914501-2315-7-git-send-email-chaehyun.lim@gmail.com> (sfid-20150922_113533_226310_725FBAFB)
In-Reply-To: <1442914501-2315-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442914501-2315-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes add_virtual_intf static. This function is used only at
wilc_wfi_cfgoperation.c file.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
v2: rebase latest staging-testing

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 0becefb..7d26ccd 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3321,10 +3321,12 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
  *  @date	01 JUL 2012
  *  @version	1.0
  */
-struct wireless_dev *add_virtual_intf(struct wiphy *wiphy, const char *name,
-				      unsigned char name_assign_type,
-				      enum nl80211_iftype type, u32 *flags,
-				      struct vif_params *params)
+static struct wireless_dev *add_virtual_intf(struct wiphy *wiphy,
+					     const char *name,
+					     unsigned char name_assign_type,
+					     enum nl80211_iftype type,
+					     u32 *flags,
+					     struct vif_params *params)
 {
 	perInterface_wlan_t *nic;
 	struct wilc_priv *priv;
-- 
2.5.1

