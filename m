Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:53822 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755715AbYJ3Rvn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 13:51:43 -0400
Date: Thu, 30 Oct 2008 19:50:30 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Allow AP mode to be enabled
Message-ID: <20081030175030.GD3923@jm.kir.nu> (sfid-20081030_185153_056549_83E10BC4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the addition of basic rate set and TX queue parameter
configuration and confirmation that power save buffering is
working again, mac80211 is now in state that allows AP mode to be
used without major problems. Consequently, it is time to allow this
mode to be enabled without having to patch the kernel.

AP mode requires hostapd for management frame processing and as such,
configuring this mode is only allowed through cfg80211 (not with
iwconfig and WEXT).

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

Index: wireless-testing/net/mac80211/cfg.c
===================================================================
--- wireless-testing.orig/net/mac80211/cfg.c	2008-10-28 10:32:35.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2008-10-28 10:32:40.000000000 +0200
@@ -26,6 +26,8 @@
 #ifdef CONFIG_MAC80211_MESH
 	case NL80211_IFTYPE_MESH_POINT:
 #endif
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_WDS:
 		return true;
 	default:

-- 
Jouni Malinen                                            PGP id EFC895FA
