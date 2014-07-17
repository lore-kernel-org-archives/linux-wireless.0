Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:64397 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933849AbaGQOOW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2014 10:14:22 -0400
Received: by mail-we0-f170.google.com with SMTP id w62so3136676wes.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2014 07:14:21 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 12/15] mac80211: disable VHT for TDLS
Date: Thu, 17 Jul 2014 17:14:28 +0300
Message-Id: <1405606471-30128-13-git-send-email-arik@wizery.com> (sfid-20140717_161446_016306_6AF0E4DD)
In-Reply-To: <1405606471-30128-1-git-send-email-arik@wizery.com>
References: <1405606471-30128-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

TDLS VHT support requires some more information elements during setup.
While these are not there, mask out the peer's VHT capabilities so that
VHT rates are not mistakenly used.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/vht.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index 9265adf..671ce0d 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -129,6 +129,10 @@ ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 	if (!vht_cap_ie || !sband->vht_cap.vht_supported)
 		return;
 
+	/* don't support VHT for TDLS peers for now */
+	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER))
+		return;
+
 	/*
 	 * A VHT STA must support 40 MHz, but if we verify that here
 	 * then we break a few things - some APs (e.g. Netgear R6300v2
-- 
1.9.1

