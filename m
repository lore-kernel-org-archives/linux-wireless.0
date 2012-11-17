Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:48649 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab2KQGsi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2012 01:48:38 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net, javier@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	Mike Krinkin <krinkin.m.u@gmail.com>
Subject: [RFC 03/14] {cfg,nl}80211: set and get default mesh power mode
Date: Fri, 16 Nov 2012 22:47:55 -0800
Message-Id: <1353134886-13256-4-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121117_074842_442341_5B677543)
In-Reply-To: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Possibilities of setting and getting mesh default power mode are
added.

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Signed-off-by: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
Signed-off-by: Mike Krinkin <krinkin.m.u@gmail.com>
---
 include/uapi/linux/nl80211.h |    3 +++
 net/mac80211/cfg.c           |    2 ++
 net/wireless/nl80211.c       |    8 +++++++-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index ee80ffc..a6b2886 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2329,6 +2329,8 @@ enum nl80211_mesh_power_mode {
  *
  * @NL80211_MESHCONF_DTIM_PERIOD: DTIM period to use
  *
+ * @NL80211_MESHCONF_POWER_MODE: default link-specific power save mode
+ *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
  */
 enum nl80211_meshconf_params {
@@ -2360,6 +2362,7 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL,
 	NL80211_MESHCONF_BEACON_INTERVAL,
 	NL80211_MESHCONF_DTIM_PERIOD,
+	NL80211_MESHCONF_POWER_MODE,
 
 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index aef8445..84d63fc 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1678,6 +1678,8 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 		sdata->vif.bss_conf.dtim_period = nconf->dtim_period;
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
 	}
+	if (_chg_mesh_attr(NL80211_MESHCONF_POWER_MODE, mask))
+		conf->power_mode = nconf->power_mode;
 	return 0;
 }
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 636634d..0312d74 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3774,7 +3774,9 @@ static int nl80211_get_mesh_config(struct sk_buff *skb,
 	    nla_put_u16(msg, NL80211_MESHCONF_BEACON_INTERVAL,
 			cur_params.beacon_interval) ||
 	    nla_put_u8(msg, NL80211_MESHCONF_DTIM_PERIOD,
-		       cur_params.dtim_period))
+		       cur_params.dtim_period) ||
+	    nla_put_u8(msg, NL80211_MESHCONF_POWER_MODE,
+		       cur_params.power_mode))
 		goto nla_put_failure;
 	nla_nest_end(msg, pinfoattr);
 	genlmsg_end(msg, hdr);
@@ -3815,6 +3817,7 @@ static const struct nla_policy nl80211_meshconf_params_policy[NL80211_MESHCONF_A
 	[NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_BEACON_INTERVAL] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_DTIM_PERIOD] = { .type = NLA_U8 },
+	[NL80211_MESHCONF_POWER_MODE] = { .type = NLA_U8 },
 };
 
 static const struct nla_policy
@@ -3939,6 +3942,9 @@ do {\
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dtim_period,
 				  mask, NL80211_MESHCONF_DTIM_PERIOD,
 				  nla_get_u8);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, power_mode,
+				  mask, NL80211_MESHCONF_POWER_MODE,
+				  nla_get_u8);
 	if (mask_out)
 		*mask_out = mask;
 
-- 
1.7.9.5

