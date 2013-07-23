Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:46078 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754162Ab3GWCTW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 22:19:22 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 16/21] mwifiex: replace mdelay with msleep
Date: Mon, 22 Jul 2013 19:17:53 -0700
Message-ID: <1374545878-15683-17-git-send-email-bzhao@marvell.com> (sfid-20130723_041929_789555_11EF4106)
In-Reply-To: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
References: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

It is observed that when wrong firmware is downloaded for
PCIe card, system hangs for 10 seconds. The reason is mdelay()
is used when firmware status is polled.

Replace mdelay with msleep(non-blocking API) to fix the issue.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c | 2 +-
 drivers/net/wireless/mwifiex/sdio.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index dce6486..098153f 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -1942,7 +1942,7 @@ mwifiex_check_fw_status(struct mwifiex_adapter *adapter, u32 poll_num)
 			ret = 0;
 			break;
 		} else {
-			mdelay(100);
+			msleep(100);
 			ret = -1;
 		}
 	}
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 5ef49f2..c32a735 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -944,7 +944,7 @@ static int mwifiex_check_fw_status(struct mwifiex_adapter *adapter,
 			ret = 0;
 			break;
 		} else {
-			mdelay(100);
+			msleep(100);
 			ret = -1;
 		}
 	}
-- 
1.8.2.3

