Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:37045 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbZHIP6h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Aug 2009 11:58:37 -0400
From: Michael Buesch <mb@bu3sch.de>
To: linville@tuxdriver.com
Subject: [PATCH] rtl818x: Add some documentation to the TX desc flags
Date: Sun, 9 Aug 2009 17:57:30 +0200
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200908091757.31010.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add some TX desc flags docs.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

It's incomplete. Just the ones I could easily figure out by myself...


 drivers/net/wireless/rtl818x/rtl818x.h |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl818x.h
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl818x.h
@@ -187,22 +187,32 @@ struct rtl818x_csr {
 } __attribute__((packed));
 
 struct rtl818x_rf_ops {
 	char *name;
 	void (*init)(struct ieee80211_hw *);
 	void (*stop)(struct ieee80211_hw *);
 	void (*set_chan)(struct ieee80211_hw *, struct ieee80211_conf *);
 	void (*conf_erp)(struct ieee80211_hw *, struct ieee80211_bss_conf *);
 };
 
-/* Tx/Rx flags are common between RTL818X chips */
-
+/**
+ * enum rtl818x_tx_desc_flags - Tx/Rx flags are common between RTL818X chips
+ *
+ * @RTL818X_TX_DESC_FLAG_NO_ENC: Disable hardware based encryption.
+ * @RTL818X_TX_DESC_FLAG_TX_OK: TX frame was ACKed.
+ * @RTL818X_TX_DESC_FLAG_SPLCP: Use short preamble.
+ * @RTL818X_TX_DESC_FLAG_MOREFRAG: More fragments follow.
+ * @RTL818X_TX_DESC_FLAG_CTS: Use CTS-to-self protection.
+ * @RTL818X_TX_DESC_FLAG_RTS: Use RTS/CTS protection.
+ * @RTL818X_TX_DESC_FLAG_LS: Last segment of the frame.
+ * @RTL818X_TX_DESC_FLAG_FS: First segment of the frame.
+ */
 enum rtl818x_tx_desc_flags {
 	RTL818X_TX_DESC_FLAG_NO_ENC	= (1 << 15),
 	RTL818X_TX_DESC_FLAG_TX_OK	= (1 << 15),
 	RTL818X_TX_DESC_FLAG_SPLCP	= (1 << 16),
 	RTL818X_TX_DESC_FLAG_RX_UNDER	= (1 << 16),
 	RTL818X_TX_DESC_FLAG_MOREFRAG	= (1 << 17),
 	RTL818X_TX_DESC_FLAG_CTS	= (1 << 18),
 	RTL818X_TX_DESC_FLAG_RTS	= (1 << 23),
 	RTL818X_TX_DESC_FLAG_LS		= (1 << 28),
 	RTL818X_TX_DESC_FLAG_FS		= (1 << 29),

-- 
Greetings, Michael.
