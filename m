Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4108 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab2I0MuQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 08:50:16 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <ath6kl-devel@qualcomm.com>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH 2/6] ath6kl: Return error case when ath6kl_usb_alloc_pipe_resources fails
Date: Thu, 27 Sep 2012 18:19:49 +0530
Message-ID: <1348750193-2665-2-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120927_145021_301750_C668F8F8)
In-Reply-To: <1348750193-2665-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1348750193-2665-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Incase the resource allocation for the struct ath6kl_urb_context in the
function ath6kl_usb_alloc_pipe_resources fails, return this error
case so that ath6kl_usb_probe is aware of this error case.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/usb.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/usb.c b/drivers/net/wireless/ath/ath6kl/usb.c
index a6d1377..2014fac 100644
--- a/drivers/net/wireless/ath/ath6kl/usb.c
+++ b/drivers/net/wireless/ath/ath6kl/usb.c
@@ -185,9 +185,10 @@ static int ath6kl_usb_alloc_pipe_resources(struct ath6kl_usb_pipe *pipe,
 	for (i = 0; i < urb_cnt; i++) {
 		urb_context = kzalloc(sizeof(struct ath6kl_urb_context),
 				      GFP_KERNEL);
-		if (urb_context == NULL)
-			/* FIXME: set status to -ENOMEM */
-			break;
+		if (urb_context == NULL) {
+			status = -ENOMEM;
+			goto fail_alloc_pipe_resources;
+		}
 
 		urb_context->pipe = pipe;
 
@@ -204,6 +205,7 @@ static int ath6kl_usb_alloc_pipe_resources(struct ath6kl_usb_pipe *pipe,
 		   pipe->logical_pipe_num, pipe->usb_pipe_handle,
 		   pipe->urb_alloc);
 
+fail_alloc_pipe_resources:
 	return status;
 }
 
-- 
1.7.0.4

