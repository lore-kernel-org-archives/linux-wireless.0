Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36145 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab0LUKuj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 05:50:39 -0500
Received: by mail-wy0-f174.google.com with SMTP id 28so3808933wyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Dec 2010 02:50:39 -0800 (PST)
From: =?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/4] b43: N-PHY: implement radio 2056 init steps
Date: Tue, 21 Dec 2010 11:50:20 +0100
Message-Id: <1292928622-27651-2-git-send-email-zajec5@gmail.com>
In-Reply-To: <1292928622-27651-1-git-send-email-zajec5@gmail.com>
References: <1292928622-27651-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
Changes since RFC: added initialization and inittabs call on PHY side, fixed
e increasing, added check to do not allow reading outside array.

Thanks Michael for reviewing.
---
 drivers/net/wireless/b43/phy_n.c      |   33 +++++++++++++-
 drivers/net/wireless/b43/radio_2056.c |   77 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/b43/radio_2056.h |    3 +
 3 files changed, 111 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index a1aa570..f0b264c 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -401,16 +401,45 @@ static void b43_radio_init2055(struct b43_wldev *dev)
 	b43_radio_init2055_post(dev);
 }
 
+static void b43_radio_init2056_pre(struct b43_wldev *dev)
+{
+	b43_phy_mask(dev, B43_NPHY_RFCTL_CMD,
+		     ~B43_NPHY_RFCTL_CMD_CHIP0PU);
+	/* Maybe wl meant to reset and set (order?) RFCTL_CMD_OEPORFORCE? */
+	b43_phy_mask(dev, B43_NPHY_RFCTL_CMD,
+		     B43_NPHY_RFCTL_CMD_OEPORFORCE);
+	b43_phy_set(dev, B43_NPHY_RFCTL_CMD,
+		    ~B43_NPHY_RFCTL_CMD_OEPORFORCE);
+	b43_phy_set(dev, B43_NPHY_RFCTL_CMD,
+		    B43_NPHY_RFCTL_CMD_CHIP0PU);
+}
+
+static void b43_radio_init2056_post(struct b43_wldev *dev)
+{
+	b43_radio_set(dev, B2056_SYN_COM_CTRL, 0xB);
+	b43_radio_set(dev, B2056_SYN_COM_PU, 0x2);
+	b43_radio_set(dev, B2056_SYN_COM_RESET, 0x2);
+	mdelay(1);
+	b43_radio_mask(dev, B2056_SYN_COM_RESET, ~0x2);
+	b43_radio_mask(dev, B2056_SYN_PLL_MAST2, ~0xFC);
+	b43_radio_mask(dev, B2056_SYN_RCCAL_CTRL0, ~0x1);
+	/*
+	if (nphy->init_por)
+		Call Radio 2056 Recalibrate
+	*/
+}
+
 /*
  * Initialize a Broadcom 2056 N-radio
  * http://bcm-v4.sipsolutions.net/802.11/Radio/2056/Init
  */
 static void b43_radio_init2056(struct b43_wldev *dev)
 {
-	/* TODO */
+	b43_radio_init2056_pre(dev);
+	b2056_upload_inittabs(dev, 0, 0);
+	b43_radio_init2056_post(dev);
 }
 
-
 /*
  * Upload the N-PHY tables.
  * http://bcm-v4.sipsolutions.net/802.11/PHY/N/InitTables
diff --git a/drivers/net/wireless/b43/radio_2056.c b/drivers/net/wireless/b43/radio_2056.c
index 0cdf6a4..1752d52 100644
--- a/drivers/net/wireless/b43/radio_2056.c
+++ b/drivers/net/wireless/b43/radio_2056.c
@@ -24,6 +24,39 @@
 #include "radio_2056.h"
 #include "phy_common.h"
 
+struct b2056_inittab_entry {
+	/* Value to write if we use the 5GHz band. */
+	u16 ghz5;
+	/* Value to write if we use the 2.4GHz band. */
+	u16 ghz2;
+	/* Flags */
+	u8 flags;
+};
+#define B2056_INITTAB_ENTRY_OK	0x01
+#define B2056_INITTAB_UPLOAD	0x02
+#define UPLOAD		.flags = B2056_INITTAB_ENTRY_OK | B2056_INITTAB_UPLOAD
+#define NOUPLOAD	.flags = B2056_INITTAB_ENTRY_OK
+
+struct b2056_inittabs_pts {
+	const struct b2056_inittab_entry *syn;
+	unsigned int syn_length;
+	const struct b2056_inittab_entry *tx;
+	unsigned int tx_length;
+	const struct b2056_inittab_entry *rx;
+	unsigned int rx_length;
+};
+
+#define INITTABSPTS(prefix) \
+	.syn		= prefix##_syn,			\
+	.syn_length	= ARRAY_SIZE(prefix##_syn),	\
+	.tx		= prefix##_tx,			\
+	.tx_length	= ARRAY_SIZE(prefix##_tx),	\
+	.rx		= prefix##_rx,			\
+	.rx_length	= ARRAY_SIZE(prefix##_rx)
+
+struct b2056_inittabs_pts b2056_inittabs[] = {
+};
+
 #define RADIOREGS3(r00, r01, r02, r03, r04, r05, r06, r07, r08, r09, \
 		   r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, \
 		   r20, r21, r22, r23, r24, r25, r26, r27, r28, r29, \
@@ -6045,6 +6078,50 @@ static const struct b43_nphy_channeltab_entry_rev3 b43_nphy_channeltab_rev8[] =
   },
 };
 
+static void b2056_upload_inittab(struct b43_wldev *dev, bool ghz5,
+				 bool ignore_uploadflag, u16 routing,
+				 const struct b2056_inittab_entry *e,
+				 unsigned int length)
+{
+	unsigned int i;
+	u16 value;
+
+	for (i = 0; i < length; i++, e++) {
+		if (!(e->flags & B2056_INITTAB_ENTRY_OK))
+			continue;
+		if ((e->flags & B2056_INITTAB_UPLOAD) || ignore_uploadflag) {
+			if (ghz5)
+				value = e->ghz5;
+			else
+				value = e->ghz2;
+			b43_radio_write(dev, routing | i, value);
+		}
+	}
+}
+
+void b2056_upload_inittabs(struct b43_wldev *dev,
+			   bool ghz5, bool ignore_uploadflag)
+{
+	struct b2056_inittabs_pts *pts;
+
+	if (dev->phy.rev >= ARRAY_SIZE(b2056_inittabs)) {
+		B43_WARN_ON(1);
+		return;
+	}
+	pts = &b2056_inittabs[dev->phy.rev];
+
+	b2056_upload_inittab(dev, ghz5, ignore_uploadflag,
+				B2056_SYN, pts->syn, pts->syn_length);
+	b2056_upload_inittab(dev, ghz5, ignore_uploadflag,
+				B2056_TX0, pts->tx, pts->tx_length);
+	b2056_upload_inittab(dev, ghz5, ignore_uploadflag,
+				B2056_TX1, pts->tx, pts->tx_length);
+	b2056_upload_inittab(dev, ghz5, ignore_uploadflag,
+				B2056_RX0, pts->rx, pts->rx_length);
+	b2056_upload_inittab(dev, ghz5, ignore_uploadflag,
+				B2056_RX1, pts->rx, pts->rx_length);
+}
+
 /* TODO: add support for rev4+ devices by searching in rev4+ tables */
 const struct b43_nphy_channeltab_entry_rev3 *
 b43_nphy_get_chantabent_rev3(struct b43_wldev *dev, u16 freq)
diff --git a/drivers/net/wireless/b43/radio_2056.h b/drivers/net/wireless/b43/radio_2056.h
index 302600c..d601f6e 100644
--- a/drivers/net/wireless/b43/radio_2056.h
+++ b/drivers/net/wireless/b43/radio_2056.h
@@ -1114,4 +1114,7 @@ struct b43_nphy_channeltab_entry_rev3 {
 	struct b43_phy_n_sfo_cfg phy_regs;
 };
 
+void b2056_upload_inittabs(struct b43_wldev *dev,
+			   bool ghz5, bool ignore_uploadflag);
+
 #endif /* B43_RADIO_2056_H_ */
-- 
1.6.3.3

