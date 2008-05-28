Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:36688 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbYE1Rpi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2008 13:45:38 -0400
Received: from mail.atheros.com ([192.168.11.2])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 28 May 2008 10:45:38 -0700
Date: Wed, 28 May 2008 23:15:32 +0530
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <ron.rindjunsky@intel.com>, <linux-wireless@vger.kernel.org>,
	<Luis.Rodriguez@Atheros.com>, <tomasw@gmail.com>
Subject: [PATCH]v1 mac80211: fix alignment issue with compare_ether_addr()
Message-ID: <20080528174532.GA5575@senthil-lnx.users.atheros.com> (sfid-20080528_194542_984620_52429297)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This addresses an alignment issue with compare_ether_addr().
The addresses passed to compare_ether_addr should be two bytes aligned.
It may function properly in x86 platform. However may not work properly
on IA-64 or ARM processor.

This also fixes a typo in mlme.c where the sk_buff struct name is incorect.
Though sizeof() works for any incorrect structure pointer name as its just
a pointer length that we want, lets just fix it.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/mlme.c |    4 ++--
 net/mac80211/rx.c   |    4 ++--
 net/mac80211/util.c |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c7819fd..4be7736 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1316,7 +1316,7 @@ static void ieee80211_sta_process_addba_request(struct net_device *dev,
 
 	/* prepare reordering buffer */
 	tid_agg_rx->reorder_buf =
-		kmalloc(buf_size * sizeof(struct sk_buf *), GFP_ATOMIC);
+		kmalloc(buf_size * sizeof(struct sk_buff *), GFP_ATOMIC);
 	if (!tid_agg_rx->reorder_buf) {
 		if (net_ratelimit())
 			printk(KERN_ERR "can not allocate reordering buffer "
@@ -1325,7 +1325,7 @@ static void ieee80211_sta_process_addba_request(struct net_device *dev,
 		goto end;
 	}
 	memset(tid_agg_rx->reorder_buf, 0,
-		buf_size * sizeof(struct sk_buf *));
+		buf_size * sizeof(struct sk_buff *));
 
 	if (local->ops->ampdu_action)
 		ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_RX_START,
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 9400a97..a3643fd 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1116,7 +1116,7 @@ ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
 	u16 fc, hdrlen, ethertype;
 	u8 *payload;
 	u8 dst[ETH_ALEN];
-	u8 src[ETH_ALEN];
+	u8 src[ETH_ALEN] __aligned(2);
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	DECLARE_MAC_BUF(mac);
@@ -1259,7 +1259,7 @@ ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
  */
 static bool ieee80211_frame_allowed(struct ieee80211_rx_data *rx)
 {
-	static const u8 pae_group_addr[ETH_ALEN]
+	static const u8 pae_group_addr[ETH_ALEN] __aligned(2)
 		= { 0x01, 0x80, 0xC2, 0x00, 0x00, 0x03 };
 	struct ethhdr *ehdr = (struct ethhdr *) rx->skb->data;
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 5a77e2c..6513bc2 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -34,11 +34,11 @@ void *mac80211_wiphy_privid = &mac80211_wiphy_privid;
 
 /* See IEEE 802.1H for LLC/SNAP encapsulation/decapsulation */
 /* Ethernet-II snap header (RFC1042 for most EtherTypes) */
-const unsigned char rfc1042_header[] =
+const unsigned char rfc1042_header[] __aligned(2) =
 	{ 0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00 };
 
 /* Bridge-Tunnel header (for EtherTypes ETH_P_AARP and ETH_P_IPX) */
-const unsigned char bridge_tunnel_header[] =
+const unsigned char bridge_tunnel_header[] __aligned(2) =
 	{ 0xaa, 0xaa, 0x03, 0x00, 0x00, 0xf8 };
 
 
-- 
1.5.2.2

