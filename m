Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:38507 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295AbbKYN7a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2015 08:59:30 -0500
Received: by wmec201 with SMTP id c201so71305785wme.1
        for <linux-wireless@vger.kernel.org>; Wed, 25 Nov 2015 05:59:29 -0800 (PST)
From: Sven Eckelmann <sven@open-mesh.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Julian Calaby <julian.calaby@gmail.com>,
	Sven Eckelmann <sven@open-mesh.com>
Subject: [PATCH v3 2/4] iw: add VHT80 support for 802.11s
Date: Wed, 25 Nov 2015 14:59:16 +0100
Message-Id: <1448459959-23641-2-git-send-email-sven@open-mesh.com> (sfid-20151125_145933_213473_06142314)
In-Reply-To: <1448459959-23641-1-git-send-email-sven@open-mesh.com>
References: <1448459959-23641-1-git-send-email-sven@open-mesh.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iw mesh supports non-HT and HT channel widths like HT20 or NOHT. But the
Linux 802.11s implementation also supports VHT80 which can be specified
during the mesh join.

    iw dev mesh0 mesh join "meshnet" freq 5180 80MHz

Signed-off-by: Sven Eckelmann <sven@open-mesh.com>
---
v3:
 * split patch into two different patches (0001/0002) as request by
   Julian Calaby <julian.calaby@gmail.com>
 * change join_ocb to also use get_cf1
 * move NOHT to the last entry in the mesh/ibss join usage texts as
   requested by Julian Calaby <julian.calaby@gmail.com>
v2:
 * rebase from v4.3-ish version to current master

 mesh.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mesh.c b/mesh.c
index 593ab7a..d674d61 100644
--- a/mesh.c
+++ b/mesh.c
@@ -466,6 +466,10 @@ static int join_mesh(struct nl80211_state *state,
 		  .width = NL80211_CHAN_WIDTH_20_NOHT,
 		  .freq1_diff = 0,
 		  .chantype = NL80211_CHAN_NO_HT },
+		{ .name = "80MHz",
+		  .width = NL80211_CHAN_WIDTH_80,
+		  .freq1_diff = 0,
+		  .chantype = -1 },
 	};
 
 	if (argc < 1)
@@ -604,7 +608,7 @@ static int join_mesh(struct nl80211_state *state,
  nla_put_failure:
 	return -ENOBUFS;
 }
-COMMAND(mesh, join, "<mesh ID> [[freq <freq in MHz> <HT20|HT40+|HT40-|NOHT>]"
+COMMAND(mesh, join, "<mesh ID> [[freq <freq in MHz> <HT20|HT40+|HT40-|NOHT|80MHz>]"
 	" [basic-rates <rate in Mbps,rate2,...>]], [mcast-rate <rate in Mbps>]"
 	" [beacon-interval <time in TUs>] [dtim-period <value>]"
 	" [vendor_sync on|off] [<param>=<value>]*",
-- 
2.6.2

