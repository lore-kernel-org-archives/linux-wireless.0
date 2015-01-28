Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:60190 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755260AbbA2B1j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2015 20:27:39 -0500
From: Robert Dolca <robert.dolca@intel.com>
To: linux-nfc@lists.01.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Berg Johannes <johannes.berg@intel.com>,
	Clement Perrochaud <clement.perrochaud@nxp.com>,
	Robert Dolca <robert.dolca@intel.com>
Subject: [RFC] NFC: PN544: Supply the right length to skb_trim
Date: Thu, 29 Jan 2015 01:50:46 +0200
Message-Id: <1422489046-6087-1-git-send-email-robert.dolca@intel.com> (sfid-20150129_022800_044908_BA1E77B8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 2nd parameter of skb_trim is the new length of the skb.

pn544_hci_i2c_remove_len_crc used the tailroom for the 2nd parameter so
the new length was 2 no metter how big the skb was.
Now the length is (skb->len - PN544_I2C_FRAME_TAILROOM)

Signed-off-by: Robert Dolca <robert.dolca@intel.com>
---
 drivers/nfc/pn544/i2c.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/pn544/i2c.c b/drivers/nfc/pn544/i2c.c
index 58b9029..42e7b26 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -297,7 +297,7 @@ static void pn544_hci_i2c_add_len_crc(struct sk_buff *skb)
 static void pn544_hci_i2c_remove_len_crc(struct sk_buff *skb)
 {
 	skb_pull(skb, PN544_I2C_FRAME_HEADROOM);
-	skb_trim(skb, PN544_I2C_FRAME_TAILROOM);
+	skb_trim(skb, skb->len - PN544_I2C_FRAME_TAILROOM);
 }
 
 /*
@@ -411,8 +411,7 @@ static int pn544_hci_i2c_read(struct pn544_i2c_phy *phy, struct sk_buff **skb)
 		goto flush;
 	}
 
-	skb_pull(*skb, 1);
-	skb_trim(*skb, (*skb)->len - 2);
+	pn544_hci_i2c_remove_len_crc(*skb);
 
 	usleep_range(3000, 6000);
 
-- 
1.9.1

