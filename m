Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35941 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754290AbcKXEqU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 23:46:20 -0500
From: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Date: Wed, 23 Nov 2016 20:46:14 -0800
To: Johannes Berg <johannes.berg@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Marek Kwaczynski <marek.kwaczynski@tieto.com>,
        David Spinadel <david.spinadel@intel.com>,
        Alexander Bondar <alexander.bondar@intel.com>,
        Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/4] mac80211: Removed unused 'struct
 ieee80211_supported_band*' variable
Message-ID: <a8fcdffb1e209afc5148bec8ba6229fcc8dd50af.1479962513.git.kirtika@chromium.org> (sfid-20161124_054625_895987_FD7E78DE)
References: <cover.1479962513.git.kirtika@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <cover.1479962513.git.kirtika@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit b1bce14a7954 (mac80211: update opmode when adding new station)
refactored ieee80211_vht_handle_opmode into __ieee80211_vht_handle_opmode
and ieee80211_vht_handle_opmode leaving a set but unused variable
(sband) in the former. Compiling with W=1 gives the following warning,
fix it.

net/mac80211/vht.c: In function ‘__ieee80211_vht_handle_opmode’:
net/mac80211/vht.c:424:35: warning: variable ‘sband’ set but not used [-Wunused-but-set-variable]

Remove 'struct ieee80211_local* local' as well, it was only used to
set sband.

This is a harmless warning, and is only being fixed to reduce the
noise with W=1 in the kernel.

Fixes: b1bce14a7954 ("mac80211: update opmode when adding new station")
Cc: Marek Kwaczynski <marek.kwaczynski@tieto.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kirtika Ruchandani <kirtika@chromium.org>
---
 net/mac80211/vht.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index ee71576..14920e3 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -420,14 +420,10 @@ u32 __ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 				  struct sta_info *sta, u8 opmode,
 				  enum nl80211_band band)
 {
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_supported_band *sband;
 	enum ieee80211_sta_rx_bandwidth new_bw;
 	u32 changed = 0;
 	u8 nss;
 
-	sband = local->hw.wiphy->bands[band];
-
 	/* ignore - no support for BF yet */
 	if (opmode & IEEE80211_OPMODE_NOTIF_RX_NSS_TYPE_BF)
 		return 0;
-- 
2.8.0.rc3.226.g39d4020
