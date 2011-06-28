Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42784 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab1F1Wz5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 18:55:57 -0400
Received: by bwd5 with SMTP id 5so570864bwd.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jun 2011 15:55:56 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: HT-PHY: correct 0x2059 radio init
Date: Wed, 29 Jun 2011 00:56:49 +0200
Message-Id: <1309301809-22931-1-git-send-email-zajec5@gmail.com> (sfid-20110629_005601_959740_913AEBEF)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes additional steps are performed while initializing 2059 radio.
We did not find the condition yet, so make it always true for now.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
As always, ops were found by fooling closed driver with MMIO ops:

1) Faking 0x0000 reads to find bits for SET ops:
 radio_read(0x0804) -> 0x0000
radio_write(0x0804) <- 0x0001
udelay(10)
 radio_read(0x08bf) -> 0x0000
radio_write(0x08bf) <- 0x0001
 radio_read(0x099b) -> 0x0000
radio_write(0x099b) <- 0x0002
 radio_read(0x0804) -> 0x0000
radio_write(0x0804) <- 0x0002
udelay(100);
 radio_read(0x0804) -> 0x0000
radio_write(0x0804) <- 0x0000
 radio_read(0x0945) -> 0x0018
(...)
 radio_read(0x0945) -> 0x0018
 radio_read(0x0804) -> 0x0000
radio_write(0x0804) <- 0x0000
 radio_read(0x000a) -> 0x0000
radio_write(0x000a) <- 0x0060

radio_write(0x017f) <- 0x0061
radio_write(0x013d) <- 0x006e
radio_write(0x013e) <- 0x00e9
radio_write(0x013c) <- 0x0055
 radio_read(0x0140) -> 0x0000
 radio_read(0x0140) -> 0x0001
 radio_read(0x0140) -> 0x0002
radio_write(0x013c) <- 0x0015

radio_write(0x017f) <- 0x0069
radio_write(0x013d) <- 0x006e
radio_write(0x013e) <- 0x00d5
radio_write(0x013c) <- 0x0055
 radio_read(0x0140) -> 0x0002
radio_write(0x013c) <- 0x0015

radio_write(0x017f) <- 0x0073
radio_write(0x013d) <- 0x006e
radio_write(0x013e) <- 0x0099
radio_write(0x013c) <- 0x0055
 radio_read(0x0140) -> 0x0002
radio_write(0x013c) <- 0x0015

 radio_read(0x017f) -> 0x0000
radio_write(0x017f) <- 0x0000

2) Faking 0xFFFF reads to find bits for MASK ops:
 radio_read(0x0804) -> 0xffff
radio_write(0x0804) <- 0xffff
udelay(10)
 radio_read(0x08bf) -> 0xffff
radio_write(0x08bf) <- 0xffff
 radio_read(0x099b) -> 0xffff
radio_write(0x099b) <- 0xfffe
 radio_read(0x0804) -> 0xffff
radio_write(0x0804) <- 0xffff
 radio_read(0x0804) -> 0xffff
radio_write(0x0804) <- 0xfffd
 radio_read(0x0945) -> 0x001e
(...)
 radio_read(0x0945) -> 0x003d
 radio_read(0x0804) -> 0xffff
radio_write(0x0804) <- 0xfffe
 radio_read(0x000a) -> 0xffff
radio_write(0x000a) <- 0xffff

radio_write(0x017f) <- 0x0061
radio_write(0x013d) <- 0x006e
radio_write(0x013e) <- 0x00e9
radio_write(0x013c) <- 0x0055
 radio_read(0x0140) -> 0x0000
 radio_read(0x0140) -> 0x0001
 radio_read(0x0140) -> 0x0002
radio_write(0x013c) <- 0x0015

radio_write(0x017f) <- 0x0069
radio_write(0x013d) <- 0x006e
radio_write(0x013e) <- 0x00d5
radio_write(0x013c) <- 0x0055
 radio_read(0x0140) -> 0x0002
radio_write(0x013c) <- 0x0015

radio_write(0x017f) <- 0x0073
radio_write(0x013d) <- 0x006e
radio_write(0x013e) <- 0x0099
radio_write(0x013c) <- 0x0055
 radio_read(0x0140) -> 0x0002
radio_write(0x013c) <- 0x0015

 radio_read(0x017f) -> 0xffff
radio_write(0x017f) <- 0xfffe
---
 drivers/net/wireless/b43/phy_ht.c |   50 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 49 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 69412d1..30b19c6 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -86,7 +86,10 @@ static void b43_radio_2059_channel_setup(struct b43_wldev *dev,
 static void b43_radio_2059_init(struct b43_wldev *dev)
 {
 	const u16 routing[] = { R2059_SYN, R2059_TXRX0, R2059_RXRX1 };
-	u8 i;
+	const u16 radio_values[3][2] = {
+		{ 0x61, 0xE9 }, { 0x69, 0xD5 }, { 0x73, 0x99 },
+	};
+	u16 i, j;
 
 	b43_radio_write(dev, R2059_ALL | 0x51, 0x0070);
 	b43_radio_write(dev, R2059_ALL | 0x5a, 0x0003);
@@ -100,6 +103,51 @@ static void b43_radio_2059_init(struct b43_wldev *dev)
 	b43_radio_mask(dev, 0x2e, ~0x0078);
 	b43_radio_mask(dev, 0xc0, ~0x0080);
 
+	if (1) { /* FIXME */
+		b43_radio_set(dev, R2059_RXRX1 | 0x4, 0x1);
+		udelay(10);
+		b43_radio_set(dev, R2059_RXRX1 | 0x0BF, 0x1);
+		b43_radio_maskset(dev, R2059_RXRX1 | 0x19B, 0x3, 0x2);
+
+		b43_radio_set(dev, R2059_RXRX1 | 0x4, 0x2);
+		udelay(100);
+		b43_radio_mask(dev, R2059_RXRX1 | 0x4, ~0x2);
+
+		for (i = 0; i < 10000; i++) {
+			if (b43_radio_read(dev, R2059_RXRX1 | 0x145) & 1) {
+				i = 0;
+				break;
+			}
+			udelay(100);
+		}
+		if (i)
+			b43err(dev->wl, "radio 0x945 timeout\n");
+
+		b43_radio_mask(dev, R2059_RXRX1 | 0x4, ~0x1);
+		b43_radio_set(dev, 0xa, 0x60);
+
+		for (i = 0; i < 3; i++) {
+			b43_radio_write(dev, 0x17F, radio_values[i][0]);
+			b43_radio_write(dev, 0x13D, 0x6E);
+			b43_radio_write(dev, 0x13E, radio_values[i][1]);
+			b43_radio_write(dev, 0x13C, 0x55);
+
+			for (j = 0; j < 10000; j++) {
+				if (b43_radio_read(dev, 0x140) & 2) {
+					j = 0;
+					break;
+				}
+				udelay(500);
+			}
+			if (j)
+				b43err(dev->wl, "radio 0x140 timeout\n");
+
+			b43_radio_write(dev, 0x13C, 0x15);
+		}
+
+		b43_radio_mask(dev, 0x17F, ~0x1);
+	}
+
 	b43_radio_mask(dev, 0x11, 0x0008);
 }
 
-- 
1.7.1

