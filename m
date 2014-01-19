Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:35576 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbaASVX2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jan 2014 16:23:28 -0500
Received: by mail-ea0-f181.google.com with SMTP id m10so2751262eaj.40
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jan 2014 13:23:27 -0800 (PST)
From: andrea merello <andrea.merello@gmail.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: Larry.Finger@lwfinger.net,
	andrea merello <andrea.merello@gmail.com>
Subject: [PATCH] mac80211: add check on hw->max_signal value on ieee80211_register_hw
Date: Sun, 19 Jan 2014 22:21:49 +0100
Message-Id: <1390166509-3992-1-git-send-email-andrea.merello@gmail.com> (sfid-20140119_222350_487679_17C01C40)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When IEEE80211_HW_SIGNAL_UNSPEC is set, mac80211 will perform a
division by max_signal in ieee80211_bss_info_update. If max_signal
is not properly set by the driver (for example it is zero) this
leads to a divide error and crash.
Thanks to Larry Finger, who pointed me to this.
This patch adds in ieee80211_register_hw one more check to detect
this condition and eventually returns -EINVAL, as already done for
other checks already performed there.

Signed-off-by: andrea merello <andrea.merello@gmail.com>
---
 net/mac80211/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index d767cfb..913307a 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -758,6 +758,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	     local->hw.offchannel_tx_hw_queue >= local->hw.queues))
 		return -EINVAL;
 
+	if (hw->flags & IEEE80211_HW_SIGNAL_UNSPEC && hw->max_signal <= 0)
+		return -EINVAL;
+
 #ifdef CONFIG_PM
 	if (hw->wiphy->wowlan && (!local->ops->suspend || !local->ops->resume))
 		return -EINVAL;
-- 
1.8.3.2

