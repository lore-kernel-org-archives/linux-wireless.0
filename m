Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:35249 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923AbYJ2Vbp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 17:31:45 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH] p54: don't report known but unhandled EEPROM codes as unknown
To: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, flamingice@sourmilk.net
Date: Wed, 29 Oct 2008 17:31:43 -0400
Message-ID: <20081029213143.4497.77258.stgit@dv.roinet.com> (sfid-20081029_223147_999802_B228DAA6)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/p54/p54common.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index 02a306d..29daa5d 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -416,6 +416,30 @@ static int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
 			/* make it overrun */
 			entry_len = len;
 			break;
+		case PDR_MANUFACTURING_PART_NUMBER:
+		case PDR_PDA_VERSION:
+		case PDR_NIC_SERIAL_NUMBER:
+		case PDR_REGULATORY_DOMAIN_LIST:
+		case PDR_TEMPERATURE_TYPE:
+		case PDR_PRISM_PCI_IDENTIFIER:
+		case PDR_COUNTRY_INFORMATION:
+		case PDR_OEM_NAME:
+		case PDR_PRODUCT_NAME:
+		case PDR_UTF8_OEM_NAME:
+		case PDR_UTF8_PRODUCT_NAME:
+		case PDR_COUNTRY_LIST:
+		case PDR_DEFAULT_COUNTRY:
+		case PDR_ANTENNA_GAIN:
+		case PDR_PRISM_INDIGO_PA_CALIBRATION_DATA:
+		case PDR_RSSI_LINEAR_APPROXIMATION:
+		case PDR_RSSI_LINEAR_APPROXIMATION_DUAL_BAND:
+		case PDR_REGULATORY_POWER_LIMITS:
+		case PDR_RSSI_LINEAR_APPROXIMATION_EXTENDED:
+		case PDR_RADIATED_TRANSMISSION_CORRECTION:
+		case PDR_PRISM_TX_IQ_CALIBRATION:
+		case PDR_BASEBAND_REGISTERS:
+		case PDR_PER_CHANNEL_BASEBAND_REGISTERS:
+			break;
 		default:
 			printk(KERN_INFO "p54: unknown eeprom code : 0x%x\n",
 				le16_to_cpu(entry->code));
