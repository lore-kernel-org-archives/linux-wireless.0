Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:58832 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935768AbcJXPj2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 11:39:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Kurt Kanzenbach <kurt@kmk-computers.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8192x: fix bogus maybe-uninitialized warning
Date: Mon, 24 Oct 2016 17:38:34 +0200
Message-Id: <20161024153918.2810634-1-arnd@arndb.de> (sfid-20161024_173952_119403_76EE32FF)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rtllib_rx_extract_addr() is supposed to set up the mac addresses
for four possible cases, based on two bits of input data. For
some reason, gcc decides that it's possible that none of the these
four cases apply and the addresses remain uninitialized:

drivers/staging/rtl8192e/rtllib_rx.c: In function ‘rtllib_rx_InfraAdhoc’:
include/linux/etherdevice.h:316:61: error: ‘*((void *)&dst+4)’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
drivers/staging/rtl8192e/rtllib_rx.c:1318:5: note: ‘*((void *)&dst+4)’ was declared here
ded from /git/arm-soc/drivers/staging/rtl8192e/rtllib_rx.c:40:0:
include/linux/etherdevice.h:316:36: error: ‘dst’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
drivers/staging/rtl8192e/rtllib_rx.c:1318:5: note: ‘dst’ was declared here

This warning is clearly nonsense, but changing the last case into
'default' makes it obvious to the compiler too, which avoids the
warning and probably leads to better object code too.

As the same warning appears in other files that have the exact
same code, I'm fixing it in both rtl8192e and rtl8192u, even
though I did not observe it for the latter.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/rtl8192e/rtllib_rx.c                      | 2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c | 2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c         | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtllib_rx.c b/drivers/staging/rtl8192e/rtllib_rx.c
index c743182b933e..d6777ecda64d 100644
--- a/drivers/staging/rtl8192e/rtllib_rx.c
+++ b/drivers/staging/rtl8192e/rtllib_rx.c
@@ -986,7 +986,7 @@ static void rtllib_rx_extract_addr(struct rtllib_device *ieee,
 		ether_addr_copy(src, hdr->addr4);
 		ether_addr_copy(bssid, ieee->current_network.bssid);
 		break;
-	case 0:
+	default:
 		ether_addr_copy(dst, hdr->addr1);
 		ether_addr_copy(src, hdr->addr2);
 		ether_addr_copy(bssid, hdr->addr3);
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
index 6fa96d57d316..e68850897adf 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
@@ -553,7 +553,7 @@ static void michael_mic_hdr(struct sk_buff *skb, u8 *hdr)
 		memcpy(hdr, hdr11->addr3, ETH_ALEN); /* DA */
 		memcpy(hdr + ETH_ALEN, hdr11->addr4, ETH_ALEN); /* SA */
 		break;
-	case 0:
+	default:
 		memcpy(hdr, hdr11->addr1, ETH_ALEN); /* DA */
 		memcpy(hdr + ETH_ALEN, hdr11->addr2, ETH_ALEN); /* SA */
 		break;
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
index 89cbc077a48d..2e4d2d7bc2e7 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
@@ -1079,7 +1079,7 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 		memcpy(src, hdr->addr4, ETH_ALEN);
 		memcpy(bssid, ieee->current_network.bssid, ETH_ALEN);
 		break;
-	case 0:
+	default:
 		memcpy(dst, hdr->addr1, ETH_ALEN);
 		memcpy(src, hdr->addr2, ETH_ALEN);
 		memcpy(bssid, hdr->addr3, ETH_ALEN);
-- 
2.9.0
