Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:46070 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab3JMDbN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Oct 2013 23:31:13 -0400
Received: by mail-pb0-f53.google.com with SMTP id up15so5896700pbc.26
        for <linux-wireless@vger.kernel.org>; Sat, 12 Oct 2013 20:31:13 -0700 (PDT)
From: Mihir Shete <smihir@qti.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: Mihir Shete <smihir@qti.qualcomm.com>,
	Henri Bahini <hbahini@qca.qualcomm.com>,
	Tushnim Bhattacharyya <tushnimb@qca.qualcomm.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 2/2] cfg80211: add an option to disable processing country IEs
Date: Sun, 13 Oct 2013 09:00:46 +0530
Message-Id: <1381635046-15123-3-git-send-email-smihir@qti.qualcomm.com> (sfid-20131013_053118_671993_84CB4B14)
In-Reply-To: <1381635046-15123-1-git-send-email-smihir@qti.qualcomm.com>
References: <1381635046-15123-1-git-send-email-smihir@qti.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Certain vendors may want to disable the processing of
country IEs so that they can continue using the regulatory
domain the driver or user has set.  Currently there is no
way to stop the core from processing country IEs, so add
support to the core to ignore country IE hints.

Cc: Henri Bahini <hbahini@qca.qualcomm.com>
Cc: Tushnim Bhattacharyya <tushnimb@qca.qualcomm.com>
Cc: Luis R. Rodriguez <mcgrof@do-not-panic.com>
Signed-off-by: Mihir Shete <smihir@qti.qualcomm.com>
---
 include/uapi/linux/nl80211.h | 5 +++++
 net/wireless/reg.c           | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 977c487..2a6ba5c 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2343,10 +2343,15 @@ enum nl80211_reg_type {
  *	domain. The regulatory domain used will be based on the
  *	ISO3166-alpha2 from country IE provided through
  *	regulatory_hint_country_ie()
+ * @NL80211_COUNTRY_IE_IGNORE_CORE - for devices that have a preference to
+ *	to ignore all country IE information processed by the core. This will
+ *	override %NL80211_COUNTRY_IE_FOLLOW_POWER if the country IE hint is
+ *	issued by the core
  */
 enum nl80211_country_ie_pref {
 	NL80211_COUNTRY_IE_FOLLOW_CORE,
 	NL80211_COUNTRY_IE_FOLLOW_POWER = BIT(0),
+	NL80211_COUNTRY_IE_IGNORE_CORE = BIT(1),
 };
 
 /**
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 87b4ee3..699c4dc 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1322,6 +1322,9 @@ get_reg_request_treatment(struct wiphy *wiphy,
 	case NL80211_REGDOM_SET_BY_CORE:
 		return REG_REQ_OK;
 	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
+		if (wiphy->country_ie_pref & NL80211_COUNTRY_IE_IGNORE_CORE)
+			return REG_REQ_IGNORE;
+
 		if (reg_request_cell_base(lr)) {
 			/* Trust a Cell base station over the AP's country IE */
 			if (regdom_changes(pending_request->alpha2))
-- 
1.8.2.1

