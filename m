Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:55085 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbYKXHog (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 02:44:36 -0500
Received: by nf-out-0910.google.com with SMTP id d3so971884nfc.21
        for <linux-wireless@vger.kernel.org>; Sun, 23 Nov 2008 23:44:34 -0800 (PST)
Message-ID: <eb3ff54b0811232344m77f979aaj79e9e965eefa325c@mail.gmail.com> (sfid-20081124_084439_912474_758F910E)
Date: Mon, 24 Nov 2008 09:44:34 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH 1/2] mac80211: enabling an AP that can't support fully PS clients (wireless-testing).
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net, j@w1.fi
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables mac80211 to support the PS challenged mode when
used in master mode.
A new attribute, NL80211_ATTR_WIPHY_AP_PS_CHALLENGED, was added to
nl80211_attrs; also a new member (ap_ps_challenged) was added to
struct wiphy; and nl80211_send_wiphy() was adjusted accordingly.

User space applications (like hostapd) should check the
NL80211_ATTR_WIPHY_AP_PS_CHALLENGED
attribute and  display a proper message, if it is set, to inform the
users.

Signed-off-by: Rami Rosen <ramirose@gmail.com>

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 7982734..dbe15e0 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -256,6 +256,9 @@ enum nl80211_commands {
  *	supported interface types, each a flag attribute with the number
  *	of the interface mode.
  *
+ * @NL80211_ATTR_WIPHY_AP_PS_CHALLENGED: indicates that the wiphy support
+ *  for PS is not full.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -316,6 +319,8 @@ enum nl80211_attrs {

 	NL80211_ATTR_WIPHY_TXQ_PARAMS,

+	NL80211_ATTR_WIPHY_AP_PS_CHALLENGED,
+
 	/* add attributes here, update the policy in nl80211.c */

 	__NL80211_ATTR_AFTER_LAST,
@@ -329,6 +334,7 @@ enum nl80211_attrs {
 #define NL80211_ATTR_HT_CAPABILITY NL80211_ATTR_HT_CAPABILITY
 #define NL80211_ATTR_BSS_BASIC_RATES NL80211_ATTR_BSS_BASIC_RATES
 #define NL80211_ATTR_WIPHY_TXQ_PARAMS NL80211_ATTR_WIPHY_TXQ_PARAMS
+#define NL80211_ATTR_WIPHY_AP_PS_CHALLENGED NL80211_ATTR_WIPHY_AP_PS_CHALLENGED

 #define NL80211_MAX_SUPP_RATES			32
 #define NL80211_MAX_SUPP_REG_RULES		32
diff --git a/include/net/wireless.h b/include/net/wireless.h
index aedefa5..c7ec68b 100644
--- a/include/net/wireless.h
+++ b/include/net/wireless.h
@@ -198,6 +198,8 @@ struct wiphy {
 	u16 interface_modes;

 	bool fw_handles_regulatory;
+	/* enable AP (master mode) when the AP is without proper power saving mode */
+	bool ap_ps_challenged;

 	/* If multiple wiphys are registered and you're handed e.g.
 	 * a regular netdev with assigned ieee80211_ptr, you won't
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 00121ce..73098fe 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -149,6 +149,8 @@ static int nl80211_send_wiphy(struct sk_buff *msg,
u32 pid, u32 seq, int flags,
 	}

 	nla_nest_end(msg, nl_modes);
+	if (dev->wiphy.ap_ps_challenged)
+	    NLA_PUT_FLAG(msg, NL80211_ATTR_WIPHY_AP_PS_CHALLENGED);

 	nl_bands = nla_nest_start(msg, NL80211_ATTR_WIPHY_BANDS);
 	if (!nl_bands)
