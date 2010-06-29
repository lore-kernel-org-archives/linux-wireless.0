Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:38403 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861Ab0F2TvQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 15:51:16 -0400
Received: by mail-ww0-f46.google.com with SMTP id 18so547wwb.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jun 2010 12:51:15 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 16/21] rt2x00: Disable link tuning in AP mode
Date: Tue, 29 Jun 2010 21:47:37 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006292138.13509.IvDoorn@gmail.com> <201006292146.44952.IvDoorn@gmail.com> <201006292147.11774.IvDoorn@gmail.com>
In-Reply-To: <201006292147.11774.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006292147.38367.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Since the link tuning is based on average RSSI values taken from all received
frames it doesn't make sense to enable it in AP mode where every associated
station provides independent RSSI values. Furthermore the legacy drivers
don't enable link tuning in AP mode as well.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00link.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00link.c b/drivers/net/wireless/rt2x00/rt2x00link.c
index 0efbf5a..2f8136c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00link.c
+++ b/drivers/net/wireless/rt2x00/rt2x00link.c
@@ -271,11 +271,11 @@ void rt2x00link_start_tuner(struct rt2x00_dev *rt2x00dev)
 
 	/*
 	 * Link tuning should only be performed when
-	 * an active sta or master interface exists.
-	 * Single monitor mode interfaces should never have
-	 * work with link tuners.
+	 * an active sta interface exists. AP interfaces
+	 * don't need link tuning and monitor mode interfaces
+	 * should never have to work with link tuners.
 	 */
-	if (!rt2x00dev->intf_ap_count && !rt2x00dev->intf_sta_count)
+	if (!rt2x00dev->intf_sta_count)
 		return;
 
 	rt2x00link_reset_tuner(rt2x00dev, false);
-- 
1.6.6.1

