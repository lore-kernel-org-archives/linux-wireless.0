Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50798 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955AbXLPW62 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 17:58:28 -0500
Subject: [PATCH 103/48] libertas: don't use __lbs_cmd() with empty callback in if_usb.c
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J42Rv-000386-40@shinybook.infradead.org> (sfid-20071216_225839_561058_A75D5CEE)
Date: Sun, 16 Dec 2007 17:59:07 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sat, 15 Dec 2007 01:22:09 -0500

We're about to change semantics, leaving callers of
lbs_prepare_and_send_command() with the old broken priv->cur_cmd_retcode
crap. The existence of the callback command will be the trigger for the
new semantics when handling the response.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/if_usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 396ce67..cf88251 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -109,7 +109,7 @@ static void if_usb_set_boot2_ver(struct lbs_private *priv)
 	b2_cmd.action = 0;
 	b2_cmd.version = priv->boot2_version;
 
-	if (lbs_cmd(priv, CMD_SET_BOOT2_VER, &b2_cmd, NULL, 0))
+	if (lbs_cmd_with_response(priv, CMD_SET_BOOT2_VER, &b2_cmd))
 		lbs_deb_usb("Setting boot2 version failed\n");
 }
 
-- 
1.5.3.4

