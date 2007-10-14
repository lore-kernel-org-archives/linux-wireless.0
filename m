Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:50632 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752762AbXJNAkN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Oct 2007 20:40:13 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH] p54: Make filter configuration atomic
Date: Sat, 13 Oct 2007 20:35:05 -0400
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Dmitry Torokhov <dtor@insightbb.com>
Message-Id: <20071014003505.16935.43676.stgit@magic.sourmilk.net> (sfid-20071014_014020_881499_764E3FE8)
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

p54_set_filter is now called from configure_filter, which is not
allowed to sleep. The filter configuration packet allocation should be
atomic now.

Thanks to Dmitry Torokhov <dtor@insightbb.com> for reporting this bug.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/p54common.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/p54common.c b/drivers/net/wireless/p54common.c
index 2c63cf0..1437db0 100644
--- a/drivers/net/wireless/p54common.c
+++ b/drivers/net/wireless/p54common.c
@@ -577,7 +577,7 @@ static int p54_set_filter(struct ieee80211_hw *dev, u16 filter_type,
 	struct p54_tx_control_filter *filter;
 
 	hdr = kzalloc(sizeof(*hdr) + sizeof(*filter) +
-		      priv->tx_hdr_len, GFP_KERNEL);
+		      priv->tx_hdr_len, GFP_ATOMIC);
 	if (!hdr)
 		return -ENOMEM;
 

