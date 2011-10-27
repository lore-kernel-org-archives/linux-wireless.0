Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:57795 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab1J0Ps0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Oct 2011 11:48:26 -0400
Subject: [PATCH 04/10] ath6kl: add a fixme to ath6kl_htc_wait_target()
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 27 Oct 2011 18:48:22 +0300
Message-ID: <20111027154822.23519.73574.stgit@localhost6.localdomain6> (sfid-20111027_174828_155409_F428805A)
In-Reply-To: <20111027154746.23519.39680.stgit@localhost6.localdomain6>
References: <20111027154746.23519.39680.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This doesn't look right, but investigate it later.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index 976e352..d03456b 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -2598,6 +2598,10 @@ int ath6kl_htc_wait_target(struct htc_target *target)
 	status = ath6kl_htc_conn_service((void *)target, &connect, &resp);
 
 	if (status)
+		/*
+		 * FIXME: this call doesn't make sense, the caller should
+		 * call ath6kl_htc_cleanup() when it wants remove htc
+		 */
 		ath6kl_hif_cleanup_scatter(target->dev->ar);
 
 fail_wait_target:

