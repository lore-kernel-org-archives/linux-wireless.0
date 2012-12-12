Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59851 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab2LLV4j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 16:56:39 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [RFC 4/6] mac80211: Allow disabling SGI-20.
Date: Wed, 12 Dec 2012 13:54:53 -0800
Message-Id: <1355349295-30960-4-git-send-email-greearb@candelatech.com> (sfid-20121212_225648_739548_AE867F17)
In-Reply-To: <1355349295-30960-1-git-send-email-greearb@candelatech.com>
References: <1355349295-30960-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This allows user-space (wpa_supplicant) to disable
short guard interval (SGI) for 20Mhz.  The SGI-40
disable option is already handled.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/mac80211/ht.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index a71d891..8a6d68f 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -62,6 +62,9 @@ void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
 	__check_htcap_disable(sdata, ht_cap, IEEE80211_HT_CAP_SUP_WIDTH_20_40);
 	__check_htcap_disable(sdata, ht_cap, IEEE80211_HT_CAP_SGI_40);
 
+	/* Allow user to disable SGI-20 (SGI-40 is handled above) */
+	__check_htcap_disable(sdata, ht_cap, IEEE80211_HT_CAP_SGI_20);
+
 	/* Allow user to disable the max-AMSDU bit. */
 	__check_htcap_disable(sdata, ht_cap, IEEE80211_HT_CAP_MAX_AMSDU);
 
-- 
1.7.3.4

