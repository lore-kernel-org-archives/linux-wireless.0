Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64537 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab0IQXI2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 19:08:28 -0400
Received: by mail-bw0-f46.google.com with SMTP id 11so3128491bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 16:08:27 -0700 (PDT)
Message-Id: <6c14f87ffdd46c45f3dfcd6c15ba7e89142c1dab.1284763835.git.chunkeey@googlemail.com>
In-Reply-To: <cover.1284763834.git.chunkeey@googlemail.com>
References: <cover.1284763834.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Fri, 17 Sep 2010 22:58:40 +0200
Subject: [PATCH 5/7] carl9170: fix state downgrade during reset
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't mark the device as completely dead just yet.
If all goes to plan and carl9170_reboot succeeds
then we can skip the expensive userspace-driven
reinitialization anyway.

And if it doesn't and carl9170_reboot fails,
then carl9170_usb_cancel_urbs will do the
necessary steps.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/usb.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/usb.c b/drivers/net/wireless/ath/carl9170/usb.c
index 1e7c274..eb789a9 100644
--- a/drivers/net/wireless/ath/carl9170/usb.c
+++ b/drivers/net/wireless/ath/carl9170/usb.c
@@ -846,8 +846,6 @@ int carl9170_usb_restart(struct ar9170 *ar)
 
 	carl9170_usb_stop(ar);
 
-	carl9170_set_state(ar, CARL9170_UNKNOWN_STATE);
-
 	if (err)
 		goto err_out;
 
-- 
1.7.1

