Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36222 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbZJ0Ty0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2009 15:54:26 -0400
Subject: [PATCH] mac80211_hwsim: don't register CCK rates on 5ghz
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Oct 2009 20:53:58 +0100
Message-ID: <1256673238.4237.22.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This buglet confused me a lot just now ...

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/mac80211_hwsim.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2009-10-27 20:52:53.000000000 +0100
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2009-10-27 20:52:56.000000000 +0100
@@ -1045,19 +1045,20 @@ static int __init init_mac80211_hwsim(vo
 				sband->channels = data->channels_2ghz;
 				sband->n_channels =
 					ARRAY_SIZE(hwsim_channels_2ghz);
+				sband->bitrates = data->rates;
+				sband->n_bitrates = ARRAY_SIZE(hwsim_rates);
 				break;
 			case IEEE80211_BAND_5GHZ:
 				sband->channels = data->channels_5ghz;
 				sband->n_channels =
 					ARRAY_SIZE(hwsim_channels_5ghz);
+				sband->bitrates = data->rates + 4;
+				sband->n_bitrates = ARRAY_SIZE(hwsim_rates) - 4;
 				break;
 			default:
 				break;
 			}
 
-			sband->bitrates = data->rates;
-			sband->n_bitrates = ARRAY_SIZE(hwsim_rates);
-
 			sband->ht_cap.ht_supported = true;
 			sband->ht_cap.cap = IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
 				IEEE80211_HT_CAP_GRN_FLD |


