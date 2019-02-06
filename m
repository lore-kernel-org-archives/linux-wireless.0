Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68CF7C169C4
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 08:02:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 379592175B
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 08:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727732AbfBFICq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 03:02:46 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:55614 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726456AbfBFICq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 03:02:46 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1grIAM-000192-FH; Wed, 06 Feb 2019 10:02:43 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed,  6 Feb 2019 10:02:34 +0200
Message-Id: <20190206080234.15750-1-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <ffc4c9e611784b1367e187d092b846381a4cfdc0.camel@sipsolutions.net>
References: <ffc4c9e611784b1367e187d092b846381a4cfdc0.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH v2] cfg80211: Include the PMK and PMKID in NL80211_CMD_EXTERNAL_AUTH
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

This is needed for the devices that rely on user space to perform the
authentication, but offload the 4-way handshake and PMKSA caching.
Such devices don't implement SET/DEL_PMKSA commands, however they
still need to know the derived PMK and PMKID in order to proceed to
association and 4-way handshake phase.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/cfg80211.h       |  4 ++++
 include/uapi/linux/nl80211.h |  4 +++-
 net/wireless/nl80211.c       | 13 ++++++++++++-
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7f2739a90bdb..5566a95b27d8 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2846,6 +2846,8 @@ struct cfg80211_pmk_conf {
  *	the real status code for failures. Used only for the authentication
  *	response command interface (user space to driver).
  * @pmkid: The identifier to refer a PMKSA.
+ * @pmk_len: Length of PMK if present.
+ * @pmk: Derived PMK
  */
 struct cfg80211_external_auth_params {
 	enum nl80211_external_auth_action action;
@@ -2854,6 +2856,8 @@ struct cfg80211_external_auth_params {
 	unsigned int key_mgmt_suite;
 	u16 status;
 	const u8 *pmkid;
+	int pmk_len;
+	const u8 *pmk;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index dd4f86ee286e..10315b181ec4 100644
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
index a3cc039b9f55..ce5d87d512e2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -13098,6 +13098,12 @@ static int nl80211_external_auth(struct sk_buff *skb, struct genl_info *info)
 	if (!info->attrs[NL80211_ATTR_STATUS_CODE])
 		return -EINVAL;
 
+	if ((info->attrs[NL80211_ATTR_PMK] &&
+	     !info->attrs[NL80211_ATTR_PMKID]) ||
+	    (info->attrs[NL80211_ATTR_PMKID] &&
+	     !info->attrs[NL80211_ATTR_PMK]))
+		return -EINVAL;
+
 	memset(&params, 0, sizeof(params));
 
 	if (info->attrs[NL80211_ATTR_SSID]) {
@@ -13115,8 +13121,13 @@ static int nl80211_external_auth(struct sk_buff *skb, struct genl_info *info)
 
 	params.status = nla_get_u16(info->attrs[NL80211_ATTR_STATUS_CODE]);
 
-	if (info->attrs[NL80211_ATTR_PMKID])
+	if (info->attrs[NL80211_ATTR_PMKID]) {
+		if (info->attrs[NL80211_ATTR_PMK]) {
+			params.pmk_len = nla_len(info->attrs[NL80211_ATTR_PMK]);
+			params.pmk = nla_data(info->attrs[NL80211_ATTR_PMK]);
+		}
 		params.pmkid = nla_data(info->attrs[NL80211_ATTR_PMKID]);
+	}
 
 	return rdev_external_auth(rdev, dev, &params);
 }
-- 
2.20.1

