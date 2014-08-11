Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:48327 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbaHKSwJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2014 14:52:09 -0400
Received: by mail-we0-f176.google.com with SMTP id q58so8963339wes.7
        for <linux-wireless@vger.kernel.org>; Mon, 11 Aug 2014 11:52:08 -0700 (PDT)
From: chaitanya.mgit@gmail.com
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Chaitanya T K <chaitanya.mgit@gmail.com>
Subject: [mac80211] Enforce protected check for unicast robust management frames.
Date: Tue, 12 Aug 2014 00:21:54 +0530
Message-Id: <1407783114-5469-1-git-send-email-chaitanya.mgit@gmail.com> (sfid-20140811_205215_652447_3F2B8A2B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaitanya T K <chaitanya.mgit@gmail.com>

Enforce the check for protected field for all unicast 
robust management frames. 

Signed-off-by: Chaitanya T K <chaitanya.mgit@gmail.com>
---

This removed the dependency on the driver to check for protected
bit, especially for those drivers who believed the API :-).

---

 net/mac80211/rx.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index a8d862f..63e8f3d 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -569,6 +569,9 @@ static int ieee80211_is_unicast_robust_mgmt_frame(struct sk_buff *skb)
 	if (is_multicast_ether_addr(hdr->addr1))
 		return 0;
 
+	if (!ieee80211_has_protected(hdr->frame_control))
+		return 0;
+
 	return ieee80211_is_robust_mgmt_frame(skb);
 }
 
