Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from contumacia.investici.org ([178.255.144.35]:59990 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab2KGLxF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2012 06:53:05 -0500
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <ordex@autistici.org>
Subject: [PATCH 2/2] nl80211: send the NL80211_ATTR_SSID in nl80211_send_iface()
Date: Wed,  7 Nov 2012 12:52:20 +0100
Message-Id: <1352289140-20515-2-git-send-email-ordex@autistici.org> (sfid-20121107_125318_845912_8C608811)
In-Reply-To: <1352289140-20515-1-git-send-email-ordex@autistici.org>
References: <1352289140-20515-1-git-send-email-ordex@autistici.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The userspace may want to know what is the current ssid that a given
interface is using. This patch enables nl80211 to send the
NL80211_ATTR_SSID attribute in nl80211_send_iface().

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---
 net/wireless/nl80211.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e521ca0..c18b2fc 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1787,6 +1787,11 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flag
 			goto nla_put_failure;
 	}
 
+	if (wdev->ssid_len) {
+		if (nla_put(msg, NL80211_ATTR_SSID, wdev->ssid_len, wdev->ssid))
+			goto nla_put_failure;
+	}
+
 	return genlmsg_end(msg, hdr);
 
  nla_put_failure:
-- 
1.8.0

