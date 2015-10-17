Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:33123 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbbJQUZj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Oct 2015 16:25:39 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: paulmcquad@gmail.com
Cc: sgruszka@redhat.com, helmut.schaa@googlemail.com,
	kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: wireless: rt2x00: statics code style
Date: Sat, 17 Oct 2015 21:25:33 +0100
Message-Id: <1445113533-28116-1-git-send-email-paulmcquad@gmail.com> (sfid-20151017_222559_447013_B716703A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not initialise statics to 0 or NULL
Also use tabs where possible

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 drivers/net/wireless/rt2x00/rt61pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index c0e730e..53bd23d 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -39,7 +39,7 @@
 /*
  * Allow hardware encryption to be disabled.
  */
-static bool modparam_nohwcrypt = false;
+static bool modparam_nohwcrypt;
 module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 
@@ -1388,7 +1388,7 @@ static bool rt61pci_get_entry_state(struct queue_entry *entry)
 		rt2x00_desc_read(entry_priv->desc, 0, &word);
 
 		return (rt2x00_get_field32(word, TXD_W0_OWNER_NIC) ||
-		        rt2x00_get_field32(word, TXD_W0_VALID));
+		rt2x00_get_field32(word, TXD_W0_VALID));
 	}
 }
 
-- 
2.6.1

