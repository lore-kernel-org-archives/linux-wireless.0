Return-Path: <SRS0=s1k3=OY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32211C43387
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E7D5206A2
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:13:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729465AbeLOJN5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 15 Dec 2018 04:13:57 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:42352 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726030AbeLOJN4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Dec 2018 04:13:56 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gY5rJ-0002oc-04; Sat, 15 Dec 2018 11:03:41 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sat, 15 Dec 2018 11:03:15 +0200
Message-Id: <20181215090325.31604-15-luca@coelho.fi>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181215090325.31604-1-luca@coelho.fi>
References: <20181215090325.31604-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 14/24] mac80211: update driver when MU EDCA params change
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shaul Triebitz <shaul.triebitz@intel.com>

Similar to WMM IE, if MU_EDCA IE parameters changed (or ceased to exist)
tell the Driver about it.

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/mlme.c        | 12 ++++++++++--
 net/mac80211/util.c        |  2 ++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 10a05062e4a0..7dfb4e2f98b2 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -500,6 +500,7 @@ struct ieee80211_if_managed {
 	unsigned int uapsd_max_sp_len;
 
 	int wmm_last_param_set;
+	int mu_edca_last_param_set;
 
 	u8 use_4addr;
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 3d1334a4a264..975315b5689a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1869,7 +1869,7 @@ ieee80211_sta_wmm_params(struct ieee80211_local *local,
 	struct ieee80211_tx_queue_params params[IEEE80211_NUM_ACS];
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	size_t left;
-	int count, ac;
+	int count, mu_edca_count, ac;
 	const u8 *pos;
 	u8 uapsd_queues = 0;
 
@@ -1889,9 +1889,16 @@ ieee80211_sta_wmm_params(struct ieee80211_local *local,
 		uapsd_queues = ifmgd->uapsd_queues;
 
 	count = wmm_param[6] & 0x0f;
-	if (count == ifmgd->wmm_last_param_set)
+	/* -1 is the initial value of ifmgd->mu_edca_last_param_set.
+	 * if mu_edca was preset before and now it disappeared tell
+	 * the driver about it.
+	 */
+	mu_edca_count = mu_edca ? mu_edca->mu_qos_info & 0x0f : -1;
+	if (count == ifmgd->wmm_last_param_set &&
+	    mu_edca_count == ifmgd->mu_edca_last_param_set)
 		return false;
 	ifmgd->wmm_last_param_set = count;
+	ifmgd->mu_edca_last_param_set = mu_edca_count;
 
 	pos = wmm_param + 8;
 	left = wmm_param_len - 8;
@@ -3349,6 +3356,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 	 * 4-bit value.
 	 */
 	ifmgd->wmm_last_param_set = -1;
+	ifmgd->mu_edca_last_param_set = -1;
 
 	if (ifmgd->flags & IEEE80211_STA_DISABLE_WMM) {
 		ieee80211_set_wmm_default(sdata, false, false);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index dddfff7cf44f..d0eb38b890aa 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1223,6 +1223,8 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 			if (pos[0] == WLAN_EID_EXT_HE_MU_EDCA &&
 			    elen >= (sizeof(*elems->mu_edca_param_set) + 1)) {
 				elems->mu_edca_param_set = (void *)&pos[1];
+				if (calc_crc)
+					crc = crc32_be(crc, pos - 2, elen + 2);
 			} else if (pos[0] == WLAN_EID_EXT_HE_CAPABILITY) {
 				elems->he_cap = (void *)&pos[1];
 				elems->he_cap_len = elen - 1;
-- 
2.19.2

