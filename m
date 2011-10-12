Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42970 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab1JLBCk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 21:02:40 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt4so235648bkb.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 18:02:39 -0700 (PDT)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Wed, 12 Oct 2011 03:02:35 +0200
To: linux-wireless@vger.kernel.org
Cc: "Bartosz MARKOWSKI" <bartosz.markowski@tieto.com>,
	"Janusz DZIEDZIC" <janusz.dziedzic@tieto.com>
Subject: [RFC 02/07] compat-wireless: Connection quality monitor extensions
MIME-Version: 1.0
From: "Dmitry Tarnyagin" <abi.dmitryt@gmail.com>
Message-ID: <op.v27rulkhya27un@edmitar> (sfid-20111012_030243_875021_0262D42B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bartosz Markowski <bartosz.markowski@tieto.com>
Date: Tue, 12 Jul 2011 13:29:03 +0200
Subject: [PATCH 2/7] compat-wireless: CQM STE extensions

added:
* beacon miss threshold - This value specifies the threshold
   for the BEACON loss level
* tx fail - This value specifies the threshold for the TX loss level

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
  include/linux/compat-3.0.h |    2 +
  include/linux/nl80211.h    |   16 +++++
  include/net/cfg80211.h     |   34 ++++++++++
  include/net/mac80211.h     |   41 ++++++++++++
  net/mac80211/cfg.c         |   54 ++++++++++++++++
  net/mac80211/mlme.c        |   23 ++++++-
  net/wireless/mlme.c        |   25 +++++++
  net/wireless/nl80211.c     |  152  
+++++++++++++++++++++++++++++++++++++++++++-
  net/wireless/nl80211.h     |    9 +++
  9 files changed, 353 insertions(+), 3 deletions(-)

diff --git a/include/linux/compat-3.0.h b/include/linux/compat-3.0.h
index 8c8720e..961a3a6 100644
--- a/include/linux/compat-3.0.h
+++ b/include/linux/compat-3.0.h
@@ -59,6 +59,7 @@ int __must_check kstrtos16_from_user(const char __user  
*s, size_t count, unsigne
  int __must_check kstrtou8_from_user(const char __user *s, size_t count,  
unsigned int base, u8 *res);
  int __must_check kstrtos8_from_user(const char __user *s, size_t count,  
unsigned int base, s8 *res);

+/*
  static inline int __must_check kstrtou64_from_user(const char __user *s,  
size_t count, unsigned int base, u64 *res)
  {
  	return kstrtoull_from_user(s, count, base, res);
@@ -78,6 +79,7 @@ static inline int __must_check kstrtos32_from_user(const  
char __user *s, size_t
  {
  	return kstrtoint_from_user(s, count, base, res);
  }
+*/

  #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,0,0)) */

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index be125a5..44911f6 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -2311,6 +2311,14 @@ enum nl80211_ps_state {
   * @NL80211_ATTR_CQM_RSSI_THRESHOLD_EVENT: RSSI threshold event
   * @NL80211_ATTR_CQM_PKT_LOSS_EVENT: a u32 value indicating that this many
   *	consecutive packets were not acknowledged by the peer
+ * @NL80211_ATTR_CQM_BEACON_MISS_THOLD: BEACON threshold. This value  
specifies
+ *	the threshold for the BEACON loss level at which an event will be
+ *	sent. Zero to disable.
+ * @NL80211_ATTR_CQM_BEACON_MISS_THOLD_EVENT: BEACON miss event
+ * @NL80211_ATTR_CQM_TX_FAIL_THOLD: TX threshold. This value specifies the
+ *	the threshold for the TX loss level at which an event will be
+ *	sent. Zero to disable.
+ * @NL80211_ATTR_CQM_TX_FAIL_THOLD_EVENT: TX threshold event
   * @__NL80211_ATTR_CQM_AFTER_LAST: internal
   * @NL80211_ATTR_CQM_MAX: highest key attribute
   */
@@ -2321,6 +2329,14 @@ enum nl80211_attr_cqm {
  	NL80211_ATTR_CQM_RSSI_THRESHOLD_EVENT,
  	NL80211_ATTR_CQM_PKT_LOSS_EVENT,

+	/* Beacon Threshold */
+	NL80211_ATTR_CQM_BEACON_MISS_THOLD,
+	NL80211_ATTR_CQM_BEACON_MISS_THOLD_EVENT,
+
+	/* Tx Threshold */
+	NL80211_ATTR_CQM_TX_FAIL_THOLD,
+	NL80211_ATTR_CQM_TX_FAIL_THOLD_EVENT,
+
  	/* keep last */
  	__NL80211_ATTR_CQM_AFTER_LAST,
  	NL80211_ATTR_CQM_MAX = __NL80211_ATTR_CQM_AFTER_LAST - 1
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7fcb671..d2a9c21 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1403,6 +1403,9 @@ struct cfg80211_gtk_rekey_data {
   * @set_power_mgmt: Configure WLAN power management. A timeout value of -1
   *	allows the driver to adjust the dynamic ps timeout value.
   * @set_cqm_rssi_config: Configure connection quality monitor RSSI  
threshold.
+ * @set_cqm_beacon_miss_config: Configure connection quality monitor  
BEACON
+ *	threshold
+ * @set_cqm_tx_fail_config: Configure connection quality monitor TX  
threshold.
   * @sched_scan_start: Tell the driver to start a scheduled scan.
   * @sched_scan_stop: Tell the driver to stop an ongoing scheduled
   *	scan.  The driver_initiated flag specifies whether the driver
@@ -1590,6 +1593,14 @@ struct cfg80211_ops {
  				       struct net_device *dev,
  				       s32 rssi_thold, u32 rssi_hyst);

+	int     (*set_cqm_beacon_miss_config)(struct wiphy *wiphy,
+				       struct net_device *dev,
+				       u32 beacon_thold);
+
+	int     (*set_cqm_tx_fail_config)(struct wiphy *wiphy,
+				       struct net_device *dev,
+				       u32 tx_thold);
+
  	void	(*mgmt_frame_register)(struct wiphy *wiphy,
  				       struct net_device *dev,
  				       u16 frame_type, bool reg);
@@ -3185,6 +3196,29 @@ void cfg80211_gtk_rekey_notify(struct net_device  
*dev, const u8 *bssid,
  void cfg80211_pmksa_candidate_notify(struct net_device *dev, int index,
  				     const u8 *bssid, bool preauth, gfp_t gfp);

+/*
+ * cfg80211_cqm_beacon_miss_notify - connection quality monitoring beacon
+ *	miss event
+ * @dev: network device
+ * @gfp: context flags
+ *
+ * This function is called when a configured connection quality monitoring
+ * beacon threshold reached event occurs.
+ */
+void cfg80211_cqm_beacon_miss_notify(struct net_device *dev,
+				     gfp_t gfp);
+
+/**
+ * cfg80211_cqm_tx_fail_notify - connection quality monitoring tx failure  
event
+ * @dev: network device
+ * @gfp: context flags
+ *
+ * This function is called when a configured connection quality monitoring
+ * tx threshold reached event occurs.
+ */
+void cfg80211_cqm_tx_fail_notify(struct net_device *dev,
+				 gfp_t gfp);
+
  /* Logging, debugging and troubleshooting/diagnostic helpers. */

  /* wiphy_printk helpers, similar to dev_printk */
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e9d5745..604464e 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -244,6 +244,10 @@ enum ieee80211_rssi_event {
   * @cqm_rssi_thold: Connection quality monitor RSSI threshold, a zero  
value
   *	implies disabled
   * @cqm_rssi_hyst: Connection quality monitor RSSI hysteresis
+ * @cqm_beacon_miss_thold: Connection quality monitor beacon threshold, a  
zero
+ *	value implies disabled
+ * @cqm_tx_fail_thold: Connection quality monitor tx threshold, a zero  
value
+ *	implies disabled
   * @arp_addr_list: List of IPv4 addresses for hardware ARP filtering. The
   *	may filter ARP queries targeted for other addresses than listed here.
   *	The driver must allow ARP queries targeted for all address listed here
@@ -280,6 +284,8 @@ struct ieee80211_bss_conf {
  	u16 ht_operation_mode;
  	s32 cqm_rssi_thold;
  	u32 cqm_rssi_hyst;
+	u32 cqm_beacon_miss_thold;
+	u32 cqm_tx_fail_thold;
  	enum nl80211_channel_type channel_type;
  	__be32 arp_addr_list[IEEE80211_BSS_ARP_ADDR_LIST_LEN];
  	u8 arp_addr_cnt;
@@ -1126,6 +1132,11 @@ enum sta_notify_cmd {
   * @IEEE80211_HW_TX_AMPDU_SETUP_IN_HW: The device handles TX A-MPDU  
session
   *	setup strictly in HW. mac80211 should not attempt to do this in
   *	software.
+ * @IEEE80211_HW_SUPPORTS_CQM_BEACON_MISS
+ *      Connection quality monitoring - beacon miss.
+ *
+ * @IEEE80211_HW_SUPPORTS_CQM_TX_FAIL
+ *      Connection quality monitoring - tx failure.
   */
  enum ieee80211_hw_flags {
  	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -1152,6 +1163,8 @@ enum ieee80211_hw_flags {
  	IEEE80211_HW_SUPPORTS_PER_STA_GTK		= 1<<21,
  	IEEE80211_HW_AP_LINK_PS				= 1<<22,
  	IEEE80211_HW_TX_AMPDU_SETUP_IN_HW		= 1<<23,
+	IEEE80211_HW_SUPPORTS_CQM_BEACON_MISS		= 1<<24,
+	IEEE80211_HW_SUPPORTS_CQM_TX_FAIL		= 1<<25,
  };

  /**
@@ -3376,6 +3389,34 @@ void ieee80211_cqm_rssi_notify(struct ieee80211_vif  
*vif,
   */
  unsigned char ieee80211_get_operstate(struct ieee80211_vif *vif);

+/*
+ * ieee80211_cqm_beacon_miss_notify - inform a configured connection  
quality
+ *	monitoring beacon miss threshold triggered
+ *
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * @gfp: context flag
+ *
+ * When the %IEEE80211_HW_SUPPORTS_CQM_BEACON_MISS is set, and a  
connection
+ * quality monitoring is configured with an beacon miss threshold, the  
driver
+ * will inform whenever the desired amount of consecutive beacons is  
missed.
+ */
+void ieee80211_cqm_beacon_miss_notify(struct ieee80211_vif *vif,
+				      gfp_t gfp);
+
+/**
+ * ieee80211_cqm_tx_fail_notify - inform a configured connection quality
+ *	monitoring beacon miss threshold triggered
+ *
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * @gfp: context flag
+ *
+ * When the %IEEE80211_HW_SUPPORTS_CQM_TX_FAIL is set, and a connection
+ * quality monitoring is configured with an tx failure threshold, the  
driver
+ * whenever the desired amount of consecutive TX attempts is failed.
+ */
+void ieee80211_cqm_tx_fail_notify(struct ieee80211_vif *vif,
+				  gfp_t gfp);
+
  /**
   * ieee80211_chswitch_done - Complete channel switch process
   * @vif: &struct ieee80211_vif pointer from the add_interface callback.
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 55ee5a3..da96781 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1751,6 +1751,58 @@ static int ieee80211_set_cqm_rssi_config(struct  
wiphy *wiphy,
  	return 0;
  }

+static int ieee80211_set_cqm_beacon_miss_config(struct wiphy *wiphy,
+						struct net_device *dev,
+						u32 beacon_thold)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_vif *vif = &sdata->vif;
+	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
+
+	if (beacon_thold == bss_conf->cqm_beacon_miss_thold)
+		return 0;
+
+	bss_conf->cqm_beacon_miss_thold = beacon_thold;
+
+	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_CQM_BEACON_MISS)) {
+		if (sdata->vif.type != NL80211_IFTYPE_STATION)
+			return -EOPNOTSUPP;
+		return 0;
+	}
+
+	if (sdata->u.mgd.associated)
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_CQM);
+
+	return 0;
+}
+
+static int ieee80211_set_cqm_tx_fail_config(struct wiphy *wiphy,
+					    struct net_device *dev,
+					    u32 tx_thold)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_vif *vif = &sdata->vif;
+	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
+
+	if (tx_thold == bss_conf->cqm_tx_fail_thold)
+		return 0;
+
+	bss_conf->cqm_tx_fail_thold = tx_thold;
+
+	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_CQM_TX_FAIL)) {
+		if (sdata->vif.type != NL80211_IFTYPE_STATION)
+			return -EOPNOTSUPP;
+		return 0;
+	}
+
+	if (sdata->u.mgd.associated)
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_CQM);
+
+	return 0;
+}
+
  static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
  				      struct net_device *dev,
  				      const u8 *addr,
@@ -2527,6 +2579,8 @@ struct cfg80211_ops mac80211_config_ops = {
  	.mgmt_tx = ieee80211_mgmt_tx,
  	.mgmt_tx_cancel_wait = ieee80211_mgmt_tx_cancel_wait,
  	.set_cqm_rssi_config = ieee80211_set_cqm_rssi_config,
+	.set_cqm_beacon_miss_config = ieee80211_set_cqm_beacon_miss_config,
+	.set_cqm_tx_fail_config = ieee80211_set_cqm_tx_fail_config,
  	.mgmt_frame_register = ieee80211_mgmt_frame_register,
  	.set_antenna = ieee80211_set_antenna,
  	.get_antenna = ieee80211_get_antenna,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 96f9fae..c3e2d3c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2174,7 +2174,10 @@ void ieee80211_sta_work(struct  
ieee80211_sub_if_data *sdata)
  				    ifmgd->probe_send_count, max_tries);
  #endif
  			ieee80211_mgd_probe_ap_send(sdata);
-		} else {
+		} else if (!(local->hw.flags &
+				IEEE80211_HW_SUPPORTS_CQM_BEACON_MISS) &&
+			   !(local->hw.flags &
+				IEEE80211_HW_SUPPORTS_CQM_TX_FAIL)) {
  			/*
  			 * We actually lost the connection ... or did we?
  			 * Let's make sure!
@@ -2811,3 +2814,21 @@ unsigned char ieee80211_get_operstate(struct  
ieee80211_vif *vif)
  	return sdata->dev->operstate;
  }
  EXPORT_SYMBOL(ieee80211_get_operstate);
+
+void ieee80211_cqm_beacon_miss_notify(struct ieee80211_vif *vif,
+				      gfp_t gfp)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+
+	cfg80211_cqm_beacon_miss_notify(sdata->dev, gfp);
+}
+EXPORT_SYMBOL(ieee80211_cqm_beacon_miss_notify);
+
+void ieee80211_cqm_tx_fail_notify(struct ieee80211_vif *vif,
+				      gfp_t gfp)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+
+	cfg80211_cqm_tx_fail_notify(sdata->dev, gfp);
+}
+EXPORT_SYMBOL(ieee80211_cqm_tx_fail_notify);
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 21fc970..4194b3e 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -1097,6 +1097,7 @@ void cfg80211_gtk_rekey_notify(struct net_device  
*dev, const u8 *bssid,
  }
  EXPORT_SYMBOL(cfg80211_gtk_rekey_notify);

+
  void cfg80211_pmksa_candidate_notify(struct net_device *dev, int index,
  				     const u8 *bssid, bool preauth, gfp_t gfp)
  {
@@ -1107,3 +1108,27 @@ void cfg80211_pmksa_candidate_notify(struct  
net_device *dev, int index,
  	nl80211_pmksa_candidate_notify(rdev, dev, index, bssid, preauth, gfp);
  }
  EXPORT_SYMBOL(cfg80211_pmksa_candidate_notify);
+
+void cfg80211_cqm_beacon_miss_notify(struct net_device *dev,
+				     gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	/* Indicate roaming trigger event to user space */
+	nl80211_send_cqm_beacon_miss_notify(rdev, dev, gfp);
+}
+EXPORT_SYMBOL(cfg80211_cqm_beacon_miss_notify);
+
+void cfg80211_cqm_tx_fail_notify(struct net_device *dev,
+				 gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	/* Indicate roaming trigger event to user space */
+	nl80211_send_cqm_tx_fail_notify(rdev, dev, gfp);
+}
+EXPORT_SYMBOL(cfg80211_cqm_tx_fail_notify);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4b7c1d4..8af66b2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5454,6 +5454,10 @@ nl80211_attr_cqm_policy[NL80211_ATTR_CQM_MAX + 1]  
__read_mostly = {
  	[NL80211_ATTR_CQM_RSSI_THOLD] = { .type = NLA_U32 },
  	[NL80211_ATTR_CQM_RSSI_HYST] = { .type = NLA_U32 },
  	[NL80211_ATTR_CQM_RSSI_THRESHOLD_EVENT] = { .type = NLA_U32 },
+	[NL80211_ATTR_CQM_BEACON_MISS_THOLD] = { .type = NLA_U32 },
+	[NL80211_ATTR_CQM_BEACON_MISS_THOLD_EVENT] = { .type = NLA_U32 },
+	[NL80211_ATTR_CQM_TX_FAIL_THOLD] = { .type = NLA_U32 },
+	[NL80211_ATTR_CQM_TX_FAIL_THOLD_EVENT] = { .type = NLA_U32 },
  };

  static int nl80211_set_cqm_rssi(struct genl_info *info,
@@ -5479,6 +5483,45 @@ static int nl80211_set_cqm_rssi(struct genl_info  
*info,
  					      threshold, hysteresis);
  }

+static int nl80211_set_cqm_beacon_miss(struct genl_info *info,
+				       u32 threshold)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev;
+	struct net_device *dev = info->user_ptr[1];
+
+	wdev = dev->ieee80211_ptr;
+
+	if (!rdev->ops->set_cqm_beacon_miss_config)
+		return -EOPNOTSUPP;
+
+	if (wdev->iftype != NL80211_IFTYPE_STATION &&
+	    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)
+		return -EOPNOTSUPP;
+
+	return rdev->ops->set_cqm_beacon_miss_config(wdev->wiphy,
+			dev, threshold);
+}
+
+static int nl80211_set_cqm_tx_fail(struct genl_info *info,
+				   u32 threshold)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev;
+	struct net_device *dev = info->user_ptr[1];
+
+	wdev = dev->ieee80211_ptr;
+
+	if (!rdev->ops->set_cqm_tx_fail_config)
+		return -EOPNOTSUPP;
+
+	if (wdev->iftype != NL80211_IFTYPE_STATION &&
+	    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)
+		return -EOPNOTSUPP;
+
+	return rdev->ops->set_cqm_tx_fail_config(wdev->wiphy, dev, threshold);
+}
+
  static int nl80211_set_cqm(struct sk_buff *skb, struct genl_info *info)
  {
  	struct nlattr *attrs[NL80211_ATTR_CQM_MAX + 1];
@@ -5503,8 +5546,25 @@ static int nl80211_set_cqm(struct sk_buff *skb,  
struct genl_info *info)
  		threshold = nla_get_u32(attrs[NL80211_ATTR_CQM_RSSI_THOLD]);
  		hysteresis = nla_get_u32(attrs[NL80211_ATTR_CQM_RSSI_HYST]);
  		err = nl80211_set_cqm_rssi(info, threshold, hysteresis);
-	} else
-		err = -EINVAL;
+		if (err)
+			goto out;
+	}
+
+	if (attrs[NL80211_ATTR_CQM_BEACON_MISS_THOLD]) {
+		u32 thold;
+		thold = nla_get_u32(attrs[NL80211_ATTR_CQM_BEACON_MISS_THOLD]);
+		err = nl80211_set_cqm_beacon_miss(info, thold);
+		if (err)
+			goto out;
+	}
+
+	if (attrs[NL80211_ATTR_CQM_TX_FAIL_THOLD]) {
+		u32 thold;
+		thold = nla_get_u32(attrs[NL80211_ATTR_CQM_TX_FAIL_THOLD]);
+		err = nl80211_set_cqm_tx_fail(info, thold);
+		if (err)
+			goto out;
+	}

  out:
  	return err;
@@ -7463,6 +7523,94 @@ nl80211_send_cqm_pktloss_notify(struct  
cfg80211_registered_device *rdev,
  	nlmsg_free(msg);
  }

+void
+nl80211_send_cqm_beacon_miss_notify(struct cfg80211_registered_device  
*rdev,
+				    struct net_device *netdev,
+				    gfp_t gfp)
+{
+	struct sk_buff *msg;
+	struct nlattr *pinfoattr;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_NOTIFY_CQM);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
+
+	pinfoattr = nla_nest_start(msg, NL80211_ATTR_CQM);
+	if (!pinfoattr)
+		goto nla_put_failure;
+
+	NLA_PUT_U32(msg, NL80211_ATTR_CQM_BEACON_MISS_THOLD_EVENT, 0);
+
+	nla_nest_end(msg, pinfoattr);
+
+	if (genlmsg_end(msg, hdr) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_mlme_mcgrp.id, gfp);
+	return;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+}
+
+void
+nl80211_send_cqm_tx_fail_notify(struct cfg80211_registered_device *rdev,
+				struct net_device *netdev,
+				gfp_t gfp)
+{
+	struct sk_buff *msg;
+	struct nlattr *pinfoattr;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_NOTIFY_CQM);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
+
+	pinfoattr = nla_nest_start(msg, NL80211_ATTR_CQM);
+	if (!pinfoattr)
+		goto nla_put_failure;
+
+	NLA_PUT_U32(msg, NL80211_ATTR_CQM_TX_FAIL_THOLD_EVENT, 0);
+
+	nla_nest_end(msg, pinfoattr);
+
+	if (genlmsg_end(msg, hdr) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_mlme_mcgrp.id, gfp);
+	return;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+}
+
  static int nl80211_netlink_notify(struct notifier_block * nb,
  				  unsigned long state,
  				  void *_notify)
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index f24a1fb..920e19a 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -108,6 +108,15 @@ void
  nl80211_send_cqm_pktloss_notify(struct cfg80211_registered_device *rdev,
  				struct net_device *netdev, const u8 *peer,
  				u32 num_packets, gfp_t gfp);
+void
+nl80211_send_cqm_beacon_miss_notify(struct cfg80211_registered_device  
*rdev,
+			       struct net_device *netdev,
+			       gfp_t gfp);
+
+void
+nl80211_send_cqm_tx_fail_notify(struct cfg80211_registered_device *rdev,
+			   struct net_device *netdev,
+			   gfp_t gfp);

  void nl80211_gtk_rekey_notify(struct cfg80211_registered_device *rdev,
  			      struct net_device *netdev, const u8 *bssid,
-- 
1.7.1
