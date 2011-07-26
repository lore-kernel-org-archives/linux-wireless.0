Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:51313 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160Ab1GZWwt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 18:52:49 -0400
Subject: [PATCH 3/3] orinoco_cs: be more careful when matching cards with ID
 0x0156:0x0002
To: linux-pcmcia@lists.infradead.org, linux-wireless@vger.kernel.org
From: Pavel Roskin <proski@gnu.org>
Date: Tue, 26 Jul 2011 18:52:48 -0400
Message-ID: <20110726225248.29951.81874.stgit@mj.roinet.com> (sfid-20110727_005256_655906_AE583D09)
In-Reply-To: <20110726225235.29951.70265.stgit@mj.roinet.com>
References: <20110726225235.29951.70265.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Without CONFIG_HERMES_PRISM, only match cards that have "Version 01.01"
as the third product ID.  Those have Agere firmware.

With CONFIG_HERMES_PRISM, match all 0x0156:0x0002 cards.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/orinoco/orinoco_cs.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/orinoco/orinoco_cs.c b/drivers/net/wireless/orinoco/orinoco_cs.c
index 3f7fc4a..d7dbc00 100644
--- a/drivers/net/wireless/orinoco/orinoco_cs.c
+++ b/drivers/net/wireless/orinoco/orinoco_cs.c
@@ -239,7 +239,6 @@ static int orinoco_cs_resume(struct pcmcia_device *link)
 
 static const struct pcmcia_device_id orinoco_cs_ids[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x0101, 0x0777), /* 3Com AirConnect PCI 777A */
-	PCMCIA_DEVICE_MANF_CARD(0x0156, 0x0002), /* Lucent Orinoco and old Intersil */
 	PCMCIA_DEVICE_MANF_CARD(0x016b, 0x0001), /* Ericsson WLAN Card C11 */
 	PCMCIA_DEVICE_MANF_CARD(0x01eb, 0x080a), /* Nortel Networks eMobility 802.11 Wireless Adapter */
 	PCMCIA_DEVICE_MANF_CARD(0x0261, 0x0002), /* AirWay 802.11 Adapter (PCMCIA) */
@@ -272,6 +271,7 @@ static const struct pcmcia_device_id orinoco_cs_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12("PROXIM", "LAN PCI CARD HARMONY 80211B", 0xc6536a5e, 0x9f494e26),
 	PCMCIA_DEVICE_PROD_ID12("SAMSUNG", "11Mbps WLAN Card", 0x43d74cb4, 0x579bd91b),
 	PCMCIA_DEVICE_PROD_ID12("Symbol Technologies", "LA4111 Spectrum24 Wireless LAN PC Card", 0x3f02b4d6, 0x3663cb0e),
+	PCMCIA_DEVICE_MANF_CARD_PROD_ID3(0x0156, 0x0002, "Version 01.01", 0xd27deb1a), /* Lucent Orinoco */
 #ifdef CONFIG_HERMES_PRISM
 	/* Only entries that certainly identify Prism chipset */
 	PCMCIA_DEVICE_MANF_CARD(0x000b, 0x7100), /* SonicWALL Long Range Wireless Card */
@@ -321,6 +321,9 @@ static const struct pcmcia_device_id orinoco_cs_ids[] = {
 	PCMCIA_DEVICE_PROD_ID3("ISL37100P", 0x630d52b2),
 	PCMCIA_DEVICE_PROD_ID3("ISL37101P-10", 0xdd97a26b),
 	PCMCIA_DEVICE_PROD_ID3("ISL37300P", 0xc9049a39),
+
+	/* This may be Agere or Intersil Firmware */
+	PCMCIA_DEVICE_MANF_CARD(0x0156, 0x0002),
 #endif
 	PCMCIA_DEVICE_NULL,
 };
