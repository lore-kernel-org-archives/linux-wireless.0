Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:43611 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755294AbZAHLeS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 06:34:18 -0500
Message-Id: <20090108113409.609264287@atheros.com> (sfid-20090108_123903_879167_FE60B8AB)
References: <20090108113158.681894124@atheros.com>
Date: Thu, 08 Jan 2009 13:32:11 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCHv2 13/16] mac80211: 802.11w - Add driver capability flag for MFP
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows user space to determine whether a driver supports MFP and
behave properly without having to ask user to configure this in
MFP-optional mode.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>


---
 include/net/mac80211.h |    4 ++++
 net/mac80211/wext.c    |    4 ++++
 2 files changed, 8 insertions(+)

--- wireless-testing.orig/net/mac80211/wext.c	2009-01-08 13:06:36.000000000 +0200
+++ wireless-testing/net/mac80211/wext.c	2009-01-08 13:07:22.000000000 +0200
@@ -971,6 +971,10 @@ static int ieee80211_ioctl_siwauth(struc
 			ret = -EOPNOTSUPP;
 		break;
 	case IW_AUTH_MFP:
+		if (!(sdata->local->hw.flags & IEEE80211_HW_MFP_CAPABLE)) {
+			ret = -EOPNOTSUPP;
+			break;
+		}
 		if (sdata->vif.type == NL80211_IFTYPE_STATION ||
 		    sdata->vif.type == NL80211_IFTYPE_ADHOC)
 			sdata->u.sta.mfp = data->value;
--- wireless-testing.orig/include/net/mac80211.h	2009-01-08 13:07:29.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2009-01-08 13:08:12.000000000 +0200
@@ -872,6 +872,9 @@ enum ieee80211_tkip_key_type {
  *
  * @IEEE80211_HW_SUPPORTS_DYNAMIC_PS:
  *	Hardware has support for dynamic PS.
+ *
+ * @IEEE80211_HW_MFP_CAPABLE:
+ *	Hardware supports management frame protection (MFP, IEEE 802.11w).
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_RX_INCLUDES_FCS			= 1<<1,
@@ -887,6 +890,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_PS			= 1<<11,
 	IEEE80211_HW_PS_NULLFUNC_STACK			= 1<<12,
 	IEEE80211_HW_SUPPORTS_DYNAMIC_PS		= 1<<13,
+	IEEE80211_HW_MFP_CAPABLE			= 1<<14,
 };
 
 /**

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
