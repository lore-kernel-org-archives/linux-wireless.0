Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56776 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbYLMTdP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Dec 2008 14:33:15 -0500
Date: Sat, 13 Dec 2008 21:33:13 +0200 (EET)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
To: dcbw@redhat.com
cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Subject: [PATCH] libertas: use roundup instead of opencoding
Message-ID: <Pine.LNX.4.64.0812132130550.4160@wrl-59.cs.helsinki.fi> (sfid-20081213_203318_937153_70D1B48D)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696208474-1081507156-1229196793=:4160"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696208474-1081507156-1229196793=:4160
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT


Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
---
 drivers/net/wireless/libertas/if_sdio.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index b54e2ea..4519d73 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -26,6 +26,7 @@
  * if_sdio_card_to_host() to pad the data.
  */
 
+#include <linux/kernel.h>
 #include <linux/moduleparam.h>
 #include <linux/firmware.h>
 #include <linux/netdevice.h>
@@ -581,7 +582,7 @@ static int if_sdio_prog_real(struct if_sdio_card *card)
 				chunk_size, (chunk_size + 31) / 32 * 32);
 */
 			ret = sdio_writesb(card->func, card->ioport,
-				chunk_buffer, (chunk_size + 31) / 32 * 32);
+				chunk_buffer, roundup(chunk_size, 32));
 			if (ret)
 				goto release;
 
-- 
1.5.2.2

---696208474-1081507156-1229196793=:4160--
