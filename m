Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42970 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab1JLBCt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 21:02:49 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt4so235648bkb.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 18:02:48 -0700 (PDT)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Wed, 12 Oct 2011 03:02:46 +0200
To: "linux-wireless.vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "Bartosz MARKOWSKI" <bartosz.markowski@tieto.com>,
	"Janusz DZIEDZIC" <janusz.dziedzic@tieto.com>
Subject: [RFC 04/07] compat-wireless: p2p power save support
MIME-Version: 1.0
From: "Dmitry Tarnyagin" <abi.dmitryt@gmail.com>
Message-ID: <op.v27ruwj6ya27un@edmitar> (sfid-20111012_030253_319878_2BE5AA16)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Date: Thu, 4 Aug 2011 11:42:16 +0200

P2P power save support:
  - Opportunistic Power Save
  - Notice Of Absence

Signed-off-by: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
---
  include/linux/nl80211.h    |   12 +++++
  include/net/cfg80211.h     |   34 +++++++++++++
  include/net/mac80211.h     |    3 +
  net/mac80211/cfg.c         |   24 +++++++++
  net/mac80211/ieee80211_i.h |    3 +
  net/mac80211/mlme.c        |  114  
++++++++++++++++++++++++++++++++++++++++++
  net/wireless/nl80211.c     |  119  
++++++++++++++++++++++++++++++++++++++++++++
  net/wireless/util.c        |    9 +++
  8 files changed, 318 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 44911f6..a9bee60 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -638,6 +638,10 @@ enum nl80211_commands {
  	NL80211_CMD_TDLS_OPER,
  	NL80211_CMD_TDLS_MGMT,

+	NL80211_CMD_GET_NOA,
+	NL80211_CMD_SET_NOA,
+	NL80211_CMD_SET_P2P_POWER_SAVE,
+
  	/* add new commands above here */

  	/* used to define NL80211_CMD_MAX below */
@@ -1337,6 +1341,14 @@ enum nl80211_attrs {
  	NL80211_ATTR_TDLS_SUPPORT,
  	NL80211_ATTR_TDLS_EXTERNAL_SETUP,

+	NL80211_ATTR_P2P_PS_NOA,
+	NL80211_ATTR_P2P_PS_NOA_COUNT,
+	NL80211_ATTR_P2P_PS_NOA_START,
+	NL80211_ATTR_P2P_PS_NOA_DURATION,
+	NL80211_ATTR_P2P_PS_NOA_INTERVAL,
+	NL80211_ATTR_P2P_PS_LEGACY_PS,
+	NL80211_ATTR_P2P_PS_OPP_PS,
+	NL80211_ATTR_P2P_PS_CTWINDOW,
  	/* add attributes here, update the policy in nl80211.c */

  	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d2a9c21..c08e475 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1253,6 +1253,33 @@ struct cfg80211_gtk_rekey_data {
  	u8 replay_ctr[NL80211_REPLAY_CTR_LEN];
  };

+/*
+ * struct cfg80211_p2p_ps - p2p power save params
+ *
+ * This structure ...
+ *
+ * @legacy_ps: 0=disable, 1=enable, 2=maximum_ps, -1=no change
+ * @opp_ps: 0=disable, 1=enable, -1=no change
+ * @ctwidnow: 0... - change in ms, -1=no change
+ * @count: 0..255 - count
+ * @start: Start time in ms from next TBTT
+ * @duration: Duration in ms
+ * @interval: interval in ms
+ */
+struct cfg80211_p2p_ps {
+	int	legacy_ps;
+
+	/* Opportunistic Power Save */
+	int	opp_ps;
+	int	ctwindow;
+
+	/* Notice of Absence */
+	u8	count;
+	int	start;
+	int	duration;
+	int	interval;
+};
+
  /**
   * struct cfg80211_ops - backend description for wireless configuration
   *
@@ -1625,6 +1652,9 @@ struct cfg80211_ops {
  			     u16 status_code, const u8 *buf, size_t len);
  	int	(*tdls_oper)(struct wiphy *wiphy, struct net_device *dev,
  			     u8 *peer, enum nl80211_tdls_operation oper);
+	int	(*set_p2p_power_mgmt)(struct wiphy *wiphy,
+				      struct net_device *dev,
+				      struct cfg80211_p2p_ps *ps);
  };

  /*
@@ -2188,6 +2218,8 @@ struct wireless_dev {
  	bool ps;
  	int ps_timeout;

+	struct cfg80211_p2p_ps	p2p_ps;
+
  	int beacon_interval;

  #ifdef CONFIG_CFG80211_WEXT
@@ -2376,6 +2408,7 @@ struct ieee802_11_elems {
  	u8 *ext_supp_rates;
  	u8 *wmm_info;
  	u8 *wmm_param;
+	u8 *p2p_ie;
  	struct ieee80211_ht_cap *ht_cap_elem;
  	struct ieee80211_ht_info *ht_info_elem;
  	struct ieee80211_meshconf_ie *mesh_config;
@@ -2406,6 +2439,7 @@ struct ieee802_11_elems {
  	u8 ext_supp_rates_len;
  	u8 wmm_info_len;
  	u8 wmm_param_len;
+	u8 p2p_ie_len;
  	u8 mesh_id_len;
  	u8 peering_len;
  	u8 preq_len;
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 604464e..7a02a57 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -760,6 +760,7 @@ enum ieee80211_conf_changed {
  	IEEE80211_CONF_CHANGE_CHANNEL		= BIT(6),
  	IEEE80211_CONF_CHANGE_RETRY_LIMITS	= BIT(7),
  	IEEE80211_CONF_CHANGE_IDLE		= BIT(8),
+	IEEE80211_CONF_CHANGE_P2P_PS		= BIT(9),
  };

  /**
@@ -830,6 +831,7 @@ struct ieee80211_conf {
  	struct ieee80211_channel *channel;
  	enum nl80211_channel_type channel_type;
  	enum ieee80211_smps_mode smps_mode;
+	struct cfg80211_p2p_ps p2p_ps;
  };

  /**
@@ -1165,6 +1167,7 @@ enum ieee80211_hw_flags {
  	IEEE80211_HW_TX_AMPDU_SETUP_IN_HW		= 1<<23,
  	IEEE80211_HW_SUPPORTS_CQM_BEACON_MISS		= 1<<24,
  	IEEE80211_HW_SUPPORTS_CQM_TX_FAIL		= 1<<25,
+	IEEE80211_HW_SUPPORTS_P2P_PS			= 1<<26,
  };

  /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index da96781..1f8541c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1722,6 +1722,29 @@ static int ieee80211_set_power_mgmt(struct wiphy  
*wiphy, struct net_device *dev,
  	return 0;
  }

+static int ieee80211_set_p2p_power_mgmt(struct wiphy *wiphy,
+					struct net_device *dev,
+					struct cfg80211_p2p_ps *p2p_ps)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_conf *conf = &local->hw.conf;
+
+	if (!(sdata->vif.type == NL80211_IFTYPE_P2P_CLIENT ||
+	    sdata->vif.type == NL80211_IFTYPE_P2P_GO ||
+	    sdata->vif.type == NL80211_IFTYPE_STATION ||
+	    sdata->vif.type == NL80211_IFTYPE_AP))
+		return -EOPNOTSUPP;
+
+	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_P2P_PS))
+		return -EOPNOTSUPP;
+
+	conf->p2p_ps = *p2p_ps;
+	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_P2P_PS);
+
+	return 0;
+}
+
  static int ieee80211_set_cqm_rssi_config(struct wiphy *wiphy,
  					 struct net_device *dev,
  					 s32 rssi_thold, u32 rssi_hyst)
@@ -2589,4 +2612,5 @@ struct cfg80211_ops mac80211_config_ops = {
  	.set_rekey_data = ieee80211_set_rekey_data,
  	.tdls_oper = ieee80211_tdls_oper,
  	.tdls_mgmt = ieee80211_tdls_mgmt,
+	.set_p2p_power_mgmt = ieee80211_set_p2p_power_mgmt,
  };
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 1eaa7b3..453bdb8 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -409,6 +409,9 @@ struct ieee80211_if_managed {

  	int wmm_last_param_set;

+	char	p2p_last_ie[255];
+	u8	p2p_last_ie_len;
+
  	u8 use_4addr;

  	/* Signal strength from the last Beacon frame in the current BSS. */
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c3e2d3c..8c13619 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -851,6 +851,117 @@ void ieee80211_dynamic_ps_timer(unsigned long data)
  	ieee80211_queue_work(&local->hw, &local->dynamic_ps_enable_work);
  }

+#define MAX_P2P_NOA_DESC 4
+/* TODO: check if not defined already */
+struct noa_desc {
+	u8	count;
+	__le32	duration;
+	__le32	interval;
+	__le32	start;
+} __packed;
+
+struct noa_attr {
+	u8	index;
+	u8	oppPsCTWindow;
+	struct noa_desc dsc[MAX_P2P_NOA_DESC];
+} __packed;
+
+struct p2p_attr {
+	u8	type;
+	__le16	len;
+	u8	data[0];
+} __packed;
+
+static void ieee80211_sta_p2p_noa_check(struct ieee80211_local *local,
+					struct ieee80211_sub_if_data *sdata,
+					u8 *p2p_ie, size_t p2p_ie_len)
+{
+	struct ieee80211_conf *conf = &local->hw.conf;
+	struct cfg80211_p2p_ps p2p_ps = {0};
+	struct p2p_attr *attr;
+	struct noa_attr *noa_attr = NULL;
+	u8 *ptr, idx;
+	u16 len = 0, noa_len = 0;
+	int i;
+
+	if (!p2p_ie)
+		goto out;
+
+	/* Find Noa attr */
+	ptr = p2p_ie + 4;
+	for (i = 0; i < p2p_ie_len; i++) {
+		attr = (struct p2p_attr *) &ptr[i];
+		len = __le32_to_cpu(attr->len);
+
+		switch (attr->type) {
+		case 0x0C:
+			noa_attr = (struct noa_attr *) &attr->data[0];
+			noa_len = len;
+			break;
+		default:
+			break;
+		}
+		if (noa_attr)
+			break;
+		i = i + len + 2;
+	}
+
+	if (!noa_attr)
+		goto out;
+
+	/* Get NOA settings */
+	idx = noa_attr->index;
+	p2p_ps.opp_ps = !!(noa_attr->oppPsCTWindow & BIT(7));
+	p2p_ps.ctwindow = (noa_attr->oppPsCTWindow & (~BIT(7)));
+
+	if (idx > 0 &&
+	    noa_len >= (idx*sizeof(struct noa_desc) + 2)) {
+		p2p_ps.count = noa_attr->dsc[idx-1].count;
+		p2p_ps.start = __le32_to_cpu(noa_attr->dsc[idx-1].start);
+		p2p_ps.duration = __le32_to_cpu(noa_attr->dsc[idx-1].duration);
+		p2p_ps.interval = __le32_to_cpu(noa_attr->dsc[idx-1].interval);
+	}
+
+out:
+	/* Notify driver if change is required */
+	if (memcmp(&conf->p2p_ps, &p2p_ps, sizeof(p2p_ps))) {
+		conf->p2p_ps = p2p_ps;
+		if (local->hw.flags & IEEE80211_HW_SUPPORTS_P2P_PS)
+			ieee80211_hw_config(local,
+					IEEE80211_CONF_CHANGE_P2P_PS);
+	}
+}
+
+
+/* P2P */
+static void ieee80211_sta_p2p_params(struct ieee80211_local *local,
+				     struct ieee80211_sub_if_data *sdata,
+				     u8 *p2p_ie, size_t p2p_ie_len)
+{
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+
+	if (!p2p_ie) {
+		if (ifmgd->p2p_last_ie_len) {
+			memset(ifmgd->p2p_last_ie, 0x00,
+			       sizeof(ifmgd->p2p_last_ie));
+			ifmgd->p2p_last_ie_len = 0;
+			ieee80211_sta_p2p_noa_check(local, sdata, p2p_ie,
+						    p2p_ie_len);
+			return;
+		}
+	}
+
+	if (p2p_ie_len != ifmgd->p2p_last_ie_len ||
+	    memcmp(p2p_ie, ifmgd->p2p_last_ie, p2p_ie_len)) {
+		/* BSS_CHANGED_P2P_PS */
+		ieee80211_sta_p2p_noa_check(local, sdata, p2p_ie,
+					    p2p_ie_len);
+	}
+
+	memcpy(ifmgd->p2p_last_ie, p2p_ie, p2p_ie_len);
+	ifmgd->p2p_last_ie_len = p2p_ie_len;
+}
+
  /* MLME */
  static void ieee80211_sta_wmm_params(struct ieee80211_local *local,
  				     struct ieee80211_sub_if_data *sdata,
@@ -1884,6 +1995,9 @@ static void ieee80211_rx_mgmt_beacon(struct  
ieee80211_sub_if_data *sdata,

  		ieee80211_sta_wmm_params(local, sdata, elems.wmm_param,
  					 elems.wmm_param_len);
+
+		ieee80211_sta_p2p_params(local, sdata, elems.p2p_ie,
+					 elems.p2p_ie_len);
  	}

  	if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8af66b2..683f56e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -197,6 +197,15 @@ static const struct nla_policy  
nl80211_policy[NL80211_ATTR_MAX+1] = {
  	[NL80211_ATTR_TDLS_OPERATION] = { .type = NLA_U8 },
  	[NL80211_ATTR_TDLS_SUPPORT] = { .type = NLA_FLAG },
  	[NL80211_ATTR_TDLS_EXTERNAL_SETUP] = { .type = NLA_FLAG },
+	[NL80211_ATTR_P2P_PS_NOA] = { .type = NLA_BINARY,
+				      .len = 32 },
+	[NL80211_ATTR_P2P_PS_NOA_COUNT] = { .type = NLA_U8 },
+	[NL80211_ATTR_P2P_PS_NOA_START] = { .type = NLA_U32},
+	[NL80211_ATTR_P2P_PS_NOA_DURATION] = { .type = NLA_U32 },
+	[NL80211_ATTR_P2P_PS_NOA_INTERVAL] = { .type = NLA_U32 },
+	[NL80211_ATTR_P2P_PS_LEGACY_PS] = { .type = NLA_U32 },
+	[NL80211_ATTR_P2P_PS_OPP_PS] = { .type = NLA_U32 },
+	[NL80211_ATTR_P2P_PS_CTWINDOW] = { .type = NLA_U32 },
  };

  /* policy for the key attributes */
@@ -5888,6 +5897,92 @@ static int nl80211_set_rekey_data(struct sk_buff  
*skb, struct genl_info *info)
  	return err;
  }

+static int nl80211_get_noa(struct sk_buff *skb, struct genl_info *info)
+{
+	/* TODO: implementation needed. Currently wpa_supplicant don't
+	 * support this. */
+	return -1;
+}
+
+static int nl80211_set_noa(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_p2p_ps p2p_ps;
+	int ret = 0;
+
+	if (!rdev->ops->set_p2p_power_mgmt)
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_P2P_PS_NOA_COUNT] ||
+	    !info->attrs[NL80211_ATTR_P2P_PS_NOA_START] ||
+	    !info->attrs[NL80211_ATTR_P2P_PS_NOA_DURATION] ||
+	    !info->attrs[NL80211_ATTR_P2P_PS_NOA_INTERVAL])
+		return -EINVAL;
+
+	p2p_ps = wdev->p2p_ps;
+	p2p_ps.count = nla_get_u8(info->attrs[NL80211_ATTR_P2P_PS_NOA_COUNT]);
+	p2p_ps.start = nla_get_u32(info->attrs[NL80211_ATTR_P2P_PS_NOA_START]);
+	p2p_ps.duration = nla_get_u32(
+				info->attrs[NL80211_ATTR_P2P_PS_NOA_DURATION]);
+	p2p_ps.interval = nla_get_u32(
+				info->attrs[NL80211_ATTR_P2P_PS_NOA_INTERVAL]);
+	p2p_ps.legacy_ps = -1;
+	p2p_ps.opp_ps = -1;
+	p2p_ps.ctwindow = -1;
+
+
+	ret = rdev->ops->set_p2p_power_mgmt(wdev->wiphy, dev, &p2p_ps);
+
+	wdev->p2p_ps.count = p2p_ps.count;
+	wdev->p2p_ps.start = p2p_ps.start;
+	wdev->p2p_ps.duration = p2p_ps.duration;
+	wdev->p2p_ps.interval = p2p_ps.interval;
+
+	return ret;
+}
+
+static int nl80211_set_p2p_power_save(struct sk_buff *skb,
+				      struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	int ret = 0;
+
+	struct cfg80211_p2p_ps p2p_ps = {0};
+	int legacy_ps, opp_ps, ctwindow;
+
+	if (!rdev->ops->set_p2p_power_mgmt)
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_P2P_PS_LEGACY_PS] ||
+	    !info->attrs[NL80211_ATTR_P2P_PS_OPP_PS] ||
+	    !info->attrs[NL80211_ATTR_P2P_PS_CTWINDOW])
+		return -EINVAL;
+
+	p2p_ps = wdev->p2p_ps;
+
+	p2p_ps.legacy_ps = nla_get_u32(
+				info->attrs[NL80211_ATTR_P2P_PS_LEGACY_PS]);
+	p2p_ps.opp_ps = nla_get_u32(info->attrs[NL80211_ATTR_P2P_PS_OPP_PS]);
+	p2p_ps.ctwindow = nla_get_u32(
+				info->attrs[NL80211_ATTR_P2P_PS_CTWINDOW]);
+
+
+	ret = rdev->ops->set_p2p_power_mgmt(wdev->wiphy, dev, &p2p_ps);
+
+	if (p2p_ps.legacy_ps != -1)
+		wdev->p2p_ps.legacy_ps = p2p_ps.legacy_ps;
+	if (p2p_ps.opp_ps != -1)
+		wdev->p2p_ps.opp_ps = p2p_ps.opp_ps;
+	if (p2p_ps.ctwindow != -1)
+		wdev->p2p_ps.ctwindow = p2p_ps.ctwindow;
+
+	return ret;
+}
+
  #define NL80211_FLAG_NEED_WIPHY		0x01
  #define NL80211_FLAG_NEED_NETDEV	0x02
  #define NL80211_FLAG_NEED_RTNL		0x04
@@ -6443,6 +6538,30 @@ static struct genl_ops nl80211_ops[] = {
  		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
  				  NL80211_FLAG_NEED_RTNL,
  	},
+	{
+		.cmd = NL80211_CMD_GET_NOA,
+		.doit = nl80211_get_noa,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
+		.cmd = NL80211_CMD_SET_NOA,
+		.doit = nl80211_set_noa,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
+		.cmd = NL80211_CMD_SET_P2P_POWER_SAVE,
+		.doit = nl80211_set_p2p_power_save,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+				  NL80211_FLAG_NEED_RTNL,
+	},
  };

  static struct genl_multicast_group nl80211_mlme_mcgrp = {
diff --git a/net/wireless/util.c b/net/wireless/util.c
index e0bd192..50180dc 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1142,6 +1142,15 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t  
len,
  					}
  				}
  			}
+			if (elen >= 4 && pos[0] == 0x50 && pos[1] == 0x6F &&
+			    pos[2] == 0x9A) {
+				/* P2P OUI (50:6F:9A) */
+				if (calc_crc)
+					crc = crc32_be(crc, pos - 2, elen + 2);
+
+				elems->p2p_ie = pos;
+				elems->p2p_ie_len = elen;
+			}
  			break;
  		case WLAN_EID_RSN:
  			elems->rsn = pos;
-- 
1.7.1
