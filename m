Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:32884 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748Ab1A3MY6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 07:24:58 -0500
Received: by ewy5 with SMTP id 5so2118606ewy.19
        for <linux-wireless@vger.kernel.org>; Sun, 30 Jan 2011 04:24:56 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 20/21] rt2x00: Kill all tasklets during device removal
Date: Sun, 30 Jan 2011 13:23:42 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201101301316.04044.IvDoorn@gmail.com> <201101301323.04342.IvDoorn@gmail.com> <201101301323.23477.IvDoorn@gmail.com>
In-Reply-To: <201101301323.23477.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101301323.43235.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ivo van Doorn <IvDoorn@gmail.com>

During device removal all pending work and tasklets must
be guaranteed to be halted. So far only the txstatus_tasklet
was killed.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 5812a4e..e716285 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1067,6 +1067,10 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 	 * Kill the tx status tasklet.
 	 */
 	tasklet_kill(&rt2x00dev->txstatus_tasklet);
+	tasklet_kill(&rt2x00dev->pretbtt_tasklet);
+	tasklet_kill(&rt2x00dev->tbtt_tasklet);
+	tasklet_kill(&rt2x00dev->rxdone_tasklet);
+	tasklet_kill(&rt2x00dev->autowake_tasklet);
 
 	/*
 	 * Uninitialize device.
-- 
1.7.2.3

