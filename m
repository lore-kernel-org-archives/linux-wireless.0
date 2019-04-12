Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32FEEC10F0E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 12:54:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02AB52084D
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 12:54:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbfDLMyP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 08:54:15 -0400
Received: from nbd.name ([46.4.11.11]:38528 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726714AbfDLMyP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 08:54:15 -0400
Received: from p548c87de.dip0.t-ipconnect.de ([84.140.135.222] helo=bertha.fritz.box)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1hEvh7-0000ki-Kt; Fri, 12 Apr 2019 14:54:13 +0200
From:   John Crispin <john@phrozen.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, John Crispin <john@phrozen.org>
Subject: [PATCH] nl80211: add iftype mask when sending iftype_data
Date:   Fri, 12 Apr 2019 14:54:05 +0200
Message-Id: <20190412125405.17963-1-john@phrozen.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add the iftype mask to the blob passed to userland. This allows hostapd to
find the entry applicable for constructing the HE beacons of an AP.

Signed-off-by: John Crispin <john@phrozen.org>
---
 include/uapi/linux/nl80211.h | 3 +++
 net/wireless/nl80211.c       | 4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 84fa62bc2c7d..da6fb7624a11 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3330,6 +3330,8 @@ enum nl80211_mpath_info {
  *     capabilities IE
  * @NL80211_BAND_IFTYPE_ATTR_HE_CAP_PPE: HE PPE thresholds information as
  *     defined in HE capabilities IE
+ * @NL80211_BAND_IFTYPE_ATTR_TYPE_MASK: The IFTYPEs that this element is
+ *     applicable for
  * @NL80211_BAND_IFTYPE_ATTR_MAX: highest band HE capability attribute currently
  *     defined
  * @__NL80211_BAND_IFTYPE_ATTR_AFTER_LAST: internal use
@@ -3342,6 +3344,7 @@ enum nl80211_band_iftype_attr {
 	NL80211_BAND_IFTYPE_ATTR_HE_CAP_PHY,
 	NL80211_BAND_IFTYPE_ATTR_HE_CAP_MCS_SET,
 	NL80211_BAND_IFTYPE_ATTR_HE_CAP_PPE,
+	NL80211_BAND_IFTYPE_ATTR_TYPE_MASK,
 
 	/* keep last */
 	__NL80211_BAND_IFTYPE_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 25a9e3b5c154..87d1127e8cc1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1421,7 +1421,9 @@ nl80211_send_iftype_data(struct sk_buff *msg,
 			    sizeof(he_cap->he_mcs_nss_supp),
 			    &he_cap->he_mcs_nss_supp) ||
 		    nla_put(msg, NL80211_BAND_IFTYPE_ATTR_HE_CAP_PPE,
-			    sizeof(he_cap->ppe_thres), he_cap->ppe_thres))
+			    sizeof(he_cap->ppe_thres), he_cap->ppe_thres) ||
+		    nla_put_u16(msg, NL80211_BAND_IFTYPE_ATTR_TYPE_MASK,
+				iftdata->types_mask))
 			return -ENOBUFS;
 	}
 
-- 
2.11.0

