Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:43153 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755290AbcLANyA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2016 08:54:00 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: sdio: fix use after free issue for save_adapter
Date: Thu, 1 Dec 2016 19:23:31 +0530
Message-ID: <1480600411-3905-1-git-send-email-akarwar@marvell.com> (sfid-20161201_145404_618511_1E59E36C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If we have sdio work requests received when sdio card reset is
happening, we may end up accessing older save_adapter pointer
later which is already freed during card reset.
This patch solves the problem by cancelling those pending requests.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/sdio.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index db01794..44eb65a 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -2229,6 +2229,12 @@ static void mwifiex_recreate_adapter(struct sdio_mmc_card *card)
 	mmc_hw_reset(func->card->host);
 	sdio_release_host(func);
 
+	/* Previous save_adapter won't be valid after this. We will cancel
+	 * pending work requests.
+	 */
+	clear_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &iface_work_flags);
+	clear_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &iface_work_flags);
+
 	mwifiex_sdio_probe(func, device_id);
 }
 
-- 
1.9.1
