Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:34916 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758669AbYCDSR0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 13:17:26 -0500
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH] rndis_wlan: fix broken data copy
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Date: Tue, 04 Mar 2008 20:05:27 +0200
Message-ID: <20080304180527.11879.86782.stgit@localhost> (sfid-20080304_181730_008920_93A390EC)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace broken code that attempted to copy 6 byte array to 64-bit
integer. Due to missing cast to 64-bit integer, left shift operation
were 32-bit and lead to bytes been copied over each other. New code 
uses simple memcpy, for greater readability and efficiency.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index d9460ae..10b776c 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -260,7 +260,7 @@ struct NDIS_802_11_KEY {
 	__le32 KeyLength;
 	u8 Bssid[6];
 	u8 Padding[6];
-	__le64 KeyRSC;
+	u8 KeyRSC[8];
 	u8 KeyMaterial[32];
 } __attribute__((packed));
 
@@ -1508,7 +1508,7 @@ static int rndis_iw_set_encode_ext(struct net_device *dev,
 	struct usbnet *usbdev = dev->priv;
 	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
 	struct NDIS_802_11_KEY ndis_key;
-	int i, keyidx, ret;
+	int keyidx, ret;
 	u8 *addr;
 
 	keyidx = wrqu->encoding.flags & IW_ENCODE_INDEX;
@@ -1543,9 +1543,7 @@ static int rndis_iw_set_encode_ext(struct net_device *dev,
 	ndis_key.KeyIndex = cpu_to_le32(keyidx);
 
 	if (ext->ext_flags & IW_ENCODE_EXT_RX_SEQ_VALID) {
-		for (i = 0; i < 6; i++)
-			ndis_key.KeyRSC |=
-				cpu_to_le64(ext->rx_seq[i] << (i * 8));
+		memcpy(ndis_key.KeyRSC, ext->rx_seq, 6);
 		ndis_key.KeyIndex |= cpu_to_le32(1 << 29);
 	}
 

