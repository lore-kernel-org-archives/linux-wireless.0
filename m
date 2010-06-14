Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:39370 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab0FNGQN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 02:16:13 -0400
From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Subject: [PATCH 2/3] mac80211: Set changed basic rates flag
Date: Mon, 14 Jun 2010 09:15:44 +0300
Message-Id: <1276496145-5623-3-git-send-email-ext-teemu.3.paasikivi@nokia.com>
In-Reply-To: <1276496145-5623-2-git-send-email-ext-teemu.3.paasikivi@nokia.com>
References: <1276496145-5623-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
 <1276496145-5623-2-git-send-email-ext-teemu.3.paasikivi@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add changed basic rates flag to bss_changed while joinig ibss network.

This patch is split from the patch containing support for setting basic
rates when creating ibss network. Original patch was posted by Johannes
Berg on the linux-wireless posting list.

Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
---
 net/mac80211/ibss.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 8be5a96..ff91265 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -178,6 +178,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	bss_change |= BSS_CHANGED_BSSID;
 	bss_change |= BSS_CHANGED_BEACON;
 	bss_change |= BSS_CHANGED_BEACON_ENABLED;
+	bss_change |= BSS_CHANGED_BASIC_RATES;
 	bss_change |= BSS_CHANGED_IBSS;
 	sdata->vif.bss_conf.ibss_joined = true;
 	ieee80211_bss_info_change_notify(sdata, bss_change);
-- 
1.5.6.3

