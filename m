Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sinikuusama.dnainternet.net ([83.102.40.134]:60641 "EHLO
	sinikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752589AbZKVSQh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Nov 2009 13:16:37 -0500
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 1/2] rndis_wlan: fix buffer overflow in rndis_query_oid
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 22 Nov 2009 20:16:42 +0200
Message-ID: <20091122181642.24641.73461.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rndis_query_oid overwrites *len which stores buffer size to return full size
of received command and then uses *len with memcpy to fill buffer with
command.

Ofcourse memcpy should be done before replacing buffer size.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index aa1880a..8b09b04 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -733,12 +733,13 @@ static int rndis_query_oid(struct usbnet *dev, __le32 oid, void *data, int *len)
 			le32_to_cpu(u.get_c->status));
 
 	if (ret == 0) {
+		memcpy(data, u.buf + le32_to_cpu(u.get_c->offset) + 8, *len);
+
 		ret = le32_to_cpu(u.get_c->len);
 		if (ret > *len)
 			*len = ret;
-		memcpy(data, u.buf + le32_to_cpu(u.get_c->offset) + 8, *len);
-		ret = rndis_error_status(u.get_c->status);
 
+		ret = rndis_error_status(u.get_c->status);
 		if (ret < 0)
 			devdbg(dev, "rndis_query_oid(%s): device returned "
 				"error,  0x%08x (%d)", oid_to_string(oid),

