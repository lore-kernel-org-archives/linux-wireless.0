Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:61862 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758231Ab1DYK03 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 06:26:29 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 25 Apr 2011 03:26:02 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 2/5] mac80211: Fix warnings due to -Wunused-but-set-variable
Date: Mon, 25 Apr 2011 15:56:17 +0530
Message-ID: <1303727180-22212-2-git-send-email-rmanoharan@atheros.com> (sfid-20110425_122640_257104_7BB03548)
In-Reply-To: <1303727180-22212-1-git-send-email-rmanoharan@atheros.com>
References: <1303727180-22212-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These warnings are exposed by gcc 4.6.
net/mac80211/sta_info.c: In function 'sta_info_cleanup_expire_buffered':
net/mac80211/sta_info.c:590:32: warning: variable 'sdata' set but not used
net/mac80211/ibss.c: In function 'ieee80211_rx_mgmt_auth_ibss':
net/mac80211/ibss.c:43:34: warning: variable 'status_code' set but not used
net/mac80211/work.c: In function 'ieee80211_send_assoc':
net/mac80211/work.c:203:9: warning: variable 'len' set but not used
net/mac80211/tx.c: In function '__ieee80211_parse_tx_radiotap':
net/mac80211/tx.c:1039:35: warning: variable 'sband' set but not used
net/mac80211/mesh.c: In function 'ieee80211_mesh_rx_queued_mgmt':
net/mac80211/mesh.c:616:28: warning: variable 'ifmsh' set but not used
 ...

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 net/mac80211/aes_ccm.c   |    6 ++----
 net/mac80211/ibss.c      |    7 +------
 net/mac80211/mesh.c      |    3 ---
 net/mac80211/mesh_hwmp.c |    4 ----
 net/mac80211/sta_info.c  |    2 --
 net/mac80211/tx.c        |    8 --------
 net/mac80211/work.c      |    6 ++----
 7 files changed, 5 insertions(+), 31 deletions(-)

diff --git a/net/mac80211/aes_ccm.c b/net/mac80211/aes_ccm.c
index 4bd6ef0..b9b595c 100644
--- a/net/mac80211/aes_ccm.c
+++ b/net/mac80211/aes_ccm.c
@@ -54,13 +54,12 @@ void ieee80211_aes_ccm_encrypt(struct crypto_cipher *tfm, u8 *scratch,
 			       u8 *cdata, u8 *mic)
 {
 	int i, j, last_len, num_blocks;
-	u8 *pos, *cpos, *b, *s_0, *e, *b_0, *aad;
+	u8 *pos, *cpos, *b, *s_0, *e, *b_0;
 
 	b = scratch;
 	s_0 = scratch + AES_BLOCK_LEN;
 	e = scratch + 2 * AES_BLOCK_LEN;
 	b_0 = scratch + 3 * AES_BLOCK_LEN;
-	aad = scratch + 4 * AES_BLOCK_LEN;
 
 	num_blocks = DIV_ROUND_UP(data_len, AES_BLOCK_LEN);
 	last_len = data_len % AES_BLOCK_LEN;
@@ -94,13 +93,12 @@ int ieee80211_aes_ccm_decrypt(struct crypto_cipher *tfm, u8 *scratch,
 			      u8 *cdata, size_t data_len, u8 *mic, u8 *data)
 {
 	int i, j, last_len, num_blocks;
-	u8 *pos, *cpos, *b, *s_0, *a, *b_0, *aad;
+	u8 *pos, *cpos, *b, *s_0, *a, *b_0;
 
 	b = scratch;
 	s_0 = scratch + AES_BLOCK_LEN;
 	a = scratch + 2 * AES_BLOCK_LEN;
 	b_0 = scratch + 3 * AES_BLOCK_LEN;
-	aad = scratch + 4 * AES_BLOCK_LEN;
 
 	num_blocks = DIV_ROUND_UP(data_len, AES_BLOCK_LEN);
 	last_len = data_len % AES_BLOCK_LEN;
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 1488396..b81860c 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -40,7 +40,7 @@ static void ieee80211_rx_mgmt_auth_ibss(struct ieee80211_sub_if_data *sdata,
 					struct ieee80211_mgmt *mgmt,
 					size_t len)
 {
-	u16 auth_alg, auth_transaction, status_code;
+	u16 auth_alg, auth_transaction;
 
 	lockdep_assert_held(&sdata->u.ibss.mtx);
 
@@ -49,7 +49,6 @@ static void ieee80211_rx_mgmt_auth_ibss(struct ieee80211_sub_if_data *sdata,
 
 	auth_alg = le16_to_cpu(mgmt->u.auth.auth_alg);
 	auth_transaction = le16_to_cpu(mgmt->u.auth.auth_transaction);
-	status_code = le16_to_cpu(mgmt->u.auth.status_code);
 
 	/*
 	 * IEEE 802.11 standard does not require authentication in IBSS
@@ -527,8 +526,6 @@ static void ieee80211_sta_merge_ibss(struct ieee80211_sub_if_data *sdata)
 static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_supported_band *sband;
 	u8 bssid[ETH_ALEN];
 	u16 capability;
 	int i;
@@ -551,8 +548,6 @@ static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
 	printk(KERN_DEBUG "%s: Creating new IBSS network, BSSID %pM\n",
 	       sdata->name, bssid);
 
-	sband = local->hw.wiphy->bands[ifibss->channel->band];
-
 	capability = WLAN_CAPABILITY_IBSS;
 
 	if (ifibss->privacy)
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 1120797..c1299e2 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -613,12 +613,9 @@ void ieee80211_mesh_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 				   struct sk_buff *skb)
 {
 	struct ieee80211_rx_status *rx_status;
-	struct ieee80211_if_mesh *ifmsh;
 	struct ieee80211_mgmt *mgmt;
 	u16 stype;
 
-	ifmsh = &sdata->u.mesh;
-
 	rx_status = IEEE80211_SKB_RXCB(skb);
 	mgmt = (struct ieee80211_mgmt *) skb->data;
 	stype = le16_to_cpu(mgmt->frame_control) & IEEE80211_FCTL_STYPE;
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 5bf64d7..e57f2e7 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -633,7 +633,6 @@ static void hwmp_perr_frame_process(struct ieee80211_sub_if_data *sdata,
 	struct mesh_path *mpath;
 	u8 ttl;
 	u8 *ta, *target_addr;
-	u8 target_flags;
 	u32 target_sn;
 	u16 target_rcode;
 
@@ -644,7 +643,6 @@ static void hwmp_perr_frame_process(struct ieee80211_sub_if_data *sdata,
 		return;
 	}
 	ttl--;
-	target_flags = PERR_IE_TARGET_FLAGS(perr_elem);
 	target_addr = PERR_IE_TARGET_ADDR(perr_elem);
 	target_sn = PERR_IE_TARGET_SN(perr_elem);
 	target_rcode = PERR_IE_TARGET_RCODE(perr_elem);
@@ -675,12 +673,10 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mesh_path *mpath;
-	u8 *ta;
 	u8 ttl, flags, hopcount;
 	u8 *orig_addr;
 	u32 orig_sn, metric;
 
-	ta = mgmt->sa;
 	ttl = rann->rann_ttl;
 	if (ttl <= 1) {
 		ifmsh->mshstats.dropped_frames_ttl++;
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index a03d8a3..d9e6e81 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -587,7 +587,6 @@ static bool sta_info_cleanup_expire_buffered(struct ieee80211_local *local,
 {
 	unsigned long flags;
 	struct sk_buff *skb;
-	struct ieee80211_sub_if_data *sdata;
 
 	if (skb_queue_empty(&sta->ps_tx_buf))
 		return false;
@@ -604,7 +603,6 @@ static bool sta_info_cleanup_expire_buffered(struct ieee80211_local *local,
 		if (!skb)
 			break;
 
-		sdata = sta->sdata;
 		local->total_ps_buffered--;
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 		printk(KERN_DEBUG "Buffered frame expired (STA %pM)\n",
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 17b10be..a2043e4 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1036,14 +1036,11 @@ static bool __ieee80211_parse_tx_radiotap(struct ieee80211_tx_data *tx,
 	struct ieee80211_radiotap_iterator iterator;
 	struct ieee80211_radiotap_header *rthdr =
 		(struct ieee80211_radiotap_header *) skb->data;
-	struct ieee80211_supported_band *sband;
 	bool hw_frag;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	int ret = ieee80211_radiotap_iterator_init(&iterator, rthdr, skb->len,
 						   NULL);
 
-	sband = tx->local->hw.wiphy->bands[tx->channel->band];
-
 	info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
 	tx->flags &= ~IEEE80211_TX_FRAGMENTED;
 
@@ -1442,11 +1439,8 @@ static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_tx_data tx;
 	ieee80211_tx_result res_prepare;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	u16 queue;
 	bool result = true;
 
-	queue = skb_get_queue_mapping(skb);
-
 	if (unlikely(skb->len < 10)) {
 		dev_kfree_skb(skb);
 		return true;
@@ -2485,7 +2479,6 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct sk_buff *skb = NULL;
-	struct sta_info *sta;
 	struct ieee80211_tx_data tx;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_if_ap *bss = NULL;
@@ -2527,7 +2520,6 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 
 	info = IEEE80211_SKB_CB(skb);
 
-	sta = tx.sta;
 	tx.flags |= IEEE80211_TX_PS_BUFFERED;
 	tx.channel = local->hw.conf.channel;
 	info->band = tx.channel->band;
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index e73c8ca..a94b312 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -198,9 +198,8 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	u8 *pos, qos_info;
-	const u8 *ies;
 	size_t offset = 0, noffset;
-	int i, len, count, rates_len, supp_rates_len;
+	int i, count, rates_len, supp_rates_len;
 	u16 capab;
 	struct ieee80211_supported_band *sband;
 	u32 rates = 0;
@@ -285,7 +284,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
 	}
 
 	/* SSID */
-	ies = pos = skb_put(skb, 2 + wk->assoc.ssid_len);
+	pos = skb_put(skb, 2 + wk->assoc.ssid_len);
 	*pos++ = WLAN_EID_SSID;
 	*pos++ = wk->assoc.ssid_len;
 	memcpy(pos, wk->assoc.ssid, wk->assoc.ssid_len);
@@ -295,7 +294,6 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
 	if (supp_rates_len > 8)
 		supp_rates_len = 8;
 
-	len = sband->n_bitrates;
 	pos = skb_put(skb, supp_rates_len + 2);
 	*pos++ = WLAN_EID_SUPP_RATES;
 	*pos++ = supp_rates_len;
-- 
1.7.4.4

