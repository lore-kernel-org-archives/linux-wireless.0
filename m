Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from libra.uberspace.de ([95.143.172.171]:51057 "EHLO
        libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754069AbcIDT35 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 4 Sep 2016 15:29:57 -0400
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
Subject: [PATCH 5/5] drivers: staging: rtl8723au: core: Fix indentation
Date: Sun,  4 Sep 2016 21:26:26 +0200
Message-Id: <20160904192626.17197-6-mail@beyermatthias.de> (sfid-20160904_213017_447378_FA1D50FE)
In-Reply-To: <20160904192626.17197-1-mail@beyermatthias.de>
References: <20160904192626.17197-1-mail@beyermatthias.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Matthias Beyer <mail@beyermatthias.de>
Signed-off-by: Manuel Messner <manuel.johannes.messner@hs-furtwangen.de>
---
 drivers/staging/rtl8723au/core/rtw_mlme.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_mlme.c b/drivers/staging/rtl8723au/core/rtw_mlme.c
index 1e01d62..1c31774 100644
--- a/drivers/staging/rtl8723au/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723au/core/rtw_mlme.c
@@ -1921,17 +1921,17 @@ static int rtw_append_pmkid(struct rtw_adapter *Adapter, int iEntry,
 	struct security_priv *psecuritypriv = &Adapter->securitypriv;
 
 	if (ie[1] <= 20) {
-		/*  The RSN IE didn't include the PMK ID,
-		    append the PMK information */
-			ie[ie_len] = 1;
-			ie_len++;
-			ie[ie_len] = 0;	/* PMKID count = 0x0100 */
-			ie_len++;
-			memcpy(&ie[ie_len],
-			       &psecuritypriv->PMKIDList[iEntry].PMKID, 16);
-
-			ie_len += 16;
-			ie[1] += 18;/* PMKID length = 2+16 */
+		/* The RSN IE didn't include the PMK ID,
+		   append the PMK information */
+		ie[ie_len] = 1;
+		ie_len++;
+		ie[ie_len] = 0;	/* PMKID count = 0x0100 */
+		ie_len++;
+		memcpy(&ie[ie_len],
+		       &psecuritypriv->PMKIDList[iEntry].PMKID, 16);
+
+		ie_len += 16;
+		ie[1] += 18;/* PMKID length = 2+16 */
 	}
 	return ie_len;
 }
-- 
2.9.3
