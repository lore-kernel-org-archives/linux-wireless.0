Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64197 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812Ab0LISna (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 13:43:30 -0500
Received: by yxt3 with SMTP id 3so1572666yxt.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Dec 2010 10:43:30 -0800 (PST)
From: Tim Harvey <harvey.tim@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Tim Harvey <harvey.tim@gmail.com>
Subject: [PATCH v3] mac80211: Fix NULL-pointer deference on ibss merge when not ready
Date: Thu,  9 Dec 2010 10:43:13 -0800
Message-Id: <1291920193-28228-1-git-send-email-harvey.tim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

dev_open will eventually call ieee80211_ibss_join which sets up the
skb used for beacons/probe-responses however it is possible to
receive beacons that attempt to merge before this occurs causing
a null pointer dereference.  Check ssid_len as that is the last
thing set in ieee80211_ibss_join.

This occurs quite easily in the presence of adhoc nodes with hidden SSID's

revised previous patch to check further up based on irc feedback

Signed-off-by: Tim Harvey <harvey.tim@gmail.com>
---
 net/mac80211/ibss.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 410d104..53c7077 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -780,6 +780,9 @@ void ieee80211_ibss_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 
 	mutex_lock(&sdata->u.ibss.mtx);
 
+	if (!sdata->u.ibss.ssid_len)
+		goto mgmt_out; /* not ready to merge yet */
+
 	switch (fc & IEEE80211_FCTL_STYPE) {
 	case IEEE80211_STYPE_PROBE_REQ:
 		ieee80211_rx_mgmt_probe_req(sdata, mgmt, skb->len);
@@ -797,6 +800,7 @@ void ieee80211_ibss_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 		break;
 	}
 
+ mgmt_out:
 	mutex_unlock(&sdata->u.ibss.mtx);
 }
 
-- 
1.7.0.4

