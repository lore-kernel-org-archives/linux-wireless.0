Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:1212 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbYCCMTk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2008 07:19:40 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: [PATCH] libertas: add LED control TLV to types.h
Date: Mon, 3 Mar 2008 12:16:42 +0100
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200803031216.42283.hs4233@mail.mn-solutions.de> (sfid-20080303_121954_381612_F1F8715A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Woodhouse <dwmw2@infradead.org>

Signed-off-by: David Woodhouse <dwmw2@infradead.org>

diff --git a/drivers/net/wireless/libertas/types.h b/drivers/net/wireless/libertas/types.h
index f0d5795..4031be4 100644
--- a/drivers/net/wireless/libertas/types.h
+++ b/drivers/net/wireless/libertas/types.h
@@ -239,4 +239,17 @@ struct mrvlietypes_ledgpio {
 	struct led_pin ledpin[1];
 } __attribute__ ((packed));
 
+struct led_bhv {
+	uint8_t	firmwarestate;
+	uint8_t	led;
+	uint8_t	ledstate;
+	uint8_t	ledarg;
+} __attribute__ ((packed));
+
+
+struct mrvlietypes_ledbhv {
+	struct mrvlietypesheader header;
+	struct led_bhv ledbhv[1];
+} __attribute__ ((packed));
+
 #endif
