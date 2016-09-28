Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:50869 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750988AbcI1Mtw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2016 08:49:52 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8SCnXd1022335
        for <linux-wireless@vger.kernel.org>; Wed, 28 Sep 2016 05:49:51 -0700
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 25r7vna8tx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Wed, 28 Sep 2016 05:49:51 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 5/8] mwifiex: add memrw command information in README
Date: Wed, 28 Sep 2016 18:18:25 +0530
Message-ID: <1475066908-11771-5-git-send-email-akarwar@marvell.com> (sfid-20160928_144955_652412_8E774BA3)
In-Reply-To: <1475066908-11771-1-git-send-email-akarwar@marvell.com>
References: <1475066908-11771-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Support for this debugfs command is available in driver. This patch
adds usage information in README file.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/README | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/README b/drivers/net/wireless/marvell/mwifiex/README
index 24e649b..588fcbe 100644
--- a/drivers/net/wireless/marvell/mwifiex/README
+++ b/drivers/net/wireless/marvell/mwifiex/README
@@ -180,6 +180,29 @@ regrdwr
 		echo "1 0xa060 0x12" > regrdwr      : Write the MAC register
 		echo "1 0xa794 0x80000000" > regrdwr
 		                                    : Write 0x80000000 to MAC register
+
+memrw
+	This command is used to read/write the firmware memory.
+
+	Usage:
+		1) For reading firmware memory location.
+			echo r <address> 0 > /sys/kernel/debug/mwifiex/mlan0/memrw
+			cat /sys/kernel/debug/mwifiex/mlan0/memrw
+		2) For writing value to firmware memory location.
+			echo w <address> [value] > /sys/kernel/debug/mwifiex/mlan0/memrw
+
+	where the parameters are,
+		<address>:  memory address
+		[value]:    value to be written
+
+	Examples:
+		echo r 0x4cf70 0 > /sys/kernel/debug/mwifiex/mlan0/memrw
+		cat /sys/kernel/debug/mwifiex/mlan0/memrw
+						: Read memory address 0x4cf70
+		iwpriv mlan0 memrdwr -0x7fff6000 -0x40000000
+		echo w 0x8000a000 0xc0000000 > /sys/kernel/debug/mwifiex/mlan0/memrw
+						: Write 0xc0000000 to memory address 0x8000a000
+
 rdeeprom
 	This command is used to read the EEPROM contents of the card.
 
-- 
1.9.1
