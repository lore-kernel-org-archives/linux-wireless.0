Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754321Ab1KCJl0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 05:41:26 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2/3] mac80211: remove useless brackets in ieee80211_cfg_on_oper_channel
Date: Thu,  3 Nov 2011 10:40:46 +0100
Message-Id: <1320313247-23167-2-git-send-email-sgruszka@redhat.com> (sfid-20111103_104128_854523_1EEFF4DC)
In-Reply-To: <1320313247-23167-1-git-send-email-sgruszka@redhat.com>
References: <1320313247-23167-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 7710b10..cd87fd9 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -126,8 +126,8 @@ bool ieee80211_cfg_on_oper_channel(struct ieee80211_local *local)
 		return false;
 
 	/* Check current hardware-config against oper_channel. */
-	if ((local->oper_channel != local->hw.conf.channel) ||
-	    (local->_oper_channel_type != local->hw.conf.channel_type))
+	if (local->oper_channel != local->hw.conf.channel ||
+	    local->_oper_channel_type != local->hw.conf.channel_type)
 		return false;
 
 	return true;
-- 
1.7.1

