Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38401 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab1A2BFv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 20:05:51 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 3/3] mac80211:  Warn users if HT fails because of freq mismatch.
Date: Fri, 28 Jan 2011 17:05:43 -0800
Message-Id: <1296263143-12404-3-git-send-email-greearb@candelatech.com>
In-Reply-To: <1296263143-12404-1-git-send-email-greearb@candelatech.com>
References: <1296263143-12404-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

I have a netgear WNDR3700 that appears to have an off-by-four
bug in how it fills out the hti->control_chan (I configure the
AP to channel 11, it reports 15 as control_chan).

Poke a message into the kernel logs to give users a
clue as to why they are not getting the expected
channel-type or rate.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 3221069... 7daabbe... M	net/mac80211/mlme.c
 net/mac80211/mlme.c |   26 ++++++++++++++++++++++----
 1 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 3221069..7daabbe 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -161,6 +161,7 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_supported_band *sband;
 	struct sta_info *sta;
 	u32 changed = 0;
+	int hti_cfreq;
 	u16 ht_opmode;
 	bool enable_ht = true;
 	enum nl80211_channel_type prev_chantype;
@@ -174,10 +175,27 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 	if (!sband->ht_cap.ht_supported)
 		enable_ht = false;
 
-	/* check that channel matches the right operating channel */
-	if (local->hw.conf.channel->center_freq !=
-	    ieee80211_channel_to_frequency(hti->control_chan, sband->band))
-		enable_ht = false;
+	if (enable_ht) {
+		hti_cfreq = ieee80211_channel_to_frequency(hti->control_chan,
+							   sband->band);
+		/* check that channel matches the right operating channel */
+		if (local->hw.conf.channel->center_freq != hti_cfreq) {
+			/* Some APs mess this up, evidently.
+			 * Netgear WNDR3700 sometimes reports 4 higher than
+			 * the actual channel, for instance.
+			 */
+			printk(KERN_DEBUG
+			       "%s: Wrong control channel in association"
+			       " response: configured center-freq: %d"
+			       " hti-cfreq: %d  hti->control_chan: %d"
+			       " band: %d.  Disabling HT.\n",
+			       sdata->name,
+			       local->hw.conf.channel->center_freq,
+			       hti_cfreq, hti->control_chan,
+			       sband->band);
+			enable_ht = false;
+		}
+	}
 
 	if (enable_ht) {
 		channel_type = NL80211_CHAN_HT20;
-- 
1.7.2.3

