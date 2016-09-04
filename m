Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from libra.uberspace.de ([95.143.172.171]:50707 "EHLO
        libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754317AbcIDT2w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 4 Sep 2016 15:28:52 -0400
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
Subject: [PATCH 3/5] drivers: staging: rtl8723au: core: Refactor pointless branching
Date: Sun,  4 Sep 2016 21:26:24 +0200
Message-Id: <20160904192626.17197-4-mail@beyermatthias.de> (sfid-20160904_212855_768716_03D34520)
In-Reply-To: <20160904192626.17197-1-mail@beyermatthias.de>
References: <20160904192626.17197-1-mail@beyermatthias.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As ether_addr_equal returns a bool, we can simply use the return value
to set the variable.

Signed-off-by: Matthias Beyer <mail@beyermatthias.de>
Signed-off-by: Manuel Messner <manuel.johannes.messner@hs-furtwangen.de>
---
 drivers/staging/rtl8723au/core/rtw_mlme.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_mlme.c b/drivers/staging/rtl8723au/core/rtw_mlme.c
index da9f298..196447b 100644
--- a/drivers/staging/rtl8723au/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723au/core/rtw_mlme.c
@@ -1062,11 +1062,8 @@ void rtw_joinbss_event_prehandle23a(struct rtw_adapter *adapter, u8 *pbuf)
 			 pmlmepriv->assoc_ssid.ssid);
 	}
 
-	if (ether_addr_equal(pnetwork->network.MacAddress,
-			     cur_network->network.MacAddress))
-		the_same_macaddr = true;
-	else
-		the_same_macaddr = false;
+	the_same_macaddr = ether_addr_equal(pnetwork->network.MacAddress,
+					    cur_network->network.MacAddress);
 
 	pnetwork->network.Length = get_wlan_bssid_ex_sz(&pnetwork->network);
 	if (pnetwork->network.Length > sizeof(struct wlan_bssid_ex)) {
-- 
2.9.3
