Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43283 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab2GKHV4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 03:21:56 -0400
From: Pandiyarajan Pitchaimuthu <c_ppitch@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath6kl: Make use of return value from ath6kl_diag_read()
Date: Wed, 11 Jul 2012 12:51:43 +0530
Message-ID: <1341991303-1034-1-git-send-email-c_ppitch@qca.qualcomm.com> (sfid-20120711_092200_006477_671F2B8C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In ath6kl_read_fwlogs(), return value from ath6kl_diag_read()is not
used to bail out in case of any errors in reading fw log. No real issue
is observed because of this, reported by source code analyzer.

Signed-off-by: Pandiyarajan Pitchaimuthu <c_ppitch@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/main.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index c189e28..d01cb36 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -293,13 +293,17 @@ int ath6kl_read_fwlogs(struct ath6kl *ar)
 	}
 
 	address = TARG_VTOP(ar->target_type, debug_hdr_addr);
-	ath6kl_diag_read(ar, address, &debug_hdr, sizeof(debug_hdr));
+	ret = ath6kl_diag_read(ar, address, &debug_hdr, sizeof(debug_hdr));
+	if (ret)
+		goto out;
 
 	address = TARG_VTOP(ar->target_type,
 			    le32_to_cpu(debug_hdr.dbuf_addr));
 	firstbuf = address;
 	dropped = le32_to_cpu(debug_hdr.dropped);
-	ath6kl_diag_read(ar, address, &debug_buf, sizeof(debug_buf));
+	ret = ath6kl_diag_read(ar, address, &debug_buf, sizeof(debug_buf));
+	if (ret)
+		goto out;
 
 	loop = 100;
 
@@ -322,7 +326,7 @@ int ath6kl_read_fwlogs(struct ath6kl *ar)
 
 		address = TARG_VTOP(ar->target_type,
 				    le32_to_cpu(debug_buf.next));
-		ath6kl_diag_read(ar, address, &debug_buf, sizeof(debug_buf));
+		ret = ath6kl_diag_read(ar, address, &debug_buf, sizeof(debug_buf));
 		if (ret)
 			goto out;
 
-- 
1.7.9.5

