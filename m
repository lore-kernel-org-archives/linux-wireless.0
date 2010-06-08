Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:28661 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab0FHMeo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jun 2010 08:34:44 -0400
From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Subject: [RFC 2/3] mac80211: Set changed basic rates flag
Date: Tue,  8 Jun 2010 15:34:18 +0300
Message-Id: <1276000459-1121-3-git-send-email-ext-teemu.3.paasikivi@nokia.com>
In-Reply-To: <1276000459-1121-2-git-send-email-ext-teemu.3.paasikivi@nokia.com>
References: <1276000459-1121-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
 <1276000459-1121-2-git-send-email-ext-teemu.3.paasikivi@nokia.com>
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
index 8be5a96..d984ab2 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -179,6 +179,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	bss_change |= BSS_CHANGED_BEACON;
 	bss_change |= BSS_CHANGED_BEACON_ENABLED;
 	bss_change |= BSS_CHANGED_IBSS;
+	bss_change |= BSS_CHANGED_BASIC_RATES;
 	sdata->vif.bss_conf.ibss_joined = true;
 	ieee80211_bss_info_change_notify(sdata, bss_change);
 
-- 
1.5.6.3

