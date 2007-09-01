Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:16429 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbXIAEfY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 00:35:24 -0400
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id D202F618FE1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 00:35:23 -0400 (EDT)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 12/35] Fix hex2str() and mac2str() to avoid buffer overlap
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 00:35:23 -0400
Message-ID: <20070901043523.2498.52761.stgit@dv.roinet.com>
In-Reply-To: <20070901043233.2498.95850.stgit@dv.roinet.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Declarations for two-dimensional arrays were written backwards.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 6ad6248..2ed80eb 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -474,7 +474,7 @@ static inline void at76_iwevent_bss_disconnect(struct net_device *netdev)
 static char *hex2str(void *buf, int len)
 {
 	static atomic_t a = ATOMIC_INIT(0);
-	static char bufs[3 * HEX2STR_MAX_LEN + 1][HEX2STR_BUFFERS];
+	static char bufs[HEX2STR_BUFFERS][3 * HEX2STR_MAX_LEN + 1];
 	char *ret = bufs[atomic_inc_return(&a) & (HEX2STR_BUFFERS - 1)];
 	char *obuf = ret;
 	u8 *ibuf = buf;
@@ -503,7 +503,7 @@ static char *hex2str(void *buf, int len)
 static inline char *mac2str(u8 *mac)
 {
 	static atomic_t a = ATOMIC_INIT(0);
-	static char bufs[6 * 3][MAC2STR_BUFFERS];
+	static char bufs[MAC2STR_BUFFERS][6 * 3];
 	char *str;
 
 	str = bufs[atomic_inc_return(&a) & (MAC2STR_BUFFERS - 1)];
