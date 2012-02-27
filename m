Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:42648 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755784Ab2B0Wly (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 17:41:54 -0500
Received: by mail-we0-f174.google.com with SMTP id x9so607342wej.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2012 14:41:54 -0800 (PST)
MIME-Version: 1.0
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 7/7] wl12xx: increase dynamic PS timeout to 200ms
Date: Tue, 28 Feb 2012 00:41:34 +0200
Message-Id: <1330382494-31148-7-git-send-email-arik@wizery.com> (sfid-20120227_234158_277705_075CF954)
In-Reply-To: <1330382494-31148-1-git-send-email-arik@wizery.com>
References: <1330382494-31148-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This ensures the user won't encounter lag associated with getting in and
out of PSM when the card is in use.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index ad1a4ad..418b2b8 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -246,7 +246,7 @@ static struct conf_drv_settings default_conf = {
 		.psm_entry_retries           = 8,
 		.psm_exit_retries            = 16,
 		.psm_entry_nullfunc_retries  = 3,
-		.dynamic_ps_timeout          = 100,
+		.dynamic_ps_timeout          = 200,
 		.forced_ps                   = false,
 		.keep_alive_interval         = 55000,
 		.max_listen_interval         = 20,
-- 
1.7.5.4

