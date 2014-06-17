Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:36040 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932664AbaFQJQr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2014 05:16:47 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [RFC 2/3] cfg80211: expose cfg80211_disable_40mhz_24ghz module parameter
Date: Tue, 17 Jun 2014 11:16:20 +0200
Message-ID: <1402996581-10764-3-git-send-email-arend@broadcom.com> (sfid-20140617_111655_041250_FB4BE1FC)
In-Reply-To: <1402996581-10764-1-git-send-email-arend@broadcom.com>
References: <1402996581-10764-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers may need to know this variable value for configuring the
device they are controlling. It can be determined indirectly by
setting IEEE80211_HT_CAP_SUP_WIDTH_20_40 flag in the field
ieee80211_sta_htcap::cap of 2G band. During the wiphy_register()
call cfg80211 will clear that bit if the module parameter is true.
However, brcmfmac for one needs to know the value to determine
its custom regulatory domain which must be applied before doing
the wiphy_register().

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 include/net/cfg80211.h | 9 +++++++++
 net/wireless/core.c    | 6 ++++++
 2 files changed, 15 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e46c437..47a0310 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3172,6 +3172,15 @@ static inline const char *wiphy_name(const struct wiphy *wiphy)
 struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv);
 
 /**
+ * wiphy_is_40mhz_24ghz_disabled - check whether 40MHz bandwidth in 2.4G
+ *
+ * @wiphy: The wiphy to check.
+ *
+ * Return: true is 40MHz is disabled in 2.4G band.
+ */
+bool wiphy_is_40mhz_24ghz_disabled(struct wiphy *wiphy);
+
+/**
  * wiphy_register - register a wiphy with cfg80211
  *
  * @wiphy: The wiphy to register.
diff --git a/net/wireless/core.c b/net/wireless/core.c
index a1c4065..428f370 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -408,6 +408,12 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 }
 EXPORT_SYMBOL(wiphy_new);
 
+bool wiphy_is_40mhz_24ghz_disabled(struct wiphy *wiphy)
+{
+	return cfg80211_disable_40mhz_24ghz;
+}
+EXPORT_SYMBOL(wiphy_is_40mhz_24ghz_disabled);
+
 static int wiphy_verify_combinations(struct wiphy *wiphy)
 {
 	const struct ieee80211_iface_combination *c;
-- 
1.9.1

