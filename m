Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:53685 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753240AbZBXLkO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 06:40:14 -0500
Date: Tue, 24 Feb 2009 13:40:01 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Unlock sc->mutex on error path
Message-ID: <20090224114001.GA21933@jm.kir.nu> (sfid-20090224_124019_189501_C87227C6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

An error path in ath9k_add_interface() did not unlock the sc->mutex and
could leave the driver in quite unresponsive state.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath9k/main.c |    1 +
 1 file changed, 1 insertion(+)

--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c	2009-02-24 13:34:20.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/main.c	2009-02-24 13:34:44.000000000 +0200
@@ -2145,6 +2145,7 @@ static int ath9k_add_interface(struct ie
 	default:
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"Interface type %d not yet supported\n", conf->type);
+		mutex_unlock(&sc->mutex);
 		return -EOPNOTSUPP;
 	}
 

-- 
Jouni Malinen                                            PGP id EFC895FA
