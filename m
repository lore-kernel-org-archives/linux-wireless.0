Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56580 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091AbYC0Mub (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2008 08:50:31 -0400
Subject: [PATCH] mac80211: reorder fields to make some structures smaller
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Carlos Cobo <luisca@cozybit.com>
Content-Type: text/plain
Date: Wed, 26 Mar 2008 23:21:47 +0100
Message-Id: <1206570107.22530.23.camel@johannes.berg> (sfid-20080327_125212_949071_20C5556E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch reorders some fields in various structures to have
less padding within the structures, making them smaller. It
doesn't yet make any type adjustments, but often size_t is used
for example for IE lengths which is total overkill since size_t
will be 8 bytes long on 64-bit yet the length can at most fill
a u8.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |   50 ++++++++++++++++++++++++---------------------
 net/mac80211/sta_info.h    |    8 +++----
 2 files changed, 31 insertions(+), 27 deletions(-)

--- everything.orig/net/mac80211/sta_info.h	2008-03-26 21:26:41.000000000 +0100
+++ everything/net/mac80211/sta_info.h	2008-03-26 21:27:42.000000000 +0100
@@ -74,10 +74,10 @@ enum ieee80211_sta_info_flags {
  * @addba_req_num: number of times addBA request has been sent.
  */
 struct tid_ampdu_tx {
+	struct timer_list addba_resp_timer;
+	u16 ssn;
 	u8 state;
 	u8 dialog_token;
-	u16 ssn;
-	struct timer_list addba_resp_timer;
 	u8 addba_req_num;
 };
 
@@ -95,6 +95,8 @@ struct tid_ampdu_tx {
  * @session_timer: check if peer keeps Tx-ing on the TID (by timeout value)
  */
 struct tid_ampdu_rx {
+	struct sk_buff **reorder_buf;
+	struct timer_list session_timer;
 	u8 state;
 	u8 dialog_token;
 	u16 ssn;
@@ -102,8 +104,6 @@ struct tid_ampdu_rx {
 	u16 timeout;
 	u16 head_seq_num;
 	u16 stored_mpdu_num;
-	struct sk_buff **reorder_buf;
-	struct timer_list session_timer;
 };
 
 /**
--- everything.orig/net/mac80211/ieee80211_i.h	2008-03-26 21:25:41.000000000 +0100
+++ everything/net/mac80211/ieee80211_i.h	2008-03-26 21:27:42.000000000 +0100
@@ -73,11 +73,12 @@ struct ieee80211_fragment_entry {
 struct ieee80211_sta_bss {
 	struct list_head list;
 	struct ieee80211_sta_bss *hnext;
+	size_t ssid_len;
+
 	atomic_t users;
 
 	u8 bssid[ETH_ALEN];
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
-	size_t ssid_len;
 	u16 capability; /* host byte order */
 	enum ieee80211_band band;
 	int freq;
@@ -98,8 +99,8 @@ struct ieee80211_sta_bss {
 #define IEEE80211_MAX_SUPP_RATES 32
 	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
 	size_t supp_rates_len;
-	int beacon_int;
 	u64 timestamp;
+	int beacon_int;
 
 	int probe_resp;
 	unsigned long last_update;
@@ -154,9 +155,7 @@ struct ieee80211_tx_data {
 	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
-	u16 fc, ethertype;
 	struct ieee80211_key *key;
-	unsigned int flags;
 
 	struct ieee80211_tx_control *control;
 	struct ieee80211_channel *channel;
@@ -168,8 +167,11 @@ struct ieee80211_tx_data {
 
 	/* Extra fragments (in addition to the first fragment
 	 * in skb) */
-	int num_extra_frag;
 	struct sk_buff **extra_frag;
+	int num_extra_frag;
+
+	u16 fc, ethertype;
+	unsigned int flags;
 };
 
 
@@ -192,12 +194,12 @@ struct ieee80211_rx_data {
 	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
-	u16 fc, ethertype;
 	struct ieee80211_key *key;
-	unsigned int flags;
-
 	struct ieee80211_rx_status *status;
 	struct ieee80211_rate *rate;
+
+	u16 fc, ethertype;
+	unsigned int flags;
 	int sent_ps_buffered;
 	int queue;
 	int load;
@@ -222,9 +224,9 @@ struct ieee80211_tx_packet_data {
 struct ieee80211_tx_stored_packet {
 	struct ieee80211_tx_control control;
 	struct sk_buff *skb;
-	int num_extra_frag;
 	struct sk_buff **extra_frag;
 	struct ieee80211_rate *last_frag_rate;
+	int num_extra_frag;
 	unsigned int last_frag_rate_ctrl_probe;
 };
 
@@ -246,8 +248,8 @@ struct ieee80211_if_ap {
 	 * bitmap_empty :)
 	 * NB: don't touch this bitmap, use sta_info_{set,clear}_tim_bit */
 	u8 tim[sizeof(unsigned long) * BITS_TO_LONGS(IEEE80211_MAX_AID + 1)];
-	atomic_t num_sta_ps; /* number of stations in PS mode */
 	struct sk_buff_head ps_bc_buf;
+	atomic_t num_sta_ps; /* number of stations in PS mode */
 	int dtim_count;
 	int force_unicast_rateidx; /* forced TX rateidx for unicast frames */
 	int max_ratectrl_rateidx; /* max TX rateidx for rate control */
@@ -255,8 +257,8 @@ struct ieee80211_if_ap {
 };
 
 struct ieee80211_if_wds {
-	u8 remote_addr[ETH_ALEN];
 	struct sta_info *sta;
+	u8 remote_addr[ETH_ALEN];
 };
 
 struct ieee80211_if_vlan {
@@ -290,12 +292,12 @@ struct mesh_config {
 	u8  dot11MeshTTL;
 	bool auto_open_plinks;
 	/* HWMP parameters */
-	u32 dot11MeshHWMPactivePathTimeout;
-	u16 dot11MeshHWMPpreqMinInterval;
-	u16 dot11MeshHWMPnetDiameterTraversalTime;
 	u8  dot11MeshHWMPmaxPREQretries;
 	u32 path_refresh_time;
 	u16 min_discovery_timeout;
+	u32 dot11MeshHWMPactivePathTimeout;
+	u16 dot11MeshHWMPpreqMinInterval;
+	u16 dot11MeshHWMPnetDiameterTraversalTime;
 };
 
 
@@ -314,23 +316,22 @@ struct mesh_config {
 #define IEEE80211_STA_AUTO_CHANNEL_SEL	BIT(12)
 #define IEEE80211_STA_PRIVACY_INVOKED	BIT(13)
 struct ieee80211_if_sta {
+	struct timer_list timer;
+	struct work_struct work;
+	u8 bssid[ETH_ALEN], prev_bssid[ETH_ALEN];
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	enum {
 		IEEE80211_DISABLED, IEEE80211_AUTHENTICATE,
 		IEEE80211_ASSOCIATE, IEEE80211_ASSOCIATED,
 		IEEE80211_IBSS_SEARCH, IEEE80211_IBSS_JOINED,
 		IEEE80211_MESH_UP
 	} state;
-	struct timer_list timer;
-	struct work_struct work;
-	u8 bssid[ETH_ALEN], prev_bssid[ETH_ALEN];
-	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	size_t ssid_len;
 	u8 scan_ssid[IEEE80211_MAX_SSID_LEN];
 	size_t scan_ssid_len;
 #ifdef CONFIG_MAC80211_MESH
 	struct timer_list mesh_path_timer;
 	u8 mesh_id[IEEE80211_MAX_MESH_ID_LEN];
-	bool accepting_plinks;
 	size_t mesh_id_len;
 	/* Active Path Selection Protocol Identifier */
 	u8 mesh_pp_id[4];
@@ -354,6 +355,7 @@ struct ieee80211_if_sta {
 	struct mesh_stats mshstats;
 	struct mesh_config mshcfg;
 	u8 mesh_seqnum[3];
+	bool accepting_plinks;
 #endif
 	u16 aid;
 	u16 ap_capab, capab;
@@ -364,16 +366,18 @@ struct ieee80211_if_sta {
 	u8 *assocreq_ies, *assocresp_ies;
 	size_t assocreq_ies_len, assocresp_ies_len;
 
+	struct sk_buff_head skb_queue;
+
 	int auth_tries, assoc_tries;
 
+	unsigned long request;
+
+	unsigned long last_probe;
+
 	unsigned int flags;
 #define IEEE80211_STA_REQ_SCAN 0
 #define IEEE80211_STA_REQ_AUTH 1
 #define IEEE80211_STA_REQ_RUN  2
-	unsigned long request;
-	struct sk_buff_head skb_queue;
-
-	unsigned long last_probe;
 
 #define IEEE80211_AUTH_ALG_OPEN BIT(0)
 #define IEEE80211_AUTH_ALG_SHARED_KEY BIT(1)


