Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:51899 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412Ab2IBSKr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Sep 2012 14:10:47 -0400
Subject: [PATCH] zd1211rw: enable support for MFP
To: "John W. Linville" <linville@tuxdriver.com>
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 02 Sep 2012 21:10:44 +0300
Message-ID: <20120902181044.13855.82225.stgit@localhost6.localdomain6> (sfid-20120902_201054_151375_A0B58F45)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

zd1211rw lacks hardware encryption, so enabling 802.11w is only matter of
enabling IEEE80211_HW_MFP_CAPABLE flag.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_mac.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 4598801..114364b 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -1401,7 +1401,8 @@ struct ieee80211_hw *zd_mac_alloc_hw(struct usb_interface *intf)
 
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 		    IEEE80211_HW_SIGNAL_UNSPEC |
-		    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING;
+		    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
+		    IEEE80211_HW_MFP_CAPABLE;
 
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_MESH_POINT) |

