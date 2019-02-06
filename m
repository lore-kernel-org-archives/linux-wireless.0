Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EF06C282CC
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 11:17:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB4412080D
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 11:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729821AbfBFLRc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 06:17:32 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:55692 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727501AbfBFLRb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 06:17:31 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1grLCr-0001ED-6v; Wed, 06 Feb 2019 13:17:29 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed,  6 Feb 2019 13:17:09 +0200
Message-Id: <20190206111721.29283-4-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190206111721.29283-1-luca@coelho.fi>
References: <20190206111721.29283-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 03/15] mac80211: support max channel switch time element
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

2018 REVmd of the spec introduces the max channel switch time
element which is optionally included in beacons/probes when there
is a channel switch / extended channel switch element.
The value represents the maximum delay between the time the AP
transmitted the last beacon in current channel and the expected
time of the first beacon in the new channel, in TU.

Parse the value and pass it to the driver.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/linux/ieee80211.h  | 1 +
 include/net/mac80211.h     | 4 ++++
 net/mac80211/ieee80211_i.h | 2 ++
 net/mac80211/mlme.c        | 1 +
 net/mac80211/spectmgmt.c   | 6 ++++++
 net/mac80211/util.c        | 4 ++++
 6 files changed, 18 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 3b04e72315e1..ab3bf6f08f67 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2475,6 +2475,7 @@ enum ieee80211_eid_ext {
 	WLAN_EID_EXT_HE_OPERATION = 36,
 	WLAN_EID_EXT_UORA = 37,
 	WLAN_EID_EXT_HE_MU_EDCA = 38,
+	WLAN_EID_EXT_MAX_CHANNEL_SWITCH_TIME = 52,
 };
 
 /* Action category code */
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index de866a7253c9..29e1350a30b6 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1504,6 +1504,9 @@ struct ieee80211_conf {
  *	scheduled channel switch, as indicated by the AP.
  * @chandef: the new channel to switch to
  * @count: the number of TBTT's until the channel switch event
+ * @delay: maximum delay between the time the AP transmitted the last beacon in
+  *	current channel and the expected time of the first beacon in the new
+  *	channel, expressed in TU.
  */
 struct ieee80211_channel_switch {
 	u64 timestamp;
@@ -1511,6 +1514,7 @@ struct ieee80211_channel_switch {
 	bool block_tx;
 	struct cfg80211_chan_def chandef;
 	u8 count;
+	u32 delay;
 };
 
 /**
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 056b16bce3b0..929964994937 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1447,6 +1447,7 @@ struct ieee80211_csa_ie {
 	u8 ttl;
 	u16 pre_value;
 	u16 reason_code;
+	u32 max_switch_time;
 };
 
 /* Parsed Information Elements */
@@ -1487,6 +1488,7 @@ struct ieee802_11_elems {
 	const struct ieee80211_channel_sw_ie *ch_switch_ie;
 	const struct ieee80211_ext_chansw_ie *ext_chansw_ie;
 	const struct ieee80211_wide_bw_chansw_ie *wide_bw_chansw_ie;
+	const u8 *max_channel_switch_time;
 	const u8 *country_elem;
 	const u8 *pwr_constr_elem;
 	const u8 *cisco_dtpc_elem;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 687821567287..1deb6bb62eb0 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1331,6 +1331,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	ch_switch.block_tx = csa_ie.mode;
 	ch_switch.chandef = csa_ie.chandef;
 	ch_switch.count = csa_ie.count;
+	ch_switch.delay = csa_ie.max_switch_time;
 
 	if (drv_pre_channel_switch(sdata, &ch_switch)) {
 		sdata_info(sdata,
diff --git a/net/mac80211/spectmgmt.c b/net/mac80211/spectmgmt.c
index 4e4902bdbef8..3c644f14dd59 100644
--- a/net/mac80211/spectmgmt.c
+++ b/net/mac80211/spectmgmt.c
@@ -177,6 +177,12 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 		csa_ie->chandef = new_vht_chandef;
 	}
 
+	if (elems->max_channel_switch_time)
+		csa_ie->max_switch_time =
+			(elems->max_channel_switch_time[0] << 0) |
+			(elems->max_channel_switch_time[1] <<  8) |
+			(elems->max_channel_switch_time[2] << 16);
+
 	return 0;
 }
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index d0eb38b890aa..314aacdf8c19 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1234,6 +1234,10 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 				elems->he_operation = (void *)&pos[1];
 			} else if (pos[0] == WLAN_EID_EXT_UORA && elen >= 1) {
 				elems->uora_element = (void *)&pos[1];
+			} else if (pos[0] ==
+				   WLAN_EID_EXT_MAX_CHANNEL_SWITCH_TIME &&
+				   elen == 4) {
+				elems->max_channel_switch_time = pos + 1;
 			}
 			break;
 		default:
-- 
2.20.1

