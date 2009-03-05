Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:38886 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835AbZCEUbK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 15:31:10 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 5/7] p54: fix iwconfig txpower off
Date: Thu, 5 Mar 2009 21:31:05 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200903052131.05450.chunkeey@web.de> (sfid-20090305_213118_098784_3F10BA76)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Disabling the receiver logic with P54_FILTER_TYPE_RX_DISABLED is not
supported by all firmwares. However we have an alternative: hibernation.
And the only side effect - so far - is a bit less power consumption. WIN!

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2009-03-05 15:11:07.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2009-03-05 15:42:57.000000000 +0100
@@ -1674,7 +1674,7 @@ static int p54_setup_mac(struct ieee8021
 			mode = P54_FILTER_TYPE_PROMISCUOUS;
 			break;
 		default:
-			mode = P54_FILTER_TYPE_NONE;
+			mode = P54_FILTER_TYPE_HIBERNATE;
 			break;
 		}
 
@@ -1687,7 +1687,7 @@ static int p54_setup_mac(struct ieee8021
 		    (mode != P54_FILTER_TYPE_PROMISCUOUS))
 			mode |= P54_FILTER_TYPE_TRANSPARENT;
 	} else
-		mode = P54_FILTER_TYPE_RX_DISABLED;
+		mode = P54_FILTER_TYPE_HIBERNATE;
 
 	setup->mac_mode = cpu_to_le16(mode);
 	memcpy(setup->mac_addr, priv->mac_addr, ETH_ALEN);
