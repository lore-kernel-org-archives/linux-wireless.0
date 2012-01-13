Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from investici.nine.ch ([217.150.252.179]:39858 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab2AMNxs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jan 2012 08:53:48 -0500
From: Antonio Quartulli <ordex@autistici.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Antonio Quartulli <ordex@autistici.org>
Subject: [PATCHv2 1/2] mac80211: add a 2-way Authentication challenge to IBSS mode
Date: Fri, 13 Jan 2012 14:52:57 +0100
Message-Id: <1326462778-7251-1-git-send-email-ordex@autistici.org> (sfid-20120113_145352_403846_B43C15F4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In IBSS mode, whenever a new station is added a 2-way authentication challenge
is performed. Actually this event can be used to recognise a new station joining
the cell even if its sta_info entry is already in the list.

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---

- subject and commit message rephrased (old subject:
  "mac80211: send the Auth frame in IBSS")
- this patch is based on the not yet committed patch:
  "mac80211: fix IBSS auth frame DA"

 net/mac80211/ibss.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 9b70689..a7564e3 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -289,6 +289,14 @@ static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta)
 		    addr, sdata->name);
 #endif
 
+#ifdef CONFIG_MAC80211_IBSS_DEBUG
+	printk(KERN_DEBUG "TX Auth SA=%pM DA=%pM BSSID=%pM"
+	       "(auth_transaction=1)\n", sdata->vif.addr,
+	       sdata->u.ibss.bssid, addr);
+#endif
+	ieee80211_send_auth(sdata, 1, WLAN_AUTH_OPEN, NULL, 0,
+			    addr, sdata->u.ibss.bssid, NULL, 0, 0);
+
 	sta_info_move_state(sta, IEEE80211_STA_AUTH);
 	sta_info_move_state(sta, IEEE80211_STA_ASSOC);
 	sta_info_move_state(sta, IEEE80211_STA_AUTHORIZED);
-- 
1.7.3.4

