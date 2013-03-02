Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:52907 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab3CBGEJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Mar 2013 01:04:09 -0500
Received: by mail-pa0-f54.google.com with SMTP id fa10so2221444pad.13
        for <linux-wireless@vger.kernel.org>; Fri, 01 Mar 2013 22:04:08 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 1/6] nl80211: explicit userspace MPM
Date: Fri,  1 Mar 2013 22:02:47 -0800
Message-Id: <1362204172-28307-1-git-send-email-thomas@cozybit.com> (sfid-20130302_070419_800407_DB5F6792)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Secure mesh had the implicit requirement that the Mesh
Peering Management entity be in userspace.  However
userspace might want to implement an open MPM as well, so
specify a mesh setup parameter to indicate this.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 include/net/cfg80211.h       |    2 ++
 include/uapi/linux/nl80211.h |   25 ++++++++++++++++++-------
 net/wireless/mesh.c          |    1 +
 net/wireless/nl80211.c       |    4 ++++
 4 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9b34c76..b6be55e 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1151,6 +1151,7 @@ struct mesh_config {
  * @ie_len: length of vendor information elements
  * @is_authenticated: this mesh requires authentication
  * @is_secure: this mesh uses security
+ * @user_mpm: userspace handles all MPM functions
  * @dtim_period: DTIM period to use
  * @beacon_interval: beacon interval to use
  * @mcast_rate: multicat rate for Mesh Node [6Mbps is the default for 802.11a]
@@ -1168,6 +1169,7 @@ struct mesh_setup {
 	u8 ie_len;
 	bool is_authenticated;
 	bool is_secure;
+	bool user_mpm;
 	u8 dtim_period;
 	u16 beacon_interval;
 	int mcast_rate[IEEE80211_NUM_BANDS];
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 2d0cff5..8134c6a 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -513,9 +513,11 @@
  * @NL80211_CMD_NEW_PEER_CANDIDATE: Notification on the reception of a
  *      beacon or probe response from a compatible mesh peer.  This is only
  *      sent while no station information (sta_info) exists for the new peer
- *      candidate and when @NL80211_MESH_SETUP_USERSPACE_AUTH is set.  On
- *      reception of this notification, userspace may decide to create a new
- *      station (@NL80211_CMD_NEW_STATION).  To stop this notification from
+ *      candidate and when @NL80211_MESH_SETUP_USERSPACE_AUTH,
+ *      @NL80211_MESH_SETUP_USERSPACE_AMPE, or
+ *      @NL80211_MESH_SETUP_USERSPACE_MPM is set.  On reception of this
+ *      notification, userspace may decide to create a new station
+ *      (@NL80211_CMD_NEW_STATION).  To stop this notification from
  *      reoccurring, the userspace authentication daemon may want to create the
  *      new station with the AUTHENTICATED flag unset and maybe change it later
  *      depending on the authentication result.
@@ -1199,10 +1201,10 @@ enum nl80211_commands {
  * @NL80211_ATTR_SUPPORT_MESH_AUTH: Currently, this means the underlying driver
  *	allows auth frames in a mesh to be passed to userspace for processing via
  *	the @NL80211_MESH_SETUP_USERSPACE_AUTH flag.
- * @NL80211_ATTR_STA_PLINK_STATE: The state of a mesh peer link as
- *	defined in &enum nl80211_plink_state. Used when userspace is
- *	driving the peer link management state machine.
- *	@NL80211_MESH_SETUP_USERSPACE_AMPE must be enabled.
+ * @NL80211_ATTR_STA_PLINK_STATE: The state of a mesh peer link as defined in
+ *	&enum nl80211_plink_state. Used when userspace is driving the peer link
+ *	management state machine.  @NL80211_MESH_SETUP_USERSPACE_AMPE or
+ *	@NL80211_MESH_SETUP_USERSPACE_MPM must be enabled.
  *
  * @NL80211_ATTR_WOWLAN_TRIGGERS_SUPPORTED: indicates, as part of the wiphy
  *	capabilities, the supported WoWLAN triggers
@@ -2612,6 +2614,9 @@ enum nl80211_meshconf_params {
  *	vendor specific synchronization method or disable it to use the default
  *	neighbor offset synchronization
  *
+ * @NL80211_MESH_SETUP_USERSPACE_MPM: Enable this option if userspace will
+ *	implement an MPM which handles peer allocation and state.
+ *
  * @NL80211_MESH_SETUP_ATTR_MAX: highest possible mesh setup attribute number
  *
  * @__NL80211_MESH_SETUP_ATTR_AFTER_LAST: Internal use
@@ -2624,6 +2629,7 @@ enum nl80211_mesh_setup_params {
 	NL80211_MESH_SETUP_USERSPACE_AUTH,
 	NL80211_MESH_SETUP_USERSPACE_AMPE,
 	NL80211_MESH_SETUP_ENABLE_VENDOR_SYNC,
+	NL80211_MESH_SETUP_USERSPACE_MPM,
 
 	/* keep last */
 	__NL80211_MESH_SETUP_ATTR_AFTER_LAST,
@@ -3526,6 +3532,10 @@ enum nl80211_ap_sme_features {
  *	stations the authenticated/associated bits have to be set in the mask.
  * @NL80211_FEATURE_ADVERTISE_CHAN_LIMITS: cfg80211 advertises channel limits
  *	(HT40, VHT 80/160 MHz) if this flag is set
+ * @NL80211_FEATURE_USERSPACE_MPM: This driver supports a userspace Mesh
+ *	Peering Management entity which may be implemented by registering for
+ *	beacons or NL80211_CMD_NEW_PEER_CANDIDATE events. The mesh beacon is
+ *	still generated by the driver.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -3544,6 +3554,7 @@ enum nl80211_feature_flags {
 	/* bit 13 is reserved */
 	NL80211_FEATURE_ADVERTISE_CHAN_LIMITS		= 1 << 14,
 	NL80211_FEATURE_FULL_AP_CLIENT_STATE		= 1 << 15,
+	NL80211_FEATURE_USERSPACE_MPM			= 1 << 16,
 };
 
 /**
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 9688b24..0bb93f3 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -85,6 +85,7 @@ const struct mesh_setup default_mesh_setup = {
 	.ie = NULL,
 	.ie_len = 0,
 	.is_secure = false,
+	.user_mpm = false,
 	.beacon_interval = MESH_DEFAULT_BEACON_INTERVAL,
 	.dtim_period = MESH_DEFAULT_DTIM_PERIOD,
 };
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 39d8437..67c96cd 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4595,6 +4595,7 @@ static const struct nla_policy
 	[NL80211_MESH_SETUP_ENABLE_VENDOR_PATH_SEL] = { .type = NLA_U8 },
 	[NL80211_MESH_SETUP_ENABLE_VENDOR_METRIC] = { .type = NLA_U8 },
 	[NL80211_MESH_SETUP_USERSPACE_AUTH] = { .type = NLA_FLAG },
+	[NL80211_MESH_SETUP_USERSPACE_MPM] = { .type = NLA_FLAG },
 	[NL80211_MESH_SETUP_IE] = { .type = NLA_BINARY,
 				    .len = IEEE80211_MAX_DATA_LEN },
 	[NL80211_MESH_SETUP_USERSPACE_AMPE] = { .type = NLA_FLAG },
@@ -4769,8 +4770,11 @@ static int nl80211_parse_mesh_setup(struct genl_info *info,
 		setup->ie = nla_data(ieattr);
 		setup->ie_len = nla_len(ieattr);
 	}
+	setup->user_mpm = nla_get_flag(tb[NL80211_MESH_SETUP_USERSPACE_MPM]);
 	setup->is_authenticated = nla_get_flag(tb[NL80211_MESH_SETUP_USERSPACE_AUTH]);
 	setup->is_secure = nla_get_flag(tb[NL80211_MESH_SETUP_USERSPACE_AMPE]);
+	if (setup->is_secure)
+		setup->user_mpm = true;
 
 	return 0;
 }
-- 
1.7.10.4

