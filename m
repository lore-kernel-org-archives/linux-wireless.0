Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52593 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbXK1N3j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 08:29:39 -0500
Subject: [PATCH (2.6.24, #everything)] mac80211: allow setting
	drop_unencrypted with wext
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>, Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 28 Nov 2007 11:04:21 +0100
Message-Id: <1196244262.6058.120.camel@johannes.berg> (sfid-20071128_132942_523291_49015714)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch allows wpa_supplicant to set the drop_unencrypted setting in
mac80211.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
This patch applies to both 2.6.24 and #everything

 net/mac80211/ieee80211_ioctl.c |    3 +++
 1 file changed, 3 insertions(+)

--- linux-2.6.orig/net/mac80211/ieee80211_ioctl.c	2007-11-13 19:00:03.519120007 +0100
+++ linux-2.6/net/mac80211/ieee80211_ioctl.c	2007-11-28 11:01:25.218924587 +0100
@@ -928,6 +928,9 @@ static int ieee80211_ioctl_siwauth(struc
 	case IW_AUTH_RX_UNENCRYPTED_EAPOL:
 	case IW_AUTH_KEY_MGMT:
 		break;
+	case IW_AUTH_DROP_UNENCRYPTED:
+		sdata->drop_unencrypted = !!data->value;
+		break;
 	case IW_AUTH_PRIVACY_INVOKED:
 		if (sdata->type != IEEE80211_IF_TYPE_STA)
 			ret = -EINVAL;


