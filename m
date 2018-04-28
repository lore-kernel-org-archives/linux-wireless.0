Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:39790 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759215AbeD1BsJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Apr 2018 21:48:09 -0400
Received: by mail-wr0-f174.google.com with SMTP id q3-v6so3284520wrj.6
        for <linux-wireless@vger.kernel.org>; Fri, 27 Apr 2018 18:48:09 -0700 (PDT)
Received: from localhost.localdomain (static.207.35.0.81.ibercom.com. [81.0.35.207])
        by smtp.gmail.com with ESMTPSA id n49-v6sm3631484wrn.50.2018.04.27.18.48.07
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Apr 2018 18:48:07 -0700 (PDT)
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] nl80211: Reject disconnect commands except from conn_owner
Date: Sat, 28 Apr 2018 03:47:32 +0200
Message-Id: <20180428014732.4018-1-andrew.zaborowski@intel.com> (sfid-20180428_035025_399295_EC6E6D21)
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
---
 net/wireless/nl80211.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a910150f81..92ddc7d88f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8303,6 +8303,10 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 	const u8 *bssid, *ssid;
 	int err, ssid_len = 0;
 
+	if (dev->ieee80211_ptr->conn_owner_nlportid &&
+	    dev->ieee80211_ptr->conn_owner_nlportid != info->snd_portid)
+		return -EPERM;
+
 	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
 		return -EINVAL;
 
@@ -8425,6 +8429,10 @@ static int nl80211_deauthenticate(struct sk_buff *skb, struct genl_info *info)
 	u16 reason_code;
 	bool local_state_change;
 
+	if (dev->ieee80211_ptr->conn_owner_nlportid &&
+	    dev->ieee80211_ptr->conn_owner_nlportid != info->snd_portid)
+		return -EPERM;
+
 	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
 		return -EINVAL;
 
@@ -8472,6 +8480,10 @@ static int nl80211_disassociate(struct sk_buff *skb, struct genl_info *info)
 	u16 reason_code;
 	bool local_state_change;
 
+	if (dev->ieee80211_ptr->conn_owner_nlportid &&
+	    dev->ieee80211_ptr->conn_owner_nlportid != info->snd_portid)
+		return -EPERM;
+
 	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
 		return -EINVAL;
 
@@ -9234,6 +9246,10 @@ static int nl80211_disconnect(struct sk_buff *skb, struct genl_info *info)
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
