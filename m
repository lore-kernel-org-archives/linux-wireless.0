Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:59438 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751537AbeA3HnO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Jan 2018 02:43:14 -0500
Message-ID: <1517298191.2189.33.camel@sipsolutions.net> (sfid-20180130_084318_597654_0E45C291)
Subject: Re: [PATCH 1/2] wireless: set correct mandatory rate flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Matthias Schiffer <mschiffer@universe-factory.net>,
        Richard =?ISO-8859-1?Q?Sch=FCtz?= <rschuetz@uni-koblenz.de>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 30 Jan 2018 08:43:11 +0100
In-Reply-To: <2f3b9bd7-f083-f46c-8c47-051019a6f495@universe-factory.net>
References: <20170907154744.28357-1-rschuetz@uni-koblenz.de>
         <2f3b9bd7-f083-f46c-8c47-051019a6f495@universe-factory.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-01-26 at 23:17 +0100, Matthias Schiffer wrote:
> 
> I propose to revert this for now (I assume it's too late for 4.15, but
> hopefully the regression can be fixed in 4.15.1).

I really don't think we should revert this, it fixes a real bug.

We can easily switch the default though, would something like this
help?

diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 51aa55618ef7..b12da6ef3c12 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -170,9 +170,28 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 		enum nl80211_bss_scan_width scan_width;
 		struct ieee80211_supported_band *sband =
 				rdev->wiphy.bands[setup->chandef.chan->band];
-		scan_width = cfg80211_chandef_to_scan_width(&setup->chandef);
-		setup->basic_rates = ieee80211_mandatory_rates(sband,
-							       scan_width);
+
+		if (setup->chandef.chan->band == NL80211_BAND_2GHZ) {
+			int i;
+
+			/*
+			 * Older versions selected the mandatory rates for
+			 * 2.4 GHz as well, but were broken in that only
+			 * 1 Mbps was regarded as a mandatory rate. Keep
+			 * using just 1 Mbps as the default basic rate for
+			 * mesh to be interoperable with older versions.
+			 */
+			for (i = 0; i < sband->n_bitrates; i++) {
+				if (sband->bitrates[i].bitrate == 10) {
+					setup->basic_rates = BIT(i);
+					break;
+				}
+			}
+		} else {
+			scan_width = cfg80211_chandef_to_scan_width(&setup->chandef);
+			setup->basic_rates = ieee80211_mandatory_rates(sband,
+								       scan_width);
+		}
 	}
 
 	err = cfg80211_chandef_dfs_required(&rdev->wiphy,

johannes
