Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:38558 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab3EWDSF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 May 2013 23:18:05 -0400
Received: by mail-pb0-f45.google.com with SMTP id mc17so2391193pbc.32
        for <linux-wireless@vger.kernel.org>; Wed, 22 May 2013 20:18:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1367922058.8328.2.camel@jlt4.sipsolutions.net>
References: <1367238384-26722-1-git-send-email-johannes@sipsolutions.net>
	<51823A0E.8020005@broadcom.com>
	<1367489163.8298.2.camel@jlt4.sipsolutions.net>
	<5182BBD4.9010701@broadcom.com>
	<1367922058.8328.2.camel@jlt4.sipsolutions.net>
Date: Thu, 23 May 2013 11:18:05 +0800
Message-ID: <CAFuUQkgTbf0959=xCUCA1AR-Vxv7Cj90GC4Ae7+BQUqme70ksQ@mail.gmail.com> (sfid-20130523_051809_821793_2FA0BAFB)
Subject: Re: [RFC v4] cfg80211: Android P2P-Device workaround
From: YanBo <dreamfly281@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After create the p2p0  wireless device. When call the
cfg80211_conn_work, it will crash cause this function will use
wdev->netdev which is invalid, below patch will skip the further
operation  when get the info if the wireless
device is P2P device. please review, thanks.

BR /Yanbo

From: Yanbo Li <dreamfly281@gmail.com>
Date: Thu, 23 May 2013 11:05:20 +0800
Subject: [PATCH] Add the P2P device condition at cfg80211_conn_work to avoid
 crash

Signed-off-by: Yanbo Li <dreamfly281@gmail.com>
---
 net/wireless/sme.c               |    6 ++++++
 1 files changed, 6 insertions(+)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 8019b39..232194c 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -232,6 +232,12 @@ void cfg80211_conn_work(struct work_struct *work)

     list_for_each_entry(wdev, &rdev->wdev_list, list) {
         wdev_lock(wdev);
+#ifdef CONFIG_CFG80211_ANDROID_P2P_HACK
+        if (wdev->iftype == NL80211_IFTYPE_P2P_DEVICE) {
+            wdev_unlock(wdev);
+            continue;
+        }
+#endif
         if (!netif_running(wdev->netdev)) {
             wdev_unlock(wdev);
             continue;
--
1.7.9.5
