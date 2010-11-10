Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:36265 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab0KJCV2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:21:28 -0500
Received: by mail-qy0-f181.google.com with SMTP id 31so159944qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:21:27 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 24/44] compat/2.6.33: don't export prototype for pccard_loop_tuple()
Date: Tue,  9 Nov 2010 21:20:06 -0500
Message-Id: <1289355626-25373-25-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mainline kernel does not defines any prototype for this function.

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.33.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/include/linux/compat-2.6.33.h b/include/linux/compat-2.6.33.h
index 8c8789d..9b9ad35 100644
--- a/include/linux/compat-2.6.33.h
+++ b/include/linux/compat-2.6.33.h
@@ -87,13 +87,6 @@ int pcmcia_loop_tuple(struct pcmcia_device *p_dev, cisdata_t code,
 
 #endif /* CONFIG_PCMCIA */
 
-/* loop over CIS entries */
-int pccard_loop_tuple(struct pcmcia_socket *s, unsigned int function,
-		      cisdata_t code, cisparse_t *parse, void *priv_data,
-		      int (*loop_tuple) (tuple_t *tuple,
-					 cisparse_t *parse,
-					 void *priv_data));
-
 #endif /* CONFIG_PCCARD */
 
 /* Backport for kfifo
-- 
1.7.2.30.gc37d7.dirty

