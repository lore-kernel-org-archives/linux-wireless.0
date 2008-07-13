Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-80-86-92-145.inaddr.intergenia.de ([80.86.92.145]:41658
	"EHLO home.einfach.org" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756132AbYGMWpn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jul 2008 18:45:43 -0400
From: Bruno Randolf <br1@einfach.org>
Subject: [PATCH 2/2] mac80211: radiotap: assume modulation from rates
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	tomasw@gmail.com, yi.zhu@intel.com
Date: Mon, 14 Jul 2008 00:20:32 +0200
Message-ID: <20080713222032.16732.15860.stgit@void> (sfid-20080714_004607_289187_6B6A7171)
In-Reply-To: <20080713222026.16732.9011.stgit@void>
References: <20080713222026.16732.9011.stgit@void>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

use the rates ERP flag to derive CCK or OFDM modulation for the radiotap
header.

(it might be more correct to get this information from the hardware itself, but it
seems safe to assume this in most practical cases.)

Signed-off-by: Bruno Randolf <br1@einfach.org>
---

 net/mac80211/rx.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5131ee2..f8c95a1 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -157,8 +157,11 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	if (status->band == IEEE80211_BAND_5GHZ)
 		*(__le16 *)pos = cpu_to_le16(IEEE80211_CHAN_OFDM |
 					     IEEE80211_CHAN_5GHZ);
+	else if (rate->flags & IEEE80211_RATE_ERP_G)
+		*(__le16 *)pos = cpu_to_le16(IEEE80211_CHAN_OFDM |
+					     IEEE80211_CHAN_2GHZ);
 	else
-		*(__le16 *)pos = cpu_to_le16(IEEE80211_CHAN_DYN |
+		*(__le16 *)pos = cpu_to_le16(IEEE80211_CHAN_CCK |
 					     IEEE80211_CHAN_2GHZ);
 	pos += 2;
 

