Return-Path: <SRS0=QcoQ=US=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4ED4C31E5E
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Jun 2019 05:30:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC87720823
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Jun 2019 05:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730783AbfFSFa2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Jun 2019 01:30:28 -0400
Received: from nbd.name ([46.4.11.11]:59098 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730283AbfFSFa1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Jun 2019 01:30:27 -0400
Received: from pd95fd3e4.dip0.t-ipconnect.de ([217.95.211.228] helo=bertha.fritz.box)
        by ds12 with esmtpa (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1hdTAv-000779-Hl; Wed, 19 Jun 2019 07:30:25 +0200
From:   John Crispin <john@phrozen.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, John Crispin <john@phrozen.org>,
        Shashidhar Lakkavalli <slakkavalli@datto.com>
Subject: [PATCH V2 1/2] mac80211: add support for parsing ADDBA_EXT IEs
Date:   Wed, 19 Jun 2019 07:30:19 +0200
Message-Id: <20190619053020.17121-2-john@phrozen.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190619053020.17121-1-john@phrozen.org>
References: <20190619053020.17121-1-john@phrozen.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

ADDBA_EXT IEs can be used to negotiate the BA fragmentation level.

Signed-off-by: Shashidhar Lakkavalli <slakkavalli@datto.com>
Signed-off-by: John Crispin <john@phrozen.org>
---
 include/linux/ieee80211.h  | 8 ++++++++
 net/mac80211/ieee80211_i.h | 1 +
 net/mac80211/util.c        | 7 +++++++
 3 files changed, 16 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 538d502902c0..cf6b69bcbc52 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -884,6 +884,14 @@ struct ieee80211_tpc_report_ie {
 	u8 link_margin;
 } __packed;
 
+#define IEEE80211_ADDBA_EXT_FRAG_LEVEL_MASK	GENMASK(2, 1)
+#define IEEE80211_ADDBA_EXT_FRAG_LEVEL_SHIFT	1
+#define IEEE80211_ADDBA_EXT_NO_FRAG		BIT(0)
+
+struct ieee80211_addba_ext_ie {
+	u8 data;
+} __packed;
+
 struct ieee80211_mgmt {
 	__le16 frame_control;
 	__le16 duration;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9e8474782a60..acbf5384ad15 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1512,6 +1512,7 @@ struct ieee802_11_elems {
 	u8 max_bssid_indicator;
 	u8 dtim_count;
 	u8 dtim_period;
+	const struct ieee80211_addba_ext_ie *addba_ext_ie;
 
 	/* length of them, respectively */
 	u8 ext_capab_len;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 34ce0ed67e59..ddef5d116431 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1203,6 +1203,13 @@ _ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 
 			elems->cisco_dtpc_elem = pos;
 			break;
+		case WLAN_EID_ADDBA_EXT:
+			if (elen != sizeof(struct ieee80211_addba_ext_ie)) {
+				elem_parse_failed = true;
+				break;
+			}
+			elems->addba_ext_ie = (void *)pos;
+			break;
 		case WLAN_EID_TIMEOUT_INTERVAL:
 			if (elen >= sizeof(struct ieee80211_timeout_interval_ie))
 				elems->timeout_int = (void *)pos;
-- 
2.20.1

