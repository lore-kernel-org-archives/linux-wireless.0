Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35798 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211AbbESMhQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 08:37:16 -0400
Received: by wgfl8 with SMTP id l8so16204468wgf.2
        for <linux-wireless@vger.kernel.org>; Tue, 19 May 2015 05:37:14 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/2] cfg80211: ignore netif running state when changing iftype
Date: Tue, 19 May 2015 14:37:00 +0200
Message-Id: <1432039021-29666-1-git-send-email-michal.kazior@tieto.com> (sfid-20150519_143720_740293_0B16DAD3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This isn't a revert of f8cdddb8d61d ("cfg80211:
check iface combinations only when iface is
running") as far as functionality is considred
because b6a550156bc ("cfg80211/mac80211: move more
combination checks to mac80211") moved the logic
somewhere else.

It was possible for mac80211 to be coerced into an
unexpected flow causing sdata union to become
corrupted. Station pointer was put into
sdata->u.vlan.sta memory location while it was
really master AP's sdata->u.ap.next_beacon. This
led to station entry being later freed as CSA
beacon before __sta_info_flush() in
ieee80211_stop_ap() and a subsequent invalid
pointer dereference crash.

The problem was observed with the following test
steps:

 1. prepare 2 devices
 2. start hostapd AP with wds_sta=1
 3. connect client with 4addr
 4. disconnect
 5. swap roles & connect
 6. disconnect
    [ During AP (which was a client first)
      teardown kernel would crash. ]

Fixes: f8cdddb8d61d ("cfg80211: check iface combinations only when iface is running")
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/wireless/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 70051ab52f4f..7e4e3fffe7ce 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -944,7 +944,7 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 	     ntype == NL80211_IFTYPE_P2P_CLIENT))
 		return -EBUSY;
 
-	if (ntype != otype && netif_running(dev)) {
+	if (ntype != otype) {
 		dev->ieee80211_ptr->use_4addr = false;
 		dev->ieee80211_ptr->mesh_id_up_len = 0;
 		wdev_lock(dev->ieee80211_ptr);
-- 
2.1.4

