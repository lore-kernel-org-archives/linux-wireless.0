Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:39654 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263Ab1EZIqW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2011 04:46:22 -0400
Received: by wwk4 with SMTP id 4so4214567wwk.1
        for <linux-wireless@vger.kernel.org>; Thu, 26 May 2011 01:46:21 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: clear local->ps_data on disassoc
Date: Thu, 26 May 2011 11:46:37 +0300
Message-Id: <1306399597-15012-1-git-send-email-eliad@wizery.com> (sfid-20110526_104626_451502_760D3388)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

local->ps_data wasn't cleared on disassociation, which
(in some corner cases) caused reconnections to enter
psm before association completed.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/mlme.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 4f6b267..d595265 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1089,6 +1089,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
 		config_changed |= IEEE80211_CONF_CHANGE_PS;
 	}
+	local->ps_sdata = NULL;
 
 	ieee80211_hw_config(local, config_changed);
 
-- 
1.7.0.4

