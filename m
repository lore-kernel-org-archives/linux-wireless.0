Return-Path: <SRS0=gKIL=TU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05C2AC04AAF
	for <linux-wireless@archiver.kernel.org>; Mon, 20 May 2019 08:55:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9FC2204FD
	for <linux-wireless@archiver.kernel.org>; Mon, 20 May 2019 08:55:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731668AbfETIzV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 20 May 2019 04:55:21 -0400
Received: from nbd.name ([46.4.11.11]:41444 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731660AbfETIzU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 May 2019 04:55:20 -0400
Received: from p548c87ba.dip0.t-ipconnect.de ([84.140.135.186] helo=bertha.datto.lan)
        by ds12 with esmtpa (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1hSe4i-0002Y7-Sw; Mon, 20 May 2019 10:55:16 +0200
From:   John Crispin <john@phrozen.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Shashidhar Lakkavalli <slakkavalli@datto.com>
Subject: [PATCH V5 1/8] mac80211: propagate HE operation info into ieee80211_sta
Date:   Mon, 20 May 2019 10:55:01 +0200
Message-Id: <20190520085508.5888-2-john@phrozen.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190520085508.5888-1-john@phrozen.org>
References: <20190520085508.5888-1-john@phrozen.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Upon a successful assoc a station shall store the content of the HE
operation element inside ieee80211_sta so that the driver can setup the
hardware accordingly.

Signed-off-by: Shashidhar Lakkavalli <slakkavalli@datto.com>
Signed-off-by: John Crispin <john@phrozen.org>
---
 include/net/mac80211.h     |  2 ++
 net/mac80211/he.c          | 14 ++++++++++++++
 net/mac80211/ieee80211_i.h |  5 +++++
 net/mac80211/mlme.c        |  1 +
 4 files changed, 22 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 112dc18c658f..ba4a16f87364 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1903,6 +1903,7 @@ struct ieee80211_sta_rates {
  * @ht_cap: HT capabilities of this STA; restricted to our own capabilities
  * @vht_cap: VHT capabilities of this STA; restricted to our own capabilities
  * @he_cap: HE capabilities of this STA
+ * @he_operation: HE operation information of the AP we are connected to
  * @max_rx_aggregation_subframes: maximal amount of frames in a single AMPDU
  *	that this station is allowed to transmit to us.
  *	Can be modified by driver.
@@ -1941,6 +1942,7 @@ struct ieee80211_sta {
 	struct ieee80211_sta_ht_cap ht_cap;
 	struct ieee80211_sta_vht_cap vht_cap;
 	struct ieee80211_sta_he_cap he_cap;
+	struct ieee80211_he_operation he_operation;
 	u16 max_rx_aggregation_subframes;
 	bool wme;
 	u8 uapsd_queues;
diff --git a/net/mac80211/he.c b/net/mac80211/he.c
index 769078ed5a12..62ef029e5c48 100644
--- a/net/mac80211/he.c
+++ b/net/mac80211/he.c
@@ -53,3 +53,17 @@ ieee80211_he_cap_ie_to_sta_he_cap(struct ieee80211_sub_if_data *sdata,
 
 	he_cap->has_he = true;
 }
+
+void
+ieee80211_he_op_ie_to_sta_he_op(struct ieee80211_sub_if_data *sdata,
+			const struct ieee80211_he_operation *he_op_ie_elem,
+			struct sta_info *sta)
+{
+	struct ieee80211_he_operation *he_operation = &sta->sta.he_operation;
+
+	if (!he_op_ie_elem) {
+		memset(he_operation, 0, sizeof(*he_operation));
+		return;
+	}
+	memcpy(he_operation, he_op_ie_elem, sizeof(*he_operation));
+}
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e170f986d226..11bc1778bfd5 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1870,6 +1870,11 @@ ieee80211_he_cap_ie_to_sta_he_cap(struct ieee80211_sub_if_data *sdata,
 				  const u8 *he_cap_ie, u8 he_cap_len,
 				  struct sta_info *sta);
 
+void
+ieee80211_he_op_ie_to_sta_he_op(struct ieee80211_sub_if_data *sdata,
+			const struct ieee80211_he_operation *he_op_ie_elem,
+			struct sta_info *sta);
+
 /* Spectrum management */
 void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
 				       struct ieee80211_mgmt *mgmt,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 2dbcf5d5512e..5d8a8a0feaf9 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3364,6 +3364,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 		if (elems.uora_element)
 			bss_conf->uora_ocw_range = elems.uora_element[0];
 
+		ieee80211_he_op_ie_to_sta_he_op(sdata, elems.he_operation, sta);
 		/* TODO: OPEN: what happens if BSS color disable is set? */
 	}
 
-- 
2.20.1

