Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:43515 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751692AbaLQI1r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 03:27:47 -0500
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <yangyang@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 1/4] mwifiex: enable -D__CHECK_ENDIAN__ for sparse by default
Date: Wed, 17 Dec 2014 19:26:58 +0530
Message-ID: <1418824621-2102-1-git-send-email-patila@marvell.com> (sfid-20141217_092750_762517_79BC04EB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable the endian checks by default.

Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/Makefile b/drivers/net/wireless/mwifiex/Makefile
index 9487d72..5a8ecad 100644
--- a/drivers/net/wireless/mwifiex/Makefile
+++ b/drivers/net/wireless/mwifiex/Makefile
@@ -53,3 +53,5 @@ obj-$(CONFIG_MWIFIEX_PCIE) += mwifiex_pcie.o
 
 mwifiex_usb-y += usb.o
 obj-$(CONFIG_MWIFIEX_USB) += mwifiex_usb.o
+
+ccflags-y += -D__CHECK_ENDIAN__ -DDEBUG
-- 
1.8.1.4

