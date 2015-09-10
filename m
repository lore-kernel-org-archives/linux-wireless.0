Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:28991 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752227AbbIJO3H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 10:29:07 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t8AEIRXD002000
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2015 07:29:06 -0700
Received: from sc-exch02.marvell.com ([199.233.58.182])
	by mx0a-0016f401.pphosted.com with ESMTP id 1wqwrk6ymy-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2015 07:29:06 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Amitkumar Karwar <akarwar@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Cathy Luo <cluo@marvell.com>
Subject: [PATCH 2/2] mwifiex: correction in USB8997 chipset's product ID
Date: Thu, 10 Sep 2015 07:27:34 -0700
Message-ID: <1441895254-28890-2-git-send-email-akarwar@marvell.com> (sfid-20150910_162911_914401_38CBDDE5)
In-Reply-To: <1441895254-28890-1-git-send-email-akarwar@marvell.com>
References: <1441895254-28890-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For 8897 chipset, mwifiex_usb unnecessarily used to
come into picture when wlan is supposed to be used
via PCIe interface and USB interface is for
bluetooth.

This problem has been resolved for newer chipset by
having separate USB product ids for USB-USB8997 and
PCIe-USB8997 chipset variants. This patch ensures to
use wlan specific product id.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Frank Huang <frankh@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/usb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/usb.h b/drivers/net/wireless/mwifiex/usb.h
index 1be82d3..6029a68 100644
--- a/drivers/net/wireless/mwifiex/usb.h
+++ b/drivers/net/wireless/mwifiex/usb.h
@@ -30,7 +30,7 @@
 #define USB8797_PID_2		0x2044
 #define USB8801_PID_1		0x2049
 #define USB8801_PID_2		0x204a
-#define USB8997_PID_1		0x204d
+#define USB8997_PID_1		0x2052
 #define USB8997_PID_2		0x204e
 
 
-- 
1.8.1.4

