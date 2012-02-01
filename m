Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:18449 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab2BAHoB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 02:44:01 -0500
Date: Wed, 1 Feb 2012 10:43:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	kernel-janitors@vger.kernel.org
Subject: [patch] ath9k: cleanup a min_t() cast
Message-ID: <20120201074330.GB22179@elgon.mountain> (sfid-20120201_084406_627766_D9734AAD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the firmware was over 2G, it would cause memory corruption and the
system would die here.  Obviously we all know the firmware isn't going
to be that large but static checkers get upset.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index f317515..424aabb 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -981,7 +981,7 @@ static int ath9k_hif_usb_download_fw(struct hif_device_usb *hif_dev)
 		return -ENOMEM;
 
 	while (len) {
-		transfer = min_t(int, len, 4096);
+		transfer = min_t(size_t, len, 4096);
 		memcpy(buf, data, transfer);
 
 		err = usb_control_msg(hif_dev->udev,
