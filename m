Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36478 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751531AbaLaKid (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2014 05:38:33 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Maithili Hinge <maithili@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Cathy Luo <cluo@marvell.com>, Marc Yang <yangyang@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 3/9] mwifiex: increase delay during card reset
Date: Wed, 31 Dec 2014 02:36:40 -0800
Message-ID: <1420022206-11435-4-git-send-email-akarwar@marvell.com> (sfid-20141231_113837_240093_BF8B7036)
In-Reply-To: <1420022206-11435-1-git-send-email-akarwar@marvell.com>
References: <1420022206-11435-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marc Yang <yangyang@marvell.com>

200ms is the requirement to allow VDD1.1 and VDD1.8 to
drop to have proper reset.

Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Marc Yang <yangyang@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 274a1b2..4e8aedd 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1958,8 +1958,8 @@ static void mwifiex_sdio_card_reset_work(struct mwifiex_adapter *adapter)
 
 	pr_err("Resetting card...\n");
 	mmc_remove_host(target);
-	/* 20ms delay is based on experiment with sdhci controller */
-	mdelay(20);
+	/* 200ms delay is based on experiment with sdhci controller */
+	mdelay(200);
 	target->rescan_entered = 0; /* rescan non-removable cards */
 	mmc_add_host(target);
 }
-- 
1.8.1.4

