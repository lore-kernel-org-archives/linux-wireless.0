Return-Path: <SRS0=s1k3=OY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D42EC43387
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:24:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCD4C206A2
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:24:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729465AbeLOJYr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 15 Dec 2018 04:24:47 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:42410 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728987AbeLOJYq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Dec 2018 04:24:46 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gY5rL-0002oc-9C; Sat, 15 Dec 2018 11:03:43 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sat, 15 Dec 2018 11:03:18 +0200
Message-Id: <20181215090325.31604-18-luca@coelho.fi>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181215090325.31604-1-luca@coelho.fi>
References: <20181215090325.31604-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 17/24] cfg80211: Include the PMK and PMKID in NL80211_CMD_EXTERNAL_AUTH
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

This is needed for the devices that manage PMKSA caching internally and
don't implement SET/DEL PMKSA commands.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/cfg80211.h       |  6 ++++++
 include/uapi/linux/nl80211.h |  4 +++-
 net/wireless/nl80211.c       | 12 ++++++++++++
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ede7fcd68348..30618afab657 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2813,6 +2813,9 @@ struct cfg80211_pmk_conf {
  *	use %WLAN_STATUS_UNSPECIFIED_FAILURE if user space cannot give you
  *	the real status code for failures. Used only for the authentication
  *	response command interface (user space to driver).
+ * @pmk_len: Length of PMK if present.
+ * @pmk: Derived PMK
+ * @pmkid: PMKID of the derived PMK
  */
 struct cfg80211_external_auth_params {
 	enum nl80211_external_auth_action action;
@@ -2820,6 +2823,9 @@ struct cfg80211_external_auth_params {
 	struct cfg80211_ssid ssid;
 	unsigned int key_mgmt_suite;
 	u16 status;
+	int pmk_len;
+	const u8 *pmk;
+	const u8 *pmkid;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 2b53c0e949c7..3843214ec7ee 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1022,7 +1022,9 @@
  *	further with the association after getting successful authentication
  *	status. User space indicates the authentication status through
  *	%NL80211_ATTR_STATUS_CODE attribute in %NL80211_CMD_EXTERNAL_AUTH
- *	command interface.
+ *	command interface. In case of success, user space also includes the
+ *	derived PMK and PMKID through %NL80211_ATTR_PMK and
+ *	%NL80211_ATTR_PMKID.
  *
  *	Host driver reports this status on an authentication failure to the
  *	user space through the connect result as the user space would have
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e20329b34840..323cd91cf1e4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -12990,6 +12990,12 @@ static int nl80211_external_auth(struct sk_buff *skb, struct genl_info *info)
 	if (!info->attrs[NL80211_ATTR_STATUS_CODE])
 		return -EINVAL;
 
+	if ((info->attrs[NL80211_ATTR_PMK] &&
+	     !info->attrs[NL80211_ATTR_PMKID]) ||
+	    (info->attrs[NL80211_ATTR_PMKID] &&
+	     !info->attrs[NL80211_ATTR_PMK]))
+		return -EINVAL;
+
 	memset(&params, 0, sizeof(params));
 
 	params.ssid.ssid_len = nla_len(info->attrs[NL80211_ATTR_SSID]);
@@ -13004,6 +13010,12 @@ static int nl80211_external_auth(struct sk_buff *skb, struct genl_info *info)
 
 	params.status = nla_get_u16(info->attrs[NL80211_ATTR_STATUS_CODE]);
 
+	if (info->attrs[NL80211_ATTR_PMK] && info->attrs[NL80211_ATTR_PMKID]) {
+		params.pmk_len = nla_len(info->attrs[NL80211_ATTR_PMK]);
+		params.pmk = nla_data(info->attrs[NL80211_ATTR_PMK]);
+		params.pmkid = nla_data(info->attrs[NL80211_ATTR_PMKID]);
+	}
+
 	return rdev_external_auth(rdev, dev, &params);
 }
 
-- 
2.19.2

