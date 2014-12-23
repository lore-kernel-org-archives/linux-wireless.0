Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:61173 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754873AbaLWIOq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 03:14:46 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id sBN8EkSa008335
	for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2014 00:14:46 -0800
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0a-0016f401.pphosted.com with ESMTP id 1rcjut132m-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2014 00:14:46 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <yangyang@marvell.com>,
	<huxm@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 4/8] mwifiex: move pm_wakeup_card_complete definition to usb.c
Date: Tue, 23 Dec 2014 19:14:08 +0530
Message-ID: <1419342252-2702-5-git-send-email-patila@marvell.com> (sfid-20141223_091452_169613_BD34BECF)
In-Reply-To: <1419342252-2702-1-git-send-email-patila@marvell.com>
References: <1419342252-2702-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

Move mwifiex_pm_wakeup_card_complete handler to source file.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/usb.c | 7 +++++++
 drivers/net/wireless/mwifiex/usb.h | 7 -------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index 1b56495..8ae7a85 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -1010,6 +1010,13 @@ static void mwifiex_usb_submit_rem_rx_urbs(struct mwifiex_adapter *adapter)
 	}
 }
 
+/* This function is called after the card has woken up. */
+static inline int
+mwifiex_pm_wakeup_card_complete(struct mwifiex_adapter *adapter)
+{
+	return 0;
+}
+
 static struct mwifiex_if_ops usb_ops = {
 	.register_dev =		mwifiex_register_dev,
 	.unregister_dev =	mwifiex_unregister_dev,
diff --git a/drivers/net/wireless/mwifiex/usb.h b/drivers/net/wireless/mwifiex/usb.h
index a7cbba1..0ad1beb 100644
--- a/drivers/net/wireless/mwifiex/usb.h
+++ b/drivers/net/wireless/mwifiex/usb.h
@@ -96,11 +96,4 @@ struct fw_data {
 	u8 data[1];
 };
 
-/* This function is called after the card has woken up. */
-static inline int
-mwifiex_pm_wakeup_card_complete(struct mwifiex_adapter *adapter)
-{
-	return 0;
-}
-
 #endif /*_MWIFIEX_USB_H */
-- 
1.8.1.4

