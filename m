Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33823 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab1FSJjO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2011 05:39:14 -0400
Received: by mail-ey0-f174.google.com with SMTP id 24so247938eyx.19
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jun 2011 02:39:13 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/3] b43: HT-PHY: switch radio to requested channel
Date: Sun, 19 Jun 2011 12:17:21 +0200
Message-Id: <1308478641-6207-3-git-send-email-zajec5@gmail.com> (sfid-20110619_113923_680636_FDCE4B66)
In-Reply-To: <1308478641-6207-1-git-send-email-zajec5@gmail.com>
References: <1308478641-6207-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Switching channel happens after specific SHM write to B43_SHM_SH_CHAN.
This is the way we found it in BCM4331 MMIO dumps. By comparing with
N-PHY code we noticed there is routing used for SYN and TX/RX.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
For curious ones, there goes dump from BCM4331, that was used to write
the code.

>>> SHM write start
write32 0xb0600160 <- 0x00010028
 read32 0xb0600160 -> 0x00010028
write16 0xb0600164 <- 0x000b
>>> SHM write end

radio_write(0x0016) <- 0x0069
radio_write(0x0017) <- 0x0016
radio_write(0x0022) <- 0x0030
radio_write(0x0025) <- 0x001b
radio_write(0x0027) <- 0x000a
radio_write(0x0028) <- 0x000a
radio_write(0x0029) <- 0x0030
radio_write(0x002c) <- 0x009e
radio_write(0x002d) <- 0x0009
radio_write(0x0037) <- 0x000f
radio_write(0x0041) <- 0x0006
radio_write(0x0043) <- 0x0000
radio_write(0x0047) <- 0x0006
radio_write(0x004a) <- 0x0000
radio_write(0x0058) <- 0x0061
radio_write(0x005a) <- 0x0003
radio_write(0x006a) <- 0x0000
radio_write(0x006d) <- 0x0000
radio_write(0x006e) <- 0x0000
radio_write(0x0092) <- 0x00f0
radio_write(0x0098) <- 0x0000

radio_write(0x044a) <- 0x0000
radio_write(0x0458) <- 0x0061
radio_write(0x045a) <- 0x0003
radio_write(0x046a) <- 0x0000
radio_write(0x046d) <- 0x0000
radio_write(0x046e) <- 0x0000
radio_write(0x0492) <- 0x00f0
radio_write(0x0498) <- 0x0000

radio_write(0x084a) <- 0x0000
radio_write(0x0858) <- 0x0061
radio_write(0x085a) <- 0x0003
radio_write(0x086a) <- 0x0000
radio_write(0x086d) <- 0x0000
radio_write(0x086e) <- 0x0000
radio_write(0x0892) <- 0x00f0
radio_write(0x0898) <- 0x0000

>>> Something different happening with udelay 30
 radio_read(0x002b) -> 0x0008
radio_write(0x002b) <- 0x0008
---
 drivers/net/wireless/b43/phy_ht.c     |   39 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/b43/radio_2059.h |   30 ++++++++++++++++++++++++-
 2 files changed, 68 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 12ad47f..0b13f6f 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -30,6 +30,45 @@
 static void b43_radio_2059_channel_setup(struct b43_wldev *dev,
 			const struct b43_phy_ht_channeltab_e_radio2059 *e)
 {
+	u8 i;
+	u16 routing;
+
+	b43_radio_write(dev, 0x16, e->radio_syn16);
+	b43_radio_write(dev, 0x17, e->radio_syn17);
+	b43_radio_write(dev, 0x22, e->radio_syn22);
+	b43_radio_write(dev, 0x25, e->radio_syn25);
+	b43_radio_write(dev, 0x27, e->radio_syn27);
+	b43_radio_write(dev, 0x28, e->radio_syn28);
+	b43_radio_write(dev, 0x29, e->radio_syn29);
+	b43_radio_write(dev, 0x2c, e->radio_syn2c);
+	b43_radio_write(dev, 0x2d, e->radio_syn2d);
+	b43_radio_write(dev, 0x37, e->radio_syn37);
+	b43_radio_write(dev, 0x41, e->radio_syn41);
+	b43_radio_write(dev, 0x43, e->radio_syn43);
+	b43_radio_write(dev, 0x47, e->radio_syn47);
+	b43_radio_write(dev, 0x4a, e->radio_syn4a);
+	b43_radio_write(dev, 0x58, e->radio_syn58);
+	b43_radio_write(dev, 0x5a, e->radio_syn5a);
+	b43_radio_write(dev, 0x6a, e->radio_syn6a);
+	b43_radio_write(dev, 0x6d, e->radio_syn6d);
+	b43_radio_write(dev, 0x6e, e->radio_syn6e);
+	b43_radio_write(dev, 0x92, e->radio_syn92);
+	b43_radio_write(dev, 0x98, e->radio_syn98);
+
+	for (i = 0; i < 2; i++) {
+		routing = i ? 0x800 : 0x400;
+		b43_radio_write(dev, routing | 0x4a, e->radio_rxtx4a);
+		b43_radio_write(dev, routing | 0x58, e->radio_rxtx58);
+		b43_radio_write(dev, routing | 0x5a, e->radio_rxtx5a);
+		b43_radio_write(dev, routing | 0x6a, e->radio_rxtx6a);
+		b43_radio_write(dev, routing | 0x6d, e->radio_rxtx6d);
+		b43_radio_write(dev, routing | 0x6e, e->radio_rxtx6e);
+		b43_radio_write(dev, routing | 0x92, e->radio_rxtx92);
+		b43_radio_write(dev, routing | 0x98, e->radio_rxtx98);
+	}
+
+	udelay(50);
+
 	/* TODO */
 }
 
diff --git a/drivers/net/wireless/b43/radio_2059.h b/drivers/net/wireless/b43/radio_2059.h
index 69eb46e..c2874b1 100644
--- a/drivers/net/wireless/b43/radio_2059.h
+++ b/drivers/net/wireless/b43/radio_2059.h
@@ -10,7 +10,35 @@ struct b43_phy_ht_channeltab_e_radio2059 {
 	/* The channel frequency in MHz */
 	u16 freq;
 	/* Values for radio registers */
-	/* TODO */
+	u8 radio_syn16;
+	u8 radio_syn17;
+	u8 radio_syn22;
+	u8 radio_syn25;
+	u8 radio_syn27;
+	u8 radio_syn28;
+	u8 radio_syn29;
+	u8 radio_syn2c;
+	u8 radio_syn2d;
+	u8 radio_syn37;
+	u8 radio_syn41;
+	u8 radio_syn43;
+	u8 radio_syn47;
+	u8 radio_syn4a;
+	u8 radio_syn58;
+	u8 radio_syn5a;
+	u8 radio_syn6a;
+	u8 radio_syn6d;
+	u8 radio_syn6e;
+	u8 radio_syn92;
+	u8 radio_syn98;
+	u8 radio_rxtx4a;
+	u8 radio_rxtx58;
+	u8 radio_rxtx5a;
+	u8 radio_rxtx6a;
+	u8 radio_rxtx6d;
+	u8 radio_rxtx6e;
+	u8 radio_rxtx92;
+	u8 radio_rxtx98;
 	/* Values for PHY registers */
 	struct b43_phy_ht_channeltab_e_phy phy_regs;
 };
-- 
1.7.3.4

