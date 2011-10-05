Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:47729 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934139Ab1JEJX3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 05:23:29 -0400
Subject: [PATCH 3/6] ath6kl: return error block size is not power of 2
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 05 Oct 2011 12:23:25 +0300
Message-ID: <20111005092325.1095.72436.stgit@localhost6.localdomain6> (sfid-20111005_112332_462000_42696119)
In-Reply-To: <20111005092305.1095.713.stgit@localhost6.localdomain6>
References: <20111005092305.1095.713.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently only a warning is emitted but no error is returned.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc_hif.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc_hif.c b/drivers/net/wireless/ath/ath6kl/htc_hif.c
index 86b1cc7..4a5e9a3 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_hif.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_hif.c
@@ -621,6 +621,7 @@ int ath6kldev_setup(struct ath6kl_device *dev)
 	/* must be a power of 2 */
 	if ((dev->htc_cnxt->block_sz & (dev->htc_cnxt->block_sz - 1)) != 0) {
 		WARN_ON(1);
+		status = -EINVAL;
 		goto fail_setup;
 	}
 

