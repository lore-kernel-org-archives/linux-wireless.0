Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from libra.uberspace.de ([95.143.172.171]:50572 "EHLO
        libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753391AbcIDT2U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 4 Sep 2016 15:28:20 -0400
From: Matthias Beyer <mail@beyermatthias.de>
To: gregkh@linuxfoundation.org
Cc: Matthias Beyer <mail@beyermatthias.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Manuel Messner <manuel.johannes.messner@hs-furtwangen.de>,
        Geliang Tang <geliangtang@163.com>,
        Cihangir Akturk <cakturk@gmail.com>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] drivers: staging: rtl8723au: core: simplify if-break-else
Date: Sun,  4 Sep 2016 21:26:23 +0200
Message-Id: <20160904192626.17197-3-mail@beyermatthias.de> (sfid-20160904_212823_554512_B6956426)
In-Reply-To: <20160904192626.17197-1-mail@beyermatthias.de>
References: <20160904192626.17197-1-mail@beyermatthias.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As the if statement breaks/continues the loop, the else block is not
useful and can be omitted.

Signed-off-by: Matthias Beyer <mail@beyermatthias.de>
Signed-off-by: Manuel Messner <manuel.johannes.messner@hs-furtwangen.de>
---
 drivers/staging/rtl8723au/core/rtw_mlme.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_mlme.c b/drivers/staging/rtl8723au/core/rtw_mlme.c
index 8b8b6a9..da9f298 100644
--- a/drivers/staging/rtl8723au/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723au/core/rtw_mlme.c
@@ -244,21 +244,18 @@ static void _rtw_roaming(struct rtw_adapter *padapter,
 			do_join_r = rtw_do_join(padapter);
 			if (do_join_r == _SUCCESS)
 				break;
-			else {
-				DBG_8723A("roaming do_join return %d\n",
-					  do_join_r);
-				pmlmepriv->to_roaming--;
 
-				if (padapter->mlmepriv.to_roaming > 0)
-					continue;
-				else {
-					DBG_8723A("%s(%d) -to roaming fail, "
-						  "indicate_disconnect\n",
-						  __func__, __LINE__);
-					rtw_indicate_disconnect23a(padapter);
-					break;
-				}
-			}
+			DBG_8723A("roaming do_join return %d\n", do_join_r);
+			pmlmepriv->to_roaming--;
+
+			if (padapter->mlmepriv.to_roaming > 0)
+				continue;
+
+			DBG_8723A("%s(%d) -to roaming fail, "
+				  "indicate_disconnect\n",
+				  __func__, __LINE__);
+			rtw_indicate_disconnect23a(padapter);
+			break;
 		}
 	}
 }
-- 
2.9.3
