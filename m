Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:54602 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212Ab1FMWfl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 18:35:41 -0400
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh01-2.mail.saunalahti.fi (Postfix) with SMTP id 5BA008C527
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:35:40 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-184-248.elisa-laajakaista.fi [88.115.184.248])
	by emh05.mail.saunalahti.fi (Postfix) with ESMTP id 4308C27D84
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:35:39 +0300 (EEST)
Subject: [PATCH v2 08/27] mac80211: rename ieee80211_fragment_entry to
	mac80211_fragment_entry
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 14 Jun 2011 01:35:38 +0300
Message-ID: <20110613223538.10517.64883.stgit@localhost6.localdomain6> (sfid-20110614_003544_258319_75140091)
In-Reply-To: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
References: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@adurom.com>
---
 net/mac80211/mac80211_i.h |    4 ++--
 net/mac80211/rx.c         |   10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/mac80211_i.h b/net/mac80211/mac80211_i.h
index d35b195..fa766b2 100644
--- a/net/mac80211/mac80211_i.h
+++ b/net/mac80211/mac80211_i.h
@@ -62,7 +62,7 @@ struct mac80211_local;
 #define IEEE80211_DEFAULT_MAX_SP_LEN		\
 	IEEE80211_WMM_IE_STA_QOSINFO_SP_ALL
 
-struct ieee80211_fragment_entry {
+struct mac80211_fragment_entry {
 	unsigned long first_frag_time;
 	unsigned int seq;
 	unsigned int rx_queue;
@@ -565,7 +565,7 @@ struct ieee80211_sub_if_data {
 	bool old_idle;
 
 	/* Fragment table for host-based reassembly */
-	struct ieee80211_fragment_entry	fragments[IEEE80211_FRAGMENT_MAX];
+	struct mac80211_fragment_entry	fragments[IEEE80211_FRAGMENT_MAX];
 	unsigned int fragment_next;
 
 	struct ieee80211_key __rcu *keys[NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS];
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 22d066d..d49fa8b 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1254,12 +1254,12 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 	return RX_CONTINUE;
 } /* ieee80211_rx_h_sta_process */
 
-static inline struct ieee80211_fragment_entry *
+static inline struct mac80211_fragment_entry *
 ieee80211_reassemble_add(struct ieee80211_sub_if_data *sdata,
 			 unsigned int frag, unsigned int seq, int rx_queue,
 			 struct sk_buff **skb)
 {
-	struct ieee80211_fragment_entry *entry;
+	struct mac80211_fragment_entry *entry;
 	int idx;
 
 	idx = sdata->fragment_next;
@@ -1293,12 +1293,12 @@ ieee80211_reassemble_add(struct ieee80211_sub_if_data *sdata,
 	return entry;
 }
 
-static inline struct ieee80211_fragment_entry *
+static inline struct mac80211_fragment_entry *
 ieee80211_reassemble_find(struct ieee80211_sub_if_data *sdata,
 			  unsigned int frag, unsigned int seq,
 			  int rx_queue, struct ieee80211_hdr *hdr)
 {
-	struct ieee80211_fragment_entry *entry;
+	struct mac80211_fragment_entry *entry;
 	int i, idx;
 
 	idx = sdata->fragment_next;
@@ -1343,7 +1343,7 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 	u16 sc;
 	__le16 fc;
 	unsigned int frag, seq;
-	struct ieee80211_fragment_entry *entry;
+	struct mac80211_fragment_entry *entry;
 	struct sk_buff *skb;
 	struct ieee80211_rx_status *status;
 

