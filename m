Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:61245 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbcAONJ2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2016 08:09:28 -0500
Subject: [PATCH v3 1/3] rsi: Delete unnecessary variable initialisations in
 rsi_send_mgmt_pkt()
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
Message-ID: <5698EF71.7060102@users.sourceforge.net> (sfid-20160115_141005_745889_7EC49114)
Date: Fri, 15 Jan 2016 14:09:05 +0100
MIME-Version: 1.0
In-Reply-To: <5698EE65.7010607@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 15 Jan 2016 13:30:39 +0100

Omit explicit initialisation at the beginning for four local variables
which are redefined before their first use.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/net/wireless/rsi/rsi_91x_pkt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_pkt.c b/drivers/net/wireless/rsi/rsi_91x_pkt.c
index 702593f..571eaba 100644
--- a/drivers/net/wireless/rsi/rsi_91x_pkt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_pkt.c
@@ -123,15 +123,15 @@ int rsi_send_mgmt_pkt(struct rsi_common *common,
 		      struct sk_buff *skb)
 {
 	struct rsi_hw *adapter = common->priv;
-	struct ieee80211_hdr *wh = NULL;
+	struct ieee80211_hdr *wh;
 	struct ieee80211_tx_info *info;
-	struct ieee80211_bss_conf *bss = NULL;
+	struct ieee80211_bss_conf *bss;
 	struct ieee80211_hw *hw = adapter->hw;
 	struct ieee80211_conf *conf = &hw->conf;
 	struct skb_info *tx_params;
 	int status = -E2BIG;
-	__le16 *msg = NULL;
-	u8 extnd_size = 0;
+	__le16 *msg;
+	u8 extnd_size;
 	u8 vap_id = 0;
 
 	info = IEEE80211_SKB_CB(skb);
-- 
2.6.3

