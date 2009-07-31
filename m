Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:58692 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbZGaUfv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 16:35:51 -0400
Received: by fxm17 with SMTP id 17so1581600fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 13:35:50 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 31 Jul 2009 22:35:49 +0200
Message-ID: <83a869cd0907311335h3065547aqc736573a663b6d42@mail.gmail.com>
Subject: [PATCH] remove wrong probe_resp_plcp write
From: gregor kowski <gregor.kowski@gmail.com>
To: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Cc: Michael Buesch <mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The tkip hw support uncovered a bug in b43_write_probe_resp_template : it is
writing at the wrong shm offset, it is in the B43_SHM_SH_TKIPTSCTTAK zone. This
patch comments these writes.

Signed-off-by: Gregor Kowski <gregor.kowski@gmail.com>

Index: linux-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/b43/main.c	2009-07-31
20:32:21.000000000 +0000
+++ linux-2.6/drivers/net/wireless/b43/main.c	2009-07-31
20:32:28.000000000 +0000
@@ -1505,10 +1505,13 @@
 	/* Looks like PLCP headers plus packet timings are stored for
 	 * all possible basic rates
 	 */
+	/* FIXME this is the wrong offset : it goes in tkip rx phase1 shm */
+#if 0
 	b43_write_probe_resp_plcp(dev, 0x31A, size, &b43_b_ratetable[0]);
 	b43_write_probe_resp_plcp(dev, 0x32C, size, &b43_b_ratetable[1]);
 	b43_write_probe_resp_plcp(dev, 0x33E, size, &b43_b_ratetable[2]);
 	b43_write_probe_resp_plcp(dev, 0x350, size, &b43_b_ratetable[3]);
+#endif

 	size = min((size_t) size, 0x200 - sizeof(struct b43_plcp_hdr6));
 	b43_write_template_common(dev, probe_resp_data,
