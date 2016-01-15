Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:62140 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824AbcAONKp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2016 08:10:45 -0500
Subject: [PATCH v3 2/3] rsi: Delete unnecessary variable initialisations in
 rsi_send_data_pkt()
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Fariya Fatima <fariyaf@gmail.com>,
	Jahnavi Meher <jahnavi.meher@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
References: <566ABCD9.1060404@users.sourceforge.net>
 <5687E169.4070704@users.sourceforge.net>
 <5698EE65.7010607@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>,
	"John W. Linville" <linville@tuxdriver.com>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <5698EFC4.7000308@users.sourceforge.net> (sfid-20160115_141114_492027_586243FF)
Date: Fri, 15 Jan 2016 14:10:28 +0100
MIME-Version: 1.0
In-Reply-To: <5698EE65.7010607@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 017d1bb49f46266ffeb33178ddd3022d6b341d71 Mon Sep 17 00:00:00 2001
From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 15 Jan 2016 13:35:47 +0100
Subject: [PATCH 2/3] rsi: Delete unnecessary variable initialisations in
 rsi_send_data_pkt()

Omit explicit initialisation at the beginning for four local variables
which are redefined before their first use.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/net/wireless/rsi/rsi_91x_pkt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_pkt.c b/drivers/net/wireless/rsi/rsi_91x_pkt.c
index 571eaba..4322df1 100644
--- a/drivers/net/wireless/rsi/rsi_91x_pkt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_pkt.c
@@ -27,15 +27,15 @@
 int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
 {
 	struct rsi_hw *adapter = common->priv;
-	struct ieee80211_hdr *tmp_hdr = NULL;
+	struct ieee80211_hdr *tmp_hdr;
 	struct ieee80211_tx_info *info;
 	struct skb_info *tx_params;
-	struct ieee80211_bss_conf *bss = NULL;
+	struct ieee80211_bss_conf *bss;
 	int status = -EINVAL;
 	u8 ieee80211_size = MIN_802_11_HDR_LEN;
-	u8 extnd_size = 0;
+	u8 extnd_size;
 	__le16 *frame_desc;
-	u16 seq_num = 0;
+	u16 seq_num;
 
 	info = IEEE80211_SKB_CB(skb);
 	bss = &info->control.vif->bss_conf;
-- 
2.6.3

