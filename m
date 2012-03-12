Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:55991 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab2CLLW7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 07:22:59 -0400
Subject: [PATCH 1/4] ath6kl: fix regression in ath6kl_upload_board_file()
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Mon, 12 Mar 2012 13:22:54 +0200
Message-ID: <20120312112254.23253.79934.stgit@x201> (sfid-20120312_122303_247980_D8732FCD)
In-Reply-To: <20120312112131.23253.74137.stgit@x201>
References: <20120312112131.23253.74137.stgit@x201>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My patch 24fc32b3 ("ath6kl: add ath6kl_bmi_write_hi32()") caused a regression
in ath6kl_upload_board_file() and the board_address variable was not
properly initialised in some cases:

ath6kl/init.c:1068:6: warning: ‘board_address’ may be used uninitialized
in this function

Most likely this broke ar6004 support but I can't test that right now.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 231675d..03cae14 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1078,8 +1078,9 @@ static int ath6kl_upload_board_file(struct ath6kl *ar)
 	 * writing board data.
 	 */
 	if (ar->hw.board_addr != 0) {
+		board_address = ar->hw.board_addr;
 		ath6kl_bmi_write_hi32(ar, hi_board_data,
-				      ar->hw.board_addr);
+				      board_address);
 	} else {
 		ath6kl_bmi_read_hi32(ar, hi_board_data, &board_address);
 	}

