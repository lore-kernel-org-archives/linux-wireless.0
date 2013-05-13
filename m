Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp06.msg.oleane.net ([62.161.4.6]:59546 "EHLO
	smtp06.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab3EMMpi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 May 2013 08:45:38 -0400
From: "voncken" <cedric.voncken@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Cc: <johannes@sipsolutions.net>
References: <1366363242-29481-1-git-send-email-cedric.voncken@acksys.fr>
In-Reply-To: <1366363242-29481-1-git-send-email-cedric.voncken@acksys.fr>
Subject: RE: [PATCH] mac80211: Fix driver crash when STA_NOTIFY_AWAKE occures
Date: Mon, 13 May 2013 14:45:34 +0200
Message-ID: <01a401ce4fd7$c2e9d3b0$48bd7b10$@acksys.fr> (sfid-20130513_144542_752441_E55BB4DC)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This default occurs when I set a mesh interface with HT mode and SAE user
daemon from cozibit.

I have put more information in thread "ath9k null pointer with mesh network"
in the linux-wireless mailing list.

Cedric Voncken 

-----Message d'origine-----
De : linux-wireless-owner@vger.kernel.org
[mailto:linux-wireless-owner@vger.kernel.org] De la part de cedric voncken
Envoyé : vendredi 19 avril 2013 11:21
À : linux-wireless@vger.kernel.org
Cc : cedric voncken
Objet : [PATCH] mac80211: Fix driver crash when STA_NOTIFY_AWAKE occures

If the device uses the HT mode and receives a frame from a sta whith state <
IEEE80211_STA_ASSOC then the null pointer exception crashes the Linnux
kernel.

In the case of ath9k, the function ath_tx_node_init is indirectly called by
drv_sta_state (in net/mac80211/driver-ops.h) only when the sta_state goes to
IEEE80211_STA_ASSOC from IEEE80211_STA_AUTH.

Signed-off-by: cedric VONCKEN <cedric.voncken@acksys.fr>
---
 net/mac80211/sta_info.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c index
11216bc..bcfd7b0 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1040,7 +1040,8 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info
*sta)
 	BUILD_BUG_ON(BITS_TO_LONGS(IEEE80211_NUM_TIDS) > 1);
 	sta->driver_buffered_tids = 0;
 
-	if (!(local->hw.flags & IEEE80211_HW_AP_LINK_PS))
+	if (!(local->hw.flags & IEEE80211_HW_AP_LINK_PS &&
+			sta->sta_state >= IEEE80211_STA_ASSOC))
 		drv_sta_notify(local, sdata, STA_NOTIFY_AWAKE, &sta->sta);
 
 	skb_queue_head_init(&pending);
--
1.7.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html

