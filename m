Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from frv153.fwdcdn.com ([212.42.77.153]:43005 "EHLO
	frv153.fwdcdn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaHPIB0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Aug 2014 04:01:26 -0400
Message-ID: <1408174867.3436.1.camel@ubuntu> (sfid-20140816_100135_801331_09B80E4C)
Subject: [PATCH] ath9k: fix wrong string size for strncmp in
 write_file_spec_scan_ctl()
From: Maks Naumov <maksqwe1@ukr.net>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Date: Sat, 16 Aug 2014 00:41:07 -0700
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Maks Naumov <maksqwe1@ukr.net>
---
 drivers/net/wireless/ath/ath9k/spectral.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/spectral.c b/drivers/net/wireless/ath/ath9k/spectral.c
index 5fe29b9..8f68426 100644
--- a/drivers/net/wireless/ath/ath9k/spectral.c
+++ b/drivers/net/wireless/ath/ath9k/spectral.c
@@ -253,7 +253,7 @@ static ssize_t write_file_spec_scan_ctl(struct file *file,
 
 	if (strncmp("trigger", buf, 7) == 0) {
 		ath9k_spectral_scan_trigger(sc->hw);
-	} else if (strncmp("background", buf, 9) == 0) {
+	} else if (strncmp("background", buf, 10) == 0) {
 		ath9k_spectral_scan_config(sc->hw, SPECTRAL_BACKGROUND);
 		ath_dbg(common, CONFIG, "spectral scan: background mode enabled\n");
 	} else if (strncmp("chanscan", buf, 8) == 0) {
-- 
1.9.1



