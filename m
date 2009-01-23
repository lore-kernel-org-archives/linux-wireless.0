Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 39.mail-out.ovh.net ([213.251.138.60]:47444 "HELO
	39.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760735AbZAWBeR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 20:34:17 -0500
Date: Fri, 23 Jan 2009 02:30:01 +0100
From: Samuel Ortiz <samuel@sortiz.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Alina Friedrichsen <x-alina@gmx.net>,
	Kalle Valo <kalle.valo@iki.fi>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH] mac80211: ieee80211_sta_set_bssid should call
	config_interface()
Message-ID: <20090123013000.GA5604@sortiz.org> (sfid-20090123_023425_528591_E5DA477C)
Reply-To: Samuel Ortiz <samuel@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <samuel.ortiz@intel.com>

With commit e32b1b9a33759e8a83ac566c4c43f23ed5d6343b, we end up not calling
config_interface() when we're in STA, but not Ad-Hoc. This breaks several
drivers, and the fix is to get ieee80211_sta_set_bssid() to call
ieee80211_if_config() again.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 net/mac80211/mlme.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

Index: wireless-testing/net/mac80211/mlme.c
===================================================================
--- wireless-testing.orig/net/mac80211/mlme.c	2009-01-23 01:33:54.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-01-23 01:36:51.000000000 +0100
@@ -2650,6 +2650,18 @@ int ieee80211_sta_set_bssid(struct ieee8
 		ifsta->flags &= ~IEEE80211_STA_BSSID_SET;
 	}
 
+	if (netif_running(sdata->dev)) {
+		int ret;
+
+		ret = ieee80211_if_config(sdata, IEEE80211_IFCC_BSSID);
+
+		if (ret) {
+			printk(KERN_DEBUG "%s: Failed to config new BSSID to "
+			       "the low-level driver\n", sdata->dev->name);
+			return ret;
+		}
+	}
+
 	return ieee80211_sta_set_ssid(sdata, ifsta->ssid, ifsta->ssid_len);
 }
 
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
