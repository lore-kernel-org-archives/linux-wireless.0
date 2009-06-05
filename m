Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47014 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbZFEJro (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 05:47:44 -0400
Subject: [PATCH] ar9170: interpret firmware debug commands
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 05 Jun 2009 11:47:43 +0200
Message-Id: <1244195263.22576.96.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds new commands that the original firmware will not send
but we can use them to debug firmware.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/ath/ar9170/main.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

--- wireless-testing.orig/drivers/net/wireless/ath/ar9170/main.c	2009-06-05 09:28:48.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ar9170/main.c	2009-06-05 09:46:38.000000000 +0200
@@ -442,6 +442,38 @@ void ar9170_handle_command_response(stru
 		/* retransmission issue / SIFS/EIFS collision ?! */
 		break;
 
+	/* firmware debug */
+	case 0xca:
+		printk(KERN_DEBUG "ar9170 FW: %.*s\n", len - 4, (char *)buf + 4);
+		break;
+	case 0xcb:
+		len -= 4;
+
+		switch (len) {
+		case 1:
+			printk(KERN_DEBUG "ar9170 FW: u8: %#.2x\n",
+				*((char *)buf + 4));
+			break;
+		case 2:
+			printk(KERN_DEBUG "ar9170 FW: u8: %#.4x\n",
+				le16_to_cpup((__le16 *)((char *)buf + 4)));
+			break;
+		case 4:
+			printk(KERN_DEBUG "ar9170 FW: u8: %#.8x\n",
+				le32_to_cpup((__le32 *)((char *)buf + 4)));
+			break;
+		case 8:
+			printk(KERN_DEBUG "ar9170 FW: u8: %#.16lx\n",
+				(unsigned long)le64_to_cpup(
+						(__le64 *)((char *)buf + 4)));
+			break;
+		}
+		break;
+	case 0xcc:
+		print_hex_dump_bytes("ar9170 FW:", DUMP_PREFIX_NONE,
+				     (char *)buf + 4, len - 4);
+		break;
+
 	default:
 		printk(KERN_INFO "received unhandled event %x\n", cmd->type);
 		print_hex_dump_bytes("dump:", DUMP_PREFIX_NONE, buf, len);


