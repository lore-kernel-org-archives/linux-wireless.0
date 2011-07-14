Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:65385 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932371Ab1GNWhc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 18:37:32 -0400
Subject: [PATCH] hostap: remove IDs for 3Com AirConnect PCI 777A,
 it uses Symbol firmware
To: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Thu, 14 Jul 2011 18:37:30 -0400
Message-ID: <20110714223730.23239.44416.stgit@mj.roinet.com> (sfid-20110715_003736_606339_4DD20183)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hostap only supports Intersil firmware.  Symbol firmware is supported by
orinoco.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/hostap/hostap_cs.c  |    1 -
 drivers/net/wireless/hostap/hostap_plx.c |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_cs.c b/drivers/net/wireless/hostap/hostap_cs.c
index c052a0d..2fda69a 100644
--- a/drivers/net/wireless/hostap/hostap_cs.c
+++ b/drivers/net/wireless/hostap/hostap_cs.c
@@ -623,7 +623,6 @@ static int hostap_cs_resume(struct pcmcia_device *link)
 static const struct pcmcia_device_id hostap_cs_ids[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x000b, 0x7100),
 	PCMCIA_DEVICE_MANF_CARD(0x000b, 0x7300),
-	PCMCIA_DEVICE_MANF_CARD(0x0101, 0x0777),
 	PCMCIA_DEVICE_MANF_CARD(0x0126, 0x8000),
 	PCMCIA_DEVICE_MANF_CARD(0x0138, 0x0002),
 	PCMCIA_DEVICE_MANF_CARD(0x01bf, 0x3301),
diff --git a/drivers/net/wireless/hostap/hostap_plx.c b/drivers/net/wireless/hostap/hostap_plx.c
index 33e7903..772efd4 100644
--- a/drivers/net/wireless/hostap/hostap_plx.c
+++ b/drivers/net/wireless/hostap/hostap_plx.c
@@ -88,7 +88,6 @@ static struct prism2_plx_manfid {
 } prism2_plx_known_manfids[] = {
 	{ 0x000b, 0x7110 } /* D-Link DWL-650 Rev. P1 */,
 	{ 0x000b, 0x7300 } /* Philips 802.11b WLAN PCMCIA */,
-	{ 0x0101, 0x0777 } /* 3Com AirConnect PCI 777A */,
 	{ 0x0126, 0x8000 } /* Proxim RangeLAN */,
 	{ 0x0138, 0x0002 } /* Compaq WL100 */,
 	{ 0x0156, 0x0002 } /* Intersil Prism II Ref. Design (and others) */,
