Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64201 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab0L0OIV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Dec 2010 09:08:21 -0500
Received: by mail-ww0-f44.google.com with SMTP id 36so9024113wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Dec 2010 06:08:20 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 07/10] rt2x00: Remove superfluous assignment of mpdu_density
Date: Mon, 27 Dec 2010 15:06:36 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201012271504.30848.IvDoorn@gmail.com> <201012271505.56572.IvDoorn@gmail.com> <201012271506.18101.IvDoorn@gmail.com>
In-Reply-To: <201012271506.18101.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012271506.37080.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

The tx desciptor already gets initialized to 0. Hence, there's no need
to explicitly assign 0 to mpdu_density here.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00ht.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00ht.c b/drivers/net/wireless/rt2x00/rt2x00ht.c
index c637bca..b7ad46e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00ht.c
+++ b/drivers/net/wireless/rt2x00/rt2x00ht.c
@@ -40,8 +40,6 @@ void rt2x00ht_create_tx_descriptor(struct queue_entry *entry,
 	if (tx_info->control.sta)
 		txdesc->mpdu_density =
 		    tx_info->control.sta->ht_cap.ampdu_density;
-	else
-		txdesc->mpdu_density = 0;
 
 	txdesc->ba_size = 7;	/* FIXME: What value is needed? */
 
-- 
1.7.2.3

