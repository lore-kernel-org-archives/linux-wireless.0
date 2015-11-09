Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:34918 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbbKIVCT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2015 16:02:19 -0500
Received: by wmdw130 with SMTP id w130so46195250wmd.0
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2015 13:02:18 -0800 (PST)
From: Ola Olsson <ola1olsson@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ola Olsson <ola1olsson@gmail.com>,
	Ola Olsson <ola.olsson@sonymobile.com>
Subject: [PATCH] cfg80211: ocb: Fix null pointer deref if join_ocb is unimplemented
Date: Mon,  9 Nov 2015 22:02:09 +0100
Message-Id: <1447102929-8906-1-git-send-email-ola1olsson@gmail.com> (sfid-20151109_220222_856318_92BCB776)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ola Olsson <ola.olsson@sonymobile.com>
---
 net/wireless/ocb.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/ocb.c b/net/wireless/ocb.c
index c00d4a7..e64dbf1 100644
--- a/net/wireless/ocb.c
+++ b/net/wireless/ocb.c
@@ -29,6 +29,9 @@ int __cfg80211_join_ocb(struct cfg80211_registered_device *rdev,
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_OCB)
 		return -EOPNOTSUPP;
 
+	if (!rdev->ops->join_ocb)
+		return -EOPNOTSUPP;
+
 	if (WARN_ON(!setup->chandef.chan))
 		return -EINVAL;
 
-- 
1.7.9.5

