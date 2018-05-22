Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:54398 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751101AbeEVAqJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 May 2018 20:46:09 -0400
Received: by mail-wm0-f66.google.com with SMTP id f6-v6so28078653wmc.4
        for <linux-wireless@vger.kernel.org>; Mon, 21 May 2018 17:46:09 -0700 (PDT)
Received: from iss.ger.corp.intel.com ([139.47.106.244])
        by smtp.gmail.com with ESMTPSA id h10-v6sm26123513wrf.83.2018.05.21.17.46.07
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 May 2018 17:46:07 -0700 (PDT)
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] nl80211: Reject disconnect commands except from conn_owner
Date: Tue, 22 May 2018 02:46:02 +0200
Message-Id: <20180522004602.19370-1-andrew.zaborowski@intel.com> (sfid-20180522_024612_553067_045404DA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reject NL80211_CMD_DISCONNECT, NL80211_CMD_DISASSOCIATE,
NL80211_CMD_DEAUTHENTICATE and NL80211_CMD_ASSOCIATE commands
from clients other than the connection owner set in the connect,
authenticate or associate commands, if it was set.

The main point of this check is to prevent chaos when two processes
try to use nl80211 at the same time, it's not a security measure.
The same thing should possibly be done for JOIN_IBSS/LEAVE_IBSS and
START_AP/STOP_AP.

Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
---
 net/wireless/nl80211.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e4a52a2b5e..85f094a564 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8506,6 +8506,10 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 	const u8 *bssid, *ssid;
 	int err, ssid_len = 0;
 
+	if (dev->ieee80211_ptr->conn_owner_nlportid &&
+	    dev->ieee80211_ptr->conn_owner_nlportid != info->snd_portid)
+		return -EPERM;
+
 	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
 		return -EINVAL;
 
@@ -8628,6 +8632,10 @@ static int nl80211_deauthenticate(struct sk_buff *skb, struct genl_info *info)
 	u16 reason_code;
 	bool local_state_change;
 
+	if (dev->ieee80211_ptr->conn_owner_nlportid &&
+	    dev->ieee80211_ptr->conn_owner_nlportid != info->snd_portid)
+		return -EPERM;
+
 	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
 		return -EINVAL;
 
@@ -8675,6 +8683,10 @@ static int nl80211_disassociate(struct sk_buff *skb, struct genl_info *info)
 	u16 reason_code;
 	bool local_state_change;
 
+	if (dev->ieee80211_ptr->conn_owner_nlportid &&
+	    dev->ieee80211_ptr->conn_owner_nlportid != info->snd_portid)
+		return -EPERM;
+
 	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
 		return -EINVAL;
 
@@ -9451,6 +9463,10 @@ static int nl80211_disconnect(struct sk_buff *skb, struct genl_info *info)
 	u16 reason;
 	int ret;
 
+	if (dev->ieee80211_ptr->conn_owner_nlportid &&
+	    dev->ieee80211_ptr->conn_owner_nlportid != info->snd_portid)
+		return -EPERM;
+
 	if (!info->attrs[NL80211_ATTR_REASON_CODE])
 		reason = WLAN_REASON_DEAUTH_LEAVING;
 	else
-- 
2.14.1
