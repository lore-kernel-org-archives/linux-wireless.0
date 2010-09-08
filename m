Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58763 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150Ab0IHXgQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 19:36:16 -0400
Received: by gxk23 with SMTP id 23so356709gxk.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 16:36:15 -0700 (PDT)
From: Steve deRosier <steve@cozybit.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	Mattia Barbon <mbarbon@cpan.org>,
	Steve deRosier <steve@cozybit.com>
Subject: [PATCH 2/3] libertas_tf: fix the check for firmware already running on IGEPv2 boards.
Date: Wed,  8 Sep 2010 16:35:57 -0700
Message-Id: <1283988958-44928-2-git-send-email-steve@cozybit.com>
In-Reply-To: <1283988958-44928-1-git-send-email-steve@cozybit.com>
References: <1283988958-44928-1-git-send-email-steve@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mattia Barbon <mbarbon@cpan.org>

On IGEP boards, the scratch register reports 0x8000 when there is no
firmware running instead of 0x0000.

Signed-off-by: Mattia Barbon <mbarbon@cpan.org>
Signed-off-by: Steve deRosier <steve@cozybit.com>
---
 drivers/net/wireless/libertas_tf/if_sdio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas_tf/if_sdio.c b/drivers/net/wireless/libertas_tf/if_sdio.c
index d1624e3..d3d101e 100644
--- a/drivers/net/wireless/libertas_tf/if_sdio.c
+++ b/drivers/net/wireless/libertas_tf/if_sdio.c
@@ -738,7 +738,7 @@ static int if_sdio_prog_firmware(struct if_sdio_card *card)
 	if (scratch == IF_SDIO_FIRMWARE_OK) {
 		lbtf_deb_sdio("firmware already loaded\n");
 		goto success;
-	} else if ((card->model == IF_SDIO_MODEL_8686) && (scratch > 0)) {
+	} else if ((card->model == IF_SDIO_MODEL_8686) && ((scratch & 0x7fff) != 0)) {
 		lbtf_deb_sdio("firmware may be running\n");
 		if( lbtf_reset_fw == 0 ) {
 			goto success;
-- 
1.7.0

