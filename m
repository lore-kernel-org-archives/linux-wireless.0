Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:63728 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075Ab1DDRYU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2011 13:24:20 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 04 Apr 2011 10:23:56 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [RFC] mac80211: prevent authentication on channel mismatch w/ hw conf
Date: Mon, 4 Apr 2011 22:54:26 +0530
Message-ID: <1301937866-14701-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not proceed authentication if hw was already configured
with one of the vif's channel which is differed with requesting
channel. Not doing so is causing unneccesary dissociation.
This issue was originaly found while testing concurrent mode
with p2p vif.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 net/mac80211/mlme.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 64d92d5..dcf3d6f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2282,11 +2282,30 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 {
 	const u8 *ssid;
 	struct ieee80211_work *wk;
+	struct ieee80211_sub_if_data *ifdata;
+	bool found = false;
 	u16 auth_alg;
 
 	if (req->local_state_change)
 		return 0; /* no need to update mac80211 state */
 
+	/*
+	 * XXX: hw conf check should be removed, once the multiple
+	 * channels are supported by mac80211
+	 */
+	mutex_lock(&sdata->local->iflist_mtx);
+	list_for_each_entry(ifdata, &sdata->local->interfaces, list) {
+		if (ifdata->vif.bss_conf.enable_beacon ||
+		    ifdata->vif.bss_conf.assoc) {
+			found = true;
+			break;
+		}
+	}
+	mutex_unlock(&sdata->local->iflist_mtx);
+
+	if (found && (sdata->local->hw.conf.channel != req->bss->channel))
+		return -EOPNOTSUPP;
+
 	switch (req->auth_type) {
 	case NL80211_AUTHTYPE_OPEN_SYSTEM:
 		auth_alg = WLAN_AUTH_OPEN;
-- 
1.7.4.2

