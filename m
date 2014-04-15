Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:58724 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399AbaDOOoG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2014 10:44:06 -0400
Received: by mail-ob0-f182.google.com with SMTP id uz6so10962764obc.27
        for <linux-wireless@vger.kernel.org>; Tue, 15 Apr 2014 07:44:05 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/3] mac80211: fix mesh_add_rsn_ie IE finding loop
Date: Tue, 15 Apr 2014 10:43:07 -0400
Message-Id: <1397572988-3181-2-git-send-email-me@bobcopeland.com> (sfid-20140415_164417_430765_43B7E70F)
In-Reply-To: <1397572988-3181-1-git-send-email-me@bobcopeland.com>
References: <1397572988-3181-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously, the code to copy the RSN IE from the mesh config
would increment its pointer by one in the loop instead of by
the element length, so there was the potential for mistaking
another IE's data fields as the RSN IE.

cfg80211_find_ie() exists, so just use that.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 net/mac80211/mesh.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 9d29237..b06ddc9 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -366,20 +366,15 @@ int mesh_add_rsn_ie(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 		return 0;
 
 	/* find RSN IE */
-	data = ifmsh->ie;
-	while (data < ifmsh->ie + ifmsh->ie_len) {
-		if (*data == WLAN_EID_RSN) {
-			len = data[1] + 2;
-			break;
-		}
-		data++;
-	}
+	data = cfg80211_find_ie(WLAN_EID_RSN, ifmsh->ie, ifmsh->ie_len);
+	if (!data)
+		return 0;
 
-	if (len) {
-		if (skb_tailroom(skb) < len)
-			return -ENOMEM;
-		memcpy(skb_put(skb, len), data, len);
-	}
+	len = data[1] + 2;
+
+	if (skb_tailroom(skb) < len)
+		return -ENOMEM;
+	memcpy(skb_put(skb, len), data, len);
 
 	return 0;
 }
-- 
1.9.1

