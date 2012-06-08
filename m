Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40762 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760089Ab2FHCVf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 22:21:35 -0400
Received: by pbbrp8 with SMTP id rp8so1891876pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 19:21:35 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	javier@cozybit.com, devel@lists.open80211s.org,
	Ashok Nagarajan <ashok@cozybit.com>
Subject: [PATCH 2/3] mac80211: set IEEE80211_SDATA_OPERATING_GMODE in mesh if operating in G band
Date: Thu,  7 Jun 2012 19:21:25 -0700
Message-Id: <1339122086-23190-2-git-send-email-ashok@cozybit.com> (sfid-20120608_042141_144656_725BA593)
In-Reply-To: <1339122086-23190-1-git-send-email-ashok@cozybit.com>
References: <1339122086-23190-1-git-send-email-ashok@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
---
 net/mac80211/mesh.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 7cf1950..2b814d5 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -581,6 +581,19 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_rate *bitrates;
+	enum  ieee80211_band band = local->hw.conf.channel->band;
+	int i;
+
+	sband = local->hw.wiphy->bands[band];
+	bitrates = sband->bitrates;
+	for (i = 0; i < sband->n_bitrates; i++)
+		if (band == IEEE80211_BAND_2GHZ &&
+		    bitrates[i].bitrate > 110) {
+			sdata->flags |= IEEE80211_SDATA_OPERATING_GMODE;
+			break;
+		}
 
 	local->fif_other_bss++;
 	/* mesh ifaces must set allmulti to forward mcast traffic */
-- 
1.7.5.4

