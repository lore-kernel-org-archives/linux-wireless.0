Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0E09C48BDF
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jun 2021 10:54:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B03F861003
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jun 2021 10:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbhFRK47 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Jun 2021 06:56:59 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:48244 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232317AbhFRK47 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Jun 2021 06:56:59 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=kveik.lan)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <luca@coelho.fi>)
        id 1luBx9-001YXx-2C; Fri, 18 Jun 2021 13:42:24 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     luca@coelho.fi, linux-wireless@vger.kernel.org
Date:   Fri, 18 Jun 2021 13:41:52 +0300
Message-Id: <iwlwifi.20210618133832.e8c4f0347276.Iee5964682b3e9ec51fc1cd57a7c62383eaf6ddd7@changeid>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210618104156.747775-1-luca@coelho.fi>
References: <20210618104156.747775-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 27/31] cfg80211: allow advertising vendor-specific capabilities
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

There may be cases where vendor-specific elements need to be
used over the air. Rather than have driver or firmware add
them and possibly cause problems that way, add them to the
iftype-data band capabilities. This way we can advertise to
userspace first, and use them in mac80211 next.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/cfg80211.h       | 7 +++++++
 include/uapi/linux/nl80211.h | 3 +++
 net/wireless/nl80211.c       | 5 +++++
 3 files changed, 15 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 6c851fa312ac..f8c24da15d29 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -370,11 +370,18 @@ struct ieee80211_sta_he_cap {
  * @he_cap: holds the HE capabilities
  * @he_6ghz_capa: HE 6 GHz capabilities, must be filled in for a
  *	6 GHz band channel (and 0 may be valid value).
+ * @vendor_elems: vendor element(s) to advertise
+ * @vendor_elems.data: vendor element(s) data
+ * @vendor_elems.len: vendor element(s) length
  */
 struct ieee80211_sband_iftype_data {
 	u16 types_mask;
 	struct ieee80211_sta_he_cap he_cap;
 	struct ieee80211_he_6ghz_capa he_6ghz_capa;
+	struct {
+		const u8 *data;
+		unsigned int len;
+	} vendor_elems;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 771f238ccff1..db474994fa73 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3654,6 +3654,8 @@ enum nl80211_mpath_info {
  *     defined
  * @NL80211_BAND_IFTYPE_ATTR_HE_6GHZ_CAPA: HE 6GHz band capabilities (__le16),
  *	given for all 6 GHz band channels
+ * @NL80211_BAND_IFTYPE_ATTR_VENDOR_ELEMS: vendor element capabilities that are
+ *	advertised on this band/for this iftype (binary)
  * @__NL80211_BAND_IFTYPE_ATTR_AFTER_LAST: internal use
  */
 enum nl80211_band_iftype_attr {
@@ -3665,6 +3667,7 @@ enum nl80211_band_iftype_attr {
 	NL80211_BAND_IFTYPE_ATTR_HE_CAP_MCS_SET,
 	NL80211_BAND_IFTYPE_ATTR_HE_CAP_PPE,
 	NL80211_BAND_IFTYPE_ATTR_HE_6GHZ_CAPA,
+	NL80211_BAND_IFTYPE_ATTR_VENDOR_ELEMS,
 
 	/* keep last */
 	__NL80211_BAND_IFTYPE_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fc9286afe3c9..23c59d43a8dd 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1731,6 +1731,11 @@ nl80211_send_iftype_data(struct sk_buff *msg,
 		    &iftdata->he_6ghz_capa))
 		return -ENOBUFS;
 
+	if (iftdata->vendor_elems.data && iftdata->vendor_elems.len &&
+	    nla_put(msg, NL80211_BAND_IFTYPE_ATTR_VENDOR_ELEMS,
+		    iftdata->vendor_elems.len, iftdata->vendor_elems.data))
+		return -ENOBUFS;
+
 	return 0;
 }
 
-- 
2.32.0

