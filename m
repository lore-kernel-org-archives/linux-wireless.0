Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:62027 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab3KKVPo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 16:15:44 -0500
Received: by mail-we0-f171.google.com with SMTP id t61so1823315wes.30
        for <linux-wireless@vger.kernel.org>; Mon, 11 Nov 2013 13:15:42 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Mihir Shete <smihir@qti.qualcomm.com>,
	Henri Bahini <hbahini@qca.qualcomm.com>,
	Tushnim Bhattacharyya <tushnimb@qca.qualcomm.com>
Subject: [PATCH 3/3] cfg80211: add an option to disable processing country IEs
Date: Mon, 11 Nov 2013 22:15:31 +0100
Message-Id: <1384204531-10025-4-git-send-email-mcgrof@do-not-panic.com> (sfid-20131111_221556_201963_3A59D280)
In-Reply-To: <1384204531-10025-1-git-send-email-mcgrof@do-not-panic.com>
References: <1384204531-10025-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Certain vendors may want to disable the processing of
country IEs so that they can continue using the regulatory
domain the driver or user has set.  Currently there is no
way to stop the core from processing country IEs, so add
support to the core to ignore country IE hints.

Cc: Mihir Shete <smihir@qti.qualcomm.com>
Cc: Henri Bahini <hbahini@qca.qualcomm.com>
Cc: Tushnim Bhattacharyya <tushnimb@qca.qualcomm.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 include/net/regulatory.h | 5 +++++
 net/wireless/reg.c       | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/include/net/regulatory.h b/include/net/regulatory.h
index bc41203..7e98e5a 100644
--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -123,12 +123,17 @@ struct regulatory_request {
  *	derived from the regulatory domain. The regulatory domain used will be
  *	based on the ISO3166-alpha2 from country IE provided through
  *	regulatory_hint_country_ie()
+ * @REGULATORY_COUNTRY_IE_IGNORE: for devices that have a preference to ignore
+ * 	all country IE information processed by the regulatory core. This will
+ * 	override %REGULATORY_COUNTRY_IE_FOLLOW_POWER as all country IEs will
+ * 	be ignored.
  */
 enum ieee80211_regulatory_flags {
 	REGULATORY_CUSTOM_REG			= BIT(0),
 	REGULATORY_STRICT_REG			= BIT(1),
 	REGULATORY_DISABLE_BEACON_HINTS		= BIT(2),
 	REGULATORY_COUNTRY_IE_FOLLOW_POWER	= BIT(3),
+	REGULATORY_COUNTRY_IE_IGNORE		= BIT(4),
 };
 
 struct ieee80211_freq_range {
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 6b3051f..067c1f6 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1543,6 +1543,9 @@ __reg_process_hint_country_ie(struct wiphy *wiphy,
 		if (regdom_changes(country_ie_request->alpha2))
 			return REG_REQ_IGNORE;
 		return REG_REQ_ALREADY_SET;
+	} else {
+		if (wiphy->regulatory_flags & REGULATORY_COUNTRY_IE_IGNORE)
+			return REG_REQ_IGNORE;
 	}
 
 	if (unlikely(!is_an_alpha2(country_ie_request->alpha2)))
-- 
1.8.4.rc3

