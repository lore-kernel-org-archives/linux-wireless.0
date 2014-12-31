Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:60819 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751685AbaLaKij (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2014 05:38:39 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Maithili Hinge <maithili@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Cathy Luo <cluo@marvell.com>, Marc Yang <yangyang@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 7/9] mwifiex: Increase priority of firmware download message
Date: Wed, 31 Dec 2014 02:36:44 -0800
Message-ID: <1420022206-11435-8-git-send-email-akarwar@marvell.com> (sfid-20141231_113845_301796_48891286)
In-Reply-To: <1420022206-11435-1-git-send-email-akarwar@marvell.com>
References: <1420022206-11435-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When driver is loaded, it is important to know if FW was already
active or it is freshly downloaded. This patch increases the
priority of these messages.

Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c | 4 ++--
 drivers/net/wireless/mwifiex/sdio.c | 4 ++--
 drivers/net/wireless/mwifiex/usb.c  | 3 ++-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 10e4a93..a460b0e 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -1952,8 +1952,8 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 		offset += txlen;
 	} while (true);
 
-	dev_dbg(adapter->dev, "info:\nFW download over, size %d bytes\n",
-		offset);
+	dev_notice(adapter->dev,
+		   "info: FW download over, size %d bytes\n", offset);
 
 	ret = 0;
 
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 4e8aedd..a70f1033 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -986,8 +986,8 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 		offset += txlen;
 	} while (true);
 
-	dev_dbg(adapter->dev, "info: FW download over, size %d bytes\n",
-		offset);
+	dev_notice(adapter->dev,
+		   "info: FW download over, size %d bytes\n", offset);
 
 	ret = 0;
 done:
diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index 199b43f..6c62995 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -930,7 +930,8 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 	} while ((dnld_cmd != FW_HAS_LAST_BLOCK) && retries);
 
 cleanup:
-	dev_dbg(adapter->dev, "%s: %d bytes downloaded\n", __func__, tlen);
+	dev_notice(adapter->dev,
+		   "info: FW download over, size %d bytes\n", tlen);
 
 	kfree(recv_buff);
 	kfree(fwdata);
-- 
1.8.1.4

