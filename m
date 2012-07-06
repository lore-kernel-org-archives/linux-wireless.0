Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29325 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932984Ab2GFWJP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 18:09:15 -0400
Date: Fri, 6 Jul 2012 15:09:11 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<kvalo@qca.qualcomm.com>, <arend@broadcom.com>, <henry@logout.com>,
	<senthilb@qca.qualcomm.com>
Subject: Re: [PATCH 4/4] cfg80211: add cellular base station regulatory hint
 support
Message-ID: <20120706220911.GB28694@tux> (sfid-20120707_000919_783699_7B4B0CF1)
References: <CAB=NE6UfGuOh843dSx7NG7UYtEiDVcLUJbu6nFnBJs-Qk4tszw@mail.gmail.com>
 <1341474303.4455.5.camel@jlt3.sipsolutions.net>
 <CAB=NE6Uw1pso+HmVAahMvT3BZ0AheWxXuhJFLedvsHKXsUn11g@mail.gmail.com>
 <1341556785.4462.0.camel@jlt3.sipsolutions.net>
 <CAB=NE6XmbAu+xkLHYaBt=z6zdxXME5cOoANUd_3yEr+va_jb8g@mail.gmail.com>
 <1341583919.16893.3.camel@jlt3.sipsolutions.net>
 <CAB=NE6XNmrS=kqoptMg67JhBQUJfYa=jUFz+aU-4E91vzqjnTg@mail.gmail.com>
 <1341589880.16893.11.camel@jlt3.sipsolutions.net>
 <CAB=NE6XaRZa4HKg25gd5zkWn=LrjcAXq4NMPVcFWn+PdtVwRdw@mail.gmail.com>
 <1341591350.16893.13.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1341591350.16893.13.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FWIW, here's the delta I plan on adding that adds a device
count for number of devices that support the base station
hints and disregards the hints unless the core has 1 device
that supports this. I'll roll this into a new series and
later send ath5k / ath9k patches separately as I see now
that cfg80211 changes go through you and driver updates
through linville.

diff --git a/net/wireless/core.c b/net/wireless/core.c
index e13365f..153f7dc 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -537,6 +537,7 @@ int wiphy_register(struct wiphy *wiphy)
 	}
 
 	/* set up regulatory info */
+	wiphy_regulatory_register(wiphy);
 	regulatory_update(wiphy, NL80211_REGDOM_SET_BY_CORE);
 
 	list_add_rcu(&rdev->list, &cfg80211_rdev_list);
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 3644159..05af62d 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -97,9 +97,16 @@ const struct ieee80211_regdomain *cfg80211_regdomain;
  *     - cfg80211_world_regdom
  *     - cfg80211_regdom
  *     - last_request
+ *     - reg_num_devs_support_basehint
  */
 static DEFINE_MUTEX(reg_mutex);
 
+/*
+ * Number of devices that registered to the core
+ * that support cellular base station regulatory hints
+ */
+static int reg_num_devs_support_basehint;
+
 static inline void assert_reg_lock(void)
 {
 	lockdep_assert_held(&reg_mutex);
@@ -934,6 +941,9 @@ bool reg_last_request_cell_base(void)
 /* Core specific check */
 static int reg_ignore_cell_hint(struct regulatory_request *pending_request)
 {
+	if (!reg_num_devs_support_basehint)
+		return -EOPNOTSUPP;
+
 	if (reg_request_cell_base(last_request)) {
 		if (!regdom_changes(pending_request->alpha2))
 			return -EALREADY;
@@ -2365,6 +2375,18 @@ int reg_device_uevent(struct device *dev, struct kobj_uevent_env *env)
 }
 #endif /* CONFIG_HOTPLUG */
 
+void wiphy_regulatory_register(struct wiphy *wiphy)
+{
+	assert_cfg80211_lock();
+
+	mutex_lock(&reg_mutex);
+
+	if (!reg_dev_ignore_cell_hint(wiphy))
+		reg_num_devs_support_basehint++;
+
+	mutex_unlock(&reg_mutex);
+}
+
 /* Caller must hold cfg80211_mutex */
 void reg_device_remove(struct wiphy *wiphy)
 {
@@ -2374,6 +2396,9 @@ void reg_device_remove(struct wiphy *wiphy)
 
 	mutex_lock(&reg_mutex);
 
+	if (!reg_dev_ignore_cell_hint(wiphy))
+		reg_num_devs_support_basehint--;
+
 	kfree(wiphy->regd);
 
 	if (last_request)
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index ba1097e..519492f 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -26,6 +26,7 @@ int regulatory_hint_user(const char *alpha2,
 			 enum nl80211_user_reg_hint_type user_reg_hint_type);
 
 int reg_device_uevent(struct device *dev, struct kobj_uevent_env *env);
+void wiphy_regulatory_register(struct wiphy *wiphy);
 void reg_device_remove(struct wiphy *wiphy);
 
 int __init regulatory_init(void);
