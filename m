Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3773 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933840Ab2JLK23 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2012 06:28:29 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 2/3] wireless: gelic: make use of
 WLAN_EID_VENDOR_SPECIFIC
Date: Fri, 12 Oct 2012 12:28:15 +0200
Message-ID: <1350037696-23747-3-git-send-email-arend@broadcom.com> (sfid-20121012_123401_617334_C00100F1)
In-Reply-To: <1350037696-23747-1-git-send-email-arend@broadcom.com>
References: <1350037696-23747-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The include file linux/ieee80211.h contains three definitions for
the same thing in enum ieee80211_eid due to historic changes:

    /* Information Element IDs */
    enum ieee80211_eid {
        :
        WLAN_EID_WPA = 221,
        WLAN_EID_GENERIC = 221,
        WLAN_EID_VENDOR_SPECIFIC = 221,
        :
    };

The standard refers to this as "vendor specific" element so the
other two definitions are better not used. This patch changes the
wireless drivers to use one definition, ie. WLAN_EID_VENDOR_SPECIFIC.

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
For some reason this driver resides in the net/ethernet driver
directory. Still decided to tag the patch as a wireless patch.

The other strange thing is that I could not find how to select
this driver. Using ps3_defconfig for ARCH=powerpc and following
the clues from Kconfig search function I can not get
"Toshiba devices" showing up. So this one is not compile tested.

Gr. AvS
---
 drivers/net/ethernet/toshiba/ps3_gelic_wireless.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_wireless.c b/drivers/net/ethernet/toshiba/ps3_gelic_wireless.c
index 961c832..72b775f 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_wireless.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_wireless.c
@@ -452,7 +452,7 @@ static size_t gelic_wl_synthesize_ie(u8 *buf,
 	if (rsn)
 		*buf++ = WLAN_EID_RSN;
 	else
-		*buf++ = WLAN_EID_GENERIC;
+		*buf++ = WLAN_EID_VENDOR_SPECIFIC;
 
 	/* length filed; set later */
 	buf++;
@@ -540,7 +540,7 @@ static void gelic_wl_parse_ie(u8 *data, size_t len,
 			break;
 
 		switch (item_id) {
-		case WLAN_EID_GENERIC:
+		case WLAN_EID_VENDOR_SPECIFIC:
 			if ((OUI_LEN + 1 <= item_len) &&
 			    !memcmp(pos, wpa_oui, OUI_LEN) &&
 			    pos[OUI_LEN] == 0x01) {
-- 
1.7.9.5


