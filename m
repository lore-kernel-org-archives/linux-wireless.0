Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:55723 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234Ab0LOTmw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 14:42:52 -0500
From: Paul Stewart <pstew@google.com>
Date: Wed, 15 Dec 2010 10:54:01 -0800
Subject: [PATCH] mac80211: Push idle state to driver before stop
To: linux-wireless@vger.kernel.org
Cc: luis.rodriguez@atheros.com, johannes@sipsolutions.net
Message-Id: <20101215194246.D5FCE204D8@glenhelen.mtv.corp.google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes mac80211 doesn't push idle state downwards to the
driver.  Specifically, there are times in some functions where
the "local->hw.conf.flags & IEEE80211_CONF_IDLE" may change but
the equivalent of "drv_config(local, IEEE80211_CONF_CHANGE_IDLE)"
does not end up being called.  This is usually not all that
problematic except, for example, suspending and resuming an idle
ath9k device.  If the device isn't marked idle when
ieee80211_stop_device() is called, the device never gets put to
sleep, and will end up in an unresponsive state on resume.

As a precaution, explicitly call drv_config() before
ieee80211_stop_device(), which should be a no-op under normal
circumstances, but where this problem arises, it will shut down
the ath9k where necessary.

One example where this problem occurs is when I down an interface
while a scan is in progress on ath9k.  If the device was not shut
down correctly and the system suspends and resumes repeatedly with
ath9k, I end up with a fatal register read error (0x7000/deadbeef)
when trying to bring the interface back up.

Signed-off-by: Paul Stewart <pstew@google.com>
---
 net/mac80211/iface.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index b6db237..5af5a89 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -536,6 +536,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		if (local->ops->napi_poll)
 			napi_disable(&local->napi);
 		ieee80211_clear_tx_pending(local);
+		drv_config(local, IEEE80211_CONF_CHANGE_IDLE);
 		ieee80211_stop_device(local);
 
 		/* no reconfiguring after stop! */
-- 
1.7.3.1

