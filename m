Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:17025 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751608AbYG3PUV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 11:20:21 -0400
From: Bruno Randolf <br1@einfach.org>
Subject: [PATCH 2/3] mac80211: radiotap: assume modulation from rates
To: tomas.winkler@intel.com
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Wed, 30 Jul 2008 17:20:06 +0200
Message-ID: <20080730152006.24487.6932.stgit@void> (sfid-20080730_172023_298536_FB39687D)
In-Reply-To: <20080730151955.24487.76871.stgit@void>
References: <20080730151955.24487.76871.stgit@void>
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
index 254462f..a67ded3 100644
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
 

