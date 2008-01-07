Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:43868 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbYAGL5J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2008 06:57:09 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Add N-PHY related initvals firmware filenames.
Date: Mon, 7 Jan 2008 12:55:14 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200801071255.15036.mb@bu3sch.de> (sfid-20080107_115716_461434_37DF187F)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds the initval filenames for the N-PHY firmware.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Stuff for 2.6.25

Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c	2008-01-06 00:12:08.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/main.c	2008-01-06 00:12:08.000000000 +0100
@@ -1671,12 +1671,18 @@ static int b43_request_firmware(struct b
 				filename = "b0g0initvals5";
 			else if (rev >= 13)
 				filename = "lp0initvals13";
 			else
 				goto err_no_initvals;
 			break;
+		case B43_PHYTYPE_N:
+			if ((rev >= 11) && (rev <= 12))
+				filename = "n0initvals11";
+			else
+				goto err_no_initvals;
+			break;
 		default:
 			goto err_no_initvals;
 		}
 		err = do_request_fw(dev, filename, &fw->initvals);
 		if (err)
 			goto err_load;
@@ -1699,12 +1705,18 @@ static int b43_request_firmware(struct b
 				filename = "b0g0bsinitvals5";
 			else if (rev >= 11)
 				filename = NULL;
 			else
 				goto err_no_initvals;
 			break;
+		case B43_PHYTYPE_N:
+			if ((rev >= 11) && (rev <= 12))
+				filename = "n0bsinitvals11";
+			else
+				goto err_no_initvals;
+			break;
 		default:
 			goto err_no_initvals;
 		}
 		err = do_request_fw(dev, filename, &fw->initvals_band);
 		if (err)
 			goto err_load;
