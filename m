Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:45095 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbYAYBSZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 20:18:25 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Jory A. Pratt" <geekypenguin@gmail.com>
Subject: Re: mac80211 breakage on broadcom hardware.
Date: Fri, 25 Jan 2008 02:17:43 +0100
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <479935C3.7050403@gmail.com>
In-Reply-To: <479935C3.7050403@gmail.com>
MIME-Version: 1.0
Message-Id: <200801250217.44164.mb@bu3sch.de> (sfid-20080125_011829_706635_902B422B)
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 25 January 2008, Jory A. Pratt wrote:
> 921dda3b092b3d47c9b715d02be0c2615c8d7aa8


Hm, I'm not sure this hunk is correct.


@@ -3194,44 +3223,47 @@ void ieee80211_sta_scan_work(struct work_struct *work)
 
 	switch (local->scan_state) {
 	case SCAN_SET_CHANNEL:
-		mode = local->scan_hw_mode;
-		if (local->scan_hw_mode->list.next == &local->modes_list &&
-		    local->scan_channel_idx >= mode->num_channels) {
+		/* get current scan band */
+		if (local->scan_band < IEEE80211_NUM_BANDS)
+			sband = local->hw.wiphy->bands[local->scan_band];
+		else
+			sband = NULL;
+
+		/* if we started at an unsupported one, advance */
+		while (!sband && local->scan_band < IEEE80211_NUM_BANDS) {
+			local->scan_band++;
+			sband = local->hw.wiphy->bands[local->scan_band];
+			local->scan_channel_idx = 0;
+		}

What are we doing here?
b43 does only define one band (2.4GHz) currently. Is it possible that this code
selects the uninitialized 5GHz band structure?

+
+		if (!sband ||
+		    (local->scan_channel_idx >= sband->n_channels &&
+		     local->scan_band >= IEEE80211_NUM_BANDS)) {
 			ieee80211_scan_completed(local_to_hw(local));
 			return;
 		}
-		skip = !(local->enabled_modes & (1 << mode->mode));
-		chan = &mode->channels[local->scan_channel_idx];
-		if (!(chan->flag & IEEE80211_CHAN_W_SCAN) ||
+		skip = 0;
+		chan = &sband->channels[local->scan_channel_idx];

If the above can happen, this would crash when using "chan".
