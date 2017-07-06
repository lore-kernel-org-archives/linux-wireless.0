Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:34295 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752718AbdGFWpI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 18:45:08 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Srinivas Dasari <dasaris@qti.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 3/4] cfg80211: Define nla_policy for NL80211_ATTR_LOCAL_MESH_POWER_MODE
Date: Fri, 7 Jul 2017 01:43:41 +0300
Message-ID: <1499381022-5389-3-git-send-email-jouni@qca.qualcomm.com> (sfid-20170707_004512_043337_55159EC5)
In-Reply-To: <1499381022-5389-1-git-send-email-jouni@qca.qualcomm.com>
References: <1499381022-5389-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Srinivas Dasari <dasaris@qti.qualcomm.com>

Buffer overread may happen as nl80211_set_station() reads 4 bytes
from the attribute NL80211_ATTR_LOCAL_MESH_POWER_MODE without
validating the size of data received when userspace sends less
than 4 bytes of data with NL80211_ATTR_LOCAL_MESH_POWER_MODE.
Define nla_policy for NL80211_ATTR_LOCAL_MESH_POWER_MODE to avoid
the buffer overread.

Fixes: 3b1c5a5307f ("{cfg,nl}80211: mesh power mode primitives and userspace access")
Cc: stable@vger.kernel.org
Signed-off-by: Srinivas Dasari <dasaris@qti.qualcomm.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 net/wireless/nl80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index dcfeae0..0a63b95 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -347,6 +347,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_SCAN_FLAGS] = { .type = NLA_U32 },
 	[NL80211_ATTR_P2P_CTWINDOW] = { .type = NLA_U8 },
 	[NL80211_ATTR_P2P_OPPPS] = { .type = NLA_U8 },
+	[NL80211_ATTR_LOCAL_MESH_POWER_MODE] = {. type = NLA_U32 },
 	[NL80211_ATTR_ACL_POLICY] = {. type = NLA_U32 },
 	[NL80211_ATTR_MAC_ADDRS] = { .type = NLA_NESTED },
 	[NL80211_ATTR_STA_CAPABILITY] = { .type = NLA_U16 },
-- 
2.7.4
