Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38784 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbXJ2QIr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2007 12:08:47 -0400
Subject: [RFC] mac80211: remove unused driver ops
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Michael Wu <flamingice@sourmilk.net>
Content-Type: text/plain
Date: Mon, 29 Oct 2007 16:15:33 +0100
Message-Id: <1193670933.5197.67.camel@johannes.berg> (sfid-20071029_160849_130539_64C7AC97)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver operations set_ieee8021x(), set_port_auth() and
set_privacy_invoked() are not used by any drivers, except
set_privacy_invoked() they aren't even used by mac80211.
Remove them at least until we need to support drivers with
mac80211 that require getting this information.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/net/mac80211.h         |   21 ---------------------
 net/mac80211/ieee80211_ioctl.c |    7 +------
 2 files changed, 1 insertion(+), 27 deletions(-)

--- linux-2.6.orig/include/net/mac80211.h	2007-10-29 15:51:51.311982367 +0100
+++ linux-2.6/include/net/mac80211.h	2007-10-29 16:01:40.109048556 +0100
@@ -941,27 +941,11 @@ enum ieee80211_erp_change_flags {
  *	and remove_interface calls, i.e. while the interface with the
  *	given local_address is enabled.
  *
- * @set_ieee8021x: Enable/disable IEEE 802.1X. This item requests wlan card
- *	to pass unencrypted EAPOL-Key frames even when encryption is
- *	configured. If the wlan card does not require such a configuration,
- *	this function pointer can be set to NULL.
- *
- * @set_port_auth: Set port authorization state (IEEE 802.1X PAE) to be
- *	authorized (@authorized=1) or unauthorized (=0). This function can be
- *	used if the wlan hardware or low-level driver implements PAE.
- *	mac80211 will filter frames based on authorization state in any case,
- *	so this function pointer can be NULL if low-level driver does not
- *	require event notification about port state changes.
- *
  * @hw_scan: Ask the hardware to service the scan request, no need to start
  *	the scan state machine in stack.
  *
  * @get_stats: return low-level statistics
  *
- * @set_privacy_invoked: For devices that generate their own beacons and probe
- *	response or association responses this updates the state of privacy_invoked
- *	returns 0 for success or an error number.
- *
  * @get_sequence_counter: For devices that have internal sequence counters this
  *	callback allows mac80211 to access the current value of a counter.
  *	This callback seems not well-defined, tell us if you need it.
@@ -1034,14 +1018,9 @@ struct ieee80211_ops {
 	int (*set_key)(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		       const u8 *local_address, const u8 *address,
 		       struct ieee80211_key_conf *key);
-	int (*set_ieee8021x)(struct ieee80211_hw *hw, int use_ieee8021x);
-	int (*set_port_auth)(struct ieee80211_hw *hw, u8 *addr,
-			     int authorized);
 	int (*hw_scan)(struct ieee80211_hw *hw, u8 *ssid, size_t len);
 	int (*get_stats)(struct ieee80211_hw *hw,
 			 struct ieee80211_low_level_stats *stats);
-	int (*set_privacy_invoked)(struct ieee80211_hw *hw,
-				   int privacy_invoked);
 	int (*get_sequence_counter)(struct ieee80211_hw *hw,
 				    u8* addr, u8 keyidx, u8 txrx,
 				    u32* iv32, u16* iv16);
--- linux-2.6.orig/net/mac80211/ieee80211_ioctl.c	2007-10-29 15:50:53.209046766 +0100
+++ linux-2.6/net/mac80211/ieee80211_ioctl.c	2007-10-29 16:01:40.769042535 +0100
@@ -917,7 +917,6 @@ static int ieee80211_ioctl_siwauth(struc
 				   struct iw_request_info *info,
 				   struct iw_param *data, char *extra)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	int ret = 0;
 
@@ -927,6 +926,7 @@ static int ieee80211_ioctl_siwauth(struc
 	case IW_AUTH_CIPHER_GROUP:
 	case IW_AUTH_WPA_ENABLED:
 	case IW_AUTH_RX_UNENCRYPTED_EAPOL:
+	case IW_AUTH_PRIVACY_INVOKED:
 		break;
 	case IW_AUTH_KEY_MGMT:
 		if (sdata->type != IEEE80211_IF_TYPE_STA)
@@ -948,11 +948,6 @@ static int ieee80211_ioctl_siwauth(struc
 		else
 			ret = -EOPNOTSUPP;
 		break;
-	case IW_AUTH_PRIVACY_INVOKED:
-		if (local->ops->set_privacy_invoked)
-			ret = local->ops->set_privacy_invoked(
-					local_to_hw(local), data->value);
-		break;
 	default:
 		ret = -EOPNOTSUPP;
 		break;


