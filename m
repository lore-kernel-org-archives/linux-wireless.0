Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www19.servergod.com ([64.89.16.20]:54292 "EHLO
	www19.servergod.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab2FSAUD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 20:20:03 -0400
Message-ID: <4FDFC5B2.1010807@opentechinstitute.org> (sfid-20120619_022007_340967_58722B8D)
Date: Mon, 18 Jun 2012 20:20:02 -0400
From: Will Hawkins <hawkinsw@opentechinstitute.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: [PATCH 1/2 v3] mac80211/cfg80211: add support for userspace to handle
 auth frames on adhoc ifaces
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add cfg80211_mgmt_reg_match to cfg80211 to check for userspace
application registrations for management frames rx'd from a specific
interface. This function will be used by IBSS code to determine whether
or not to send out "open" authentication frames.

Update documentation for cfg80211_rx_mgmt to note that "query" frames
are sent to matching userspace applications.


Signed-off-by: Will Hawkins <hawkinsw@opentechinstitute.org>
---
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7319f25..fd84880 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3238,6 +3238,18 @@ void cfg80211_new_sta(struct net_device *dev,
const u8 *mac_addr,
 void cfg80211_del_sta(struct net_device *dev, const u8 *mac_addr, gfp_t
gfp);

 /**
+ * cfg80211_mgmt_reg_match - check for userspace mgmt frame registrations
+ *
+ * @dev: the netdev
+ * @frame_type: mgmt frame type to match against. Should be or'd
+ * with IEEE80211_FTYPE_MGMT before being passed.
+ *
+ * Returns %true if a user space application has registered for this
+ * frame type. Returns %false otherwise.
+ */
+int cfg80211_mgmt_reg_match(struct net_device *dev, u16 frame_type);
+			
+/**
  * cfg80211_rx_mgmt - notification of received, unprocessed management
frame
  * @dev: network device
  * @freq: Frequency on which the frame was received in MHz
@@ -3247,6 +3259,7 @@ void cfg80211_del_sta(struct net_device *dev,
const u8 *mac_addr, gfp_t gfp);
  * @gfp: context flags
  *
  * Returns %true if a user space application has registered for this frame.
+ * When a user space application is registered for this frame, it is
notified.
  * For action frames, that makes it responsible for rejecting unrecognized
  * action frames; %false otherwise, in which case for action frames the
  * driver is responsible for rejecting the frame.
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index da4406f..2d5e6dd 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -609,6 +609,41 @@ struct cfg80211_mgmt_registration {
 	u8 match[];
 };

+int cfg80211_mgmt_reg_match(struct net_device *dev, u16 frame_type)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_mgmt_registration *reg;
+	int matched = 0;
+	u16 mgmt_type;
+
+	if (!wdev->wiphy->mgmt_stypes)
+		return 0;
+
+	if ((frame_type & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_MGMT)
+		return 0;
+
+	if (frame_type & ~(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE))
+		return 0;
+
+	mgmt_type = (frame_type & IEEE80211_FCTL_STYPE) >> 4;
+	if (!(wdev->wiphy->mgmt_stypes[wdev->iftype].rx & BIT(mgmt_type)))
+		return 0;
+
+	spin_lock_bh(&wdev->mgmt_registrations_lock);
+
+	list_for_each_entry(reg, &wdev->mgmt_registrations, list) {
+		if (frame_type == le16_to_cpu(reg->frame_type)) {
+			matched = 1;
+			break;
+		}
+	}
+
+	spin_unlock_bh(&wdev->mgmt_registrations_lock);
+
+	return matched;
+}
+EXPORT_SYMBOL(cfg80211_mgmt_reg_match);
+
 int cfg80211_mlme_register_mgmt(struct wireless_dev *wdev, u32 snd_pid,
 				u16 frame_type, const u8 *match_data,
 				int match_len)
