Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:35932 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751161Ab2ECH0B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 03:26:01 -0400
Received: by lbgc1 with SMTP id c1so85825lbg.29
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 00:25:59 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: dcb314@hotmail.com, Luciano Coelho <coelho@ti.com>
Subject: [PATCH] wlcore: fix memset sizes in wl1271_cmd_build_arp_rsp()
Date: Thu,  3 May 2012 10:25:51 +0300
Message-Id: <1336029951-28745-1-git-send-email-coelho@ti.com> (sfid-20120503_092606_659611_49E1A79E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were using the size of the pointer and not of the allocate
structure itself in this function.  Use the size of the structure
instead.

Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 5c4716c..9f1c431 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -1034,7 +1034,7 @@ int wl1271_cmd_build_arp_rsp(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	skb_reserve(skb, sizeof(*hdr) + WL1271_EXTRA_SPACE_MAX);
 
 	tmpl = (struct wl12xx_arp_rsp_template *)skb_put(skb, sizeof(*tmpl));
-	memset(tmpl, 0, sizeof(tmpl));
+	memset(tmpl, 0, sizeof(*tmpl));
 
 	/* llc layer */
 	memcpy(tmpl->llc_hdr, rfc1042_header, sizeof(rfc1042_header));
@@ -1083,7 +1083,7 @@ int wl1271_cmd_build_arp_rsp(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 
 	/* mac80211 header */
 	hdr = (struct ieee80211_hdr_3addr *)skb_push(skb, sizeof(*hdr));
-	memset(hdr, 0, sizeof(hdr));
+	memset(hdr, 0, sizeof(*hdr));
 	fc = IEEE80211_FTYPE_DATA | IEEE80211_FCTL_TODS;
 	if (wlvif->sta.qos)
 		fc |= IEEE80211_STYPE_QOS_DATA;
-- 
1.7.10

