Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758271Ab1D1Jw6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 05:52:58 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 05/10] iwlegacy: remove unneeded __packed
Date: Thu, 28 Apr 2011 11:51:28 +0200
Message-Id: <1303984293-6601-5-git-send-email-sgruszka@redhat.com> (sfid-20110428_115304_452382_35C22DB9)
In-Reply-To: <1303984293-6601-1-git-send-email-sgruszka@redhat.com>
References: <1303984293-6601-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

struct iwl_queue is not part of firmware interface, so __packed is not
needed. Remove it since is may affect performance.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-dev.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-dev.h b/drivers/net/wireless/iwlegacy/iwl-dev.h
index 9ee849d..36c01aa 100644
--- a/drivers/net/wireless/iwlegacy/iwl-dev.h
+++ b/drivers/net/wireless/iwlegacy/iwl-dev.h
@@ -134,7 +134,7 @@ struct iwl_queue {
 				* space more than this */
 	int high_mark;         /* high watermark, stop queue if free
 				* space less than this */
-} __packed;
+};
 
 /* One for each TFD */
 struct iwl_tx_info {
-- 
1.7.1

