Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35910 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab0JILgX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Oct 2010 07:36:23 -0400
Received: by ewy20 with SMTP id 20so23937ewy.19
        for <linux-wireless@vger.kernel.org>; Sat, 09 Oct 2010 04:36:22 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 01/06] rt2x00: Shortcut link state updates when not operating as STA
Date: Sat, 9 Oct 2010 13:33:16 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Message-Id: <201010091333.17274.IvDoorn@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00link.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00link.c b/drivers/net/wireless/rt2x00/rt2x00link.c
index 4d534e9..46836f8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00link.c
+++ b/drivers/net/wireless/rt2x00/rt2x00link.c
@@ -236,6 +236,12 @@ void rt2x00link_update_stats(struct rt2x00_dev *rt2x00dev,
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 
 	/*
+	 * No need to update the stats for !=STA interfaces
+	 */
+	if (!rt2x00dev->intf_sta_count)
+		return;
+
+	/*
 	 * Frame was received successfully since non-succesfull
 	 * frames would have been dropped by the hardware.
 	 */
-- 
1.7.2.3

