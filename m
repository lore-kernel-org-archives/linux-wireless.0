Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39032 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab1JUIht (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 04:37:49 -0400
Received: by mail-yw0-f46.google.com with SMTP id 7so3652119ywf.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Oct 2011 01:37:48 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 21 Oct 2011 12:37:48 +0400
Message-ID: <CAG5dHkRx7qc3sSbfKOTcPSc0Jmo-0_zV6ri51CNbfp-gwELywQ@mail.gmail.com> (sfid-20111021_103752_225063_212AC973)
Subject: [RFC 7/7] cfg80211 and nl80211: setting and getting mesh non-peer
 power mode
From: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
---
 include/linux/nl80211.h |    3 +++
 net/mac80211/cfg.c      |    5 +++++
 net/wireless/nl80211.c  |    8 ++++++++
 3 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 4f4bfb8..78807f4 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -2015,6 +2015,8 @@ enum nl80211_mesh_power_mode {
  * access to a broader network beyond the MBSS.  This is done via Root
  * Announcement frames.
  *
+ * @NL80211_MESHCONF_POWER_MODE: mesh non-peer power mode
+ *
  * @NL80211_MESHCONF_ATTR_MAX: highest possible mesh configuration attribute
  *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
@@ -2038,6 +2040,7 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_ELEMENT_TTL,
 	NL80211_MESHCONF_HWMP_RANN_INTERVAL,
 	NL80211_MESHCONF_GATE_ANNOUNCEMENTS,
+	NL80211_MESHCONF_POWER_MODE,

 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 2b0cc2c..e841740 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1227,6 +1227,11 @@ static int ieee80211_update_mesh_config(struct
wiphy *wiphy,
 		conf->dot11MeshHWMPRannInterval =
 			nconf->dot11MeshHWMPRannInterval;
 	}
+	if (_chg_mesh_attr(NL80211_MESHCONF_POWER_MODE, mask)) {
+		conf->power_mode = nconf->power_mode;
+		ieee80211_bss_info_change_notify(sdata,
+						BSS_CHANGED_BEACON);
+	}
 	return 0;
 }

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c53c8bb..cfa8b0e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3144,6 +3144,8 @@ static int nl80211_get_mesh_config(struct sk_buff *skb,
 			cur_params.dot11MeshHWMPRannInterval);
 	NLA_PUT_U8(msg, NL80211_MESHCONF_GATE_ANNOUNCEMENTS,
 			cur_params.dot11MeshGateAnnouncementProtocol);
+	NLA_PUT_U8(msg, NL80211_MESHCONF_POWER_MODE,
+			cur_params.power_mode);
 	nla_nest_end(msg, pinfoattr);
 	genlmsg_end(msg, hdr);
 	return genlmsg_reply(msg, info);
@@ -3174,6 +3176,8 @@ static const struct nla_policy
nl80211_meshconf_params_policy[NL80211_MESHCONF_A
 	[NL80211_MESHCONF_HWMP_ROOTMODE] = { .type = NLA_U8 },
 	[NL80211_MESHCONF_HWMP_RANN_INTERVAL] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_GATE_ANNOUNCEMENTS] = { .type = NLA_U8 },
+
+	[NL80211_MESHCONF_POWER_MODE] = { .type = NLA_U8 },
 };

 static const struct nla_policy
@@ -3260,6 +3264,10 @@ do {\
 			dot11MeshGateAnnouncementProtocol, mask,
 			NL80211_MESHCONF_GATE_ANNOUNCEMENTS,
 			nla_get_u8);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg,
+			power_mode, mask,
+			NL80211_MESHCONF_POWER_MODE,
+			nla_get_u8);
 	if (mask_out)
 		*mask_out = mask;

-- 
1.7.3.4
