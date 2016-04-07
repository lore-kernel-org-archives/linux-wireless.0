Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54441 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbcDGGhx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 02:37:53 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
	"Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>
Subject: [PATCH v2 1/3] ath10k: fix calibration init sequence of qca99x0
Date: Thu, 7 Apr 2016 12:07:29 +0530
Message-ID: <1460011051-8272-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20160407_083757_043639_D35F2C21)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pre-calibration is meant for qca4019 which contains only caldata
whereas calibration file is used by ar9888 and qca99x0 that contains
both board data and caldata. So by definition both pre-cal-file and
cal-file can not coexist. Keeping them in shared memory (union), is
breaking boot sequence of qca99x0. Fix it by storing both binaries
in separate memories. This issue is reported in ipq8064 platform which
includes caldata in flash memory.

Fixes: 3d9195ea19e4 ("ath10k: incorporate qca4019 cal data download sequence")
Reported-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
v2: added fixes commit

 drivers/net/wireless/ath/ath10k/core.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index c23c37312ef7..d85b99164212 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -728,10 +728,8 @@ struct ath10k {
 	const void *firmware_data;
 	size_t firmware_len;
 
-	union {
-		const struct firmware *pre_cal_file;
-		const struct firmware *cal_file;
-	};
+	const struct firmware *pre_cal_file;
+	const struct firmware *cal_file;
 
 	struct {
 		const void *firmware_codeswap_data;
-- 
2.7.4

