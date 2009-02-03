Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:31977 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbZBCQP6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 11:15:58 -0500
Received: by nf-out-0910.google.com with SMTP id d3so296275nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2009 08:15:56 -0800 (PST)
Message-ID: <49886DBD.9030302@gmail.com> (sfid-20090203_171602_631017_79ADD97F)
Date: Tue, 03 Feb 2009 17:15:57 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: johannes@sipsolutions.net, dcbw@redhat.com
CC: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH] wireless: pos[4] tested twice, 2nd should be pos[5]
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is this what it should be? please review.
----------------->8----------------------8<------------------

pos[4] can't be both 0x43 and 0x04, 2nd should be pos[5]

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
index 57f6c12..00a57ed 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -692,7 +692,7 @@ static int lbs_process_bss(struct bss_descriptor *bss,
 					    bss->wpa_ie_len);
 			} else if (pos[1] >= MARVELL_MESH_IE_LENGTH &&
 				   pos[2] == 0x00 && pos[3] == 0x50 &&
-				   pos[4] == 0x43 && pos[4] == 0x04) {
+				   pos[4] == 0x43 && pos[5] == 0x04) {
 				lbs_deb_scan("got mesh IE\n");
 				bss->mesh = 1;
 			} else {
