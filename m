Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36671 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751273AbeEFHde (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 6 May 2018 03:33:34 -0400
From: Nathan Chancellor <natechancellor@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH 3/3] staging: wilc1000: Remove unnecessary array index check
Date: Sun,  6 May 2018 00:33:33 -0700
Message-Id: <20180506073333.3770-3-natechancellor@gmail.com> (sfid-20180506_093343_688843_BC18B7E3)
In-Reply-To: <20180506073333.3770-1-natechancellor@gmail.com>
References: <20180506073333.3770-1-natechancellor@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This statment triggers GCC's -Wtype-limit since key_index is an
unsigned integer so it cannot be less than zero.

Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index b499fb987395..e0015ca6c21a 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1054,7 +1054,7 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 		}
 	}
 
-	if (key_index >= 0 && key_index <= 3 && priv->wep_key_len[key_index]) {
+	if (key_index <= 3 && priv->wep_key_len[key_index]) {
 		memset(priv->wep_key[key_index], 0,
 		       priv->wep_key_len[key_index]);
 		priv->wep_key_len[key_index] = 0;
-- 
2.17.0
