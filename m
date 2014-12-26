Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:42459 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751723AbaLZLEJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Dec 2014 06:04:09 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id sBQB0AoC024963
	for <linux-wireless@vger.kernel.org>; Fri, 26 Dec 2014 03:04:08 -0800
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0b-0016f401.pphosted.com with ESMTP id 1rfdgcppvq-7
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 26 Dec 2014 03:04:08 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH v3 1/4] mwifiex: enable -D__CHECK_ENDIAN__ for sparse by default
Date: Fri, 26 Dec 2014 03:02:31 -0800
Message-ID: <1419591754-4086-1-git-send-email-patila@marvell.com> (sfid-20141226_120420_634382_BC32B99C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable the endian checks by default.

Signed-off-by: Avinash Patil <patila@marvell.com>
---
v2: remove -DDEBUG as suggested by Joe Perches

 drivers/net/wireless/mwifiex/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/Makefile b/drivers/net/wireless/mwifiex/Makefile
index 9487d72..fdfd9bf 100644
--- a/drivers/net/wireless/mwifiex/Makefile
+++ b/drivers/net/wireless/mwifiex/Makefile
@@ -53,3 +53,5 @@ obj-$(CONFIG_MWIFIEX_PCIE) += mwifiex_pcie.o
 
 mwifiex_usb-y += usb.o
 obj-$(CONFIG_MWIFIEX_USB) += mwifiex_usb.o
+
+ccflags-y += -D__CHECK_ENDIAN
-- 
1.8.1.4

