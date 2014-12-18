Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:41470 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751113AbaLRG31 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 01:29:27 -0500
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>, <kvalo@codeaurora.org>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <yangyang@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH v2 1/4] mwifiex: enable -D__CHECK_ENDIAN__ for sparse by default
Date: Thu, 18 Dec 2014 17:28:43 +0530
Message-ID: <1418903926-11859-1-git-send-email-patila@marvell.com> (sfid-20141218_072937_970174_4AE0C764)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable the endian checks by default.

v2: remove -DDEBUG as suggested by Joe Perches

Signed-off-by: Avinash Patil <patila@marvell.com>
---
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

