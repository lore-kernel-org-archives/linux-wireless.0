Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:39355 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbaBJLsE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 06:48:04 -0500
Received: by mail-we0-f173.google.com with SMTP id x55so4080052wes.4
        for <linux-wireless@vger.kernel.org>; Mon, 10 Feb 2014 03:48:02 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 13/18] wlcore: don't handle unsetting of default wep key
Date: Mon, 10 Feb 2014 13:47:29 +0200
Message-Id: <1392032854-28126-14-git-send-email-eliad@wizery.com> (sfid-20140210_130007_595353_EECF3A5C)
In-Reply-To: <1392032854-28126-1-git-send-email-eliad@wizery.com>
References: <1392032854-28126-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 unsets the default wep key on disassoc.
The fw doesn't support this notification, so simply
ignore it.

The actual flow actually triggers fw recovery in some
cases, as mac80211 unsets the default key only after
disassoc, when wlvif->sta.hlid, resulting in invalid
hlid being passed to the fw.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index bea2938..d80d40c 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -3472,6 +3472,10 @@ static void wl1271_op_set_default_key_idx(struct ieee80211_hw *hw,
 	wl1271_debug(DEBUG_MAC80211, "mac80211 set default key idx %d",
 		     key_idx);
 
+	/* we don't handle unsetting of default key */
+	if (key_idx == -1)
+		return;
+
 	mutex_lock(&wl->mutex);
 
 	if (unlikely(wl->state != WLCORE_STATE_ON)) {
-- 
1.8.5.2.229.g4448466.dirty

