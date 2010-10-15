Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:56478 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456Ab0JOMyK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 08:54:10 -0400
From: Julia Lawall <julia@diku.dk>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: kernel-janitors@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] drivers/net/wireless/p54/eeprom.c: Return -ENOMEM on memory allocation failure
Date: Fri, 15 Oct 2010 15:00:06 +0200
Message-Id: <1287147610-8041-3-git-send-email-julia@diku.dk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

In this code, 0 is returned on memory allocation failure, even though other
failures return -ENOMEM or other similar values.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression ret;
expression x,e1,e2,e3;
@@

ret = 0
... when != ret = e1
*x = \(kmalloc\|kcalloc\|kzalloc\)(...)
... when != ret = e2
if (x == NULL) { ... when != ret = e3
  return ret;
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/wireless/p54/eeprom.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -u -p a/drivers/net/wireless/p54/eeprom.c b/drivers/net/wireless/p54/eeprom.c
--- a/drivers/net/wireless/p54/eeprom.c
+++ b/drivers/net/wireless/p54/eeprom.c
@@ -261,8 +261,10 @@ static int p54_generate_channel_lists(st
 	list->max_entries = max_channel_num;
 	list->channels = kzalloc(sizeof(struct p54_channel_entry) *
 				 max_channel_num, GFP_KERNEL);
-	if (!list->channels)
+	if (!list->channels) {
+		ret = -ENOMEM;
 		goto free;
+	}
 
 	for (i = 0; i < max_channel_num; i++) {
 		if (i < priv->iq_autocal_len) {

