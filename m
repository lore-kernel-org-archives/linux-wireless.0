Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:47222 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755666Ab3BMEtq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 23:49:46 -0500
Date: Wed, 13 Feb 2013 10:08:33 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] iw: Add VHT info in link query
Message-ID: <20130213043833.GA842@markyou.marvell.com> (sfid-20130213_054950_071209_98B0F769)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Show VHT mcs, nss and bw, if present, in
iw dev link.

Eg.,
Connected to 10:6f:3f:4d:94:b4 (on mlan0)
        SSID: 122920
        freq: 5180
        RX: 0 bytes (0 packets)
        TX: 88 bytes (1 packets)
        signal: -51 dBm
        tx bitrate: 650.0 MBit/s VHT-MCS 7 80Mhz short GI VHT-NSS 2

        bss flags:
        dtim period:    1
        beacon int:     100

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 link.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/link.c b/link.c
index 3470c4d..ef8f4d3 100644
--- a/link.c
+++ b/link.c
@@ -187,10 +187,20 @@ static int print_link_sta(struct nl_msg *msg, void *arg)
 
 			if (rinfo[NL80211_RATE_INFO_MCS])
 				printf(" MCS %d", nla_get_u8(rinfo[NL80211_RATE_INFO_MCS]));
+			if (rinfo[NL80211_RATE_INFO_VHT_MCS])
+				printf(" VHT-MCS %d", nla_get_u8(rinfo[NL80211_RATE_INFO_VHT_MCS]));
 			if (rinfo[NL80211_RATE_INFO_40_MHZ_WIDTH])
 				printf(" 40Mhz");
+			if (rinfo[NL80211_RATE_INFO_80_MHZ_WIDTH])
+				printf(" 80Mhz");
+			if (rinfo[NL80211_RATE_INFO_80P80_MHZ_WIDTH])
+				printf(" 80P80Mhz");
+			if (rinfo[NL80211_RATE_INFO_160_MHZ_WIDTH])
+				printf(" 160Mhz");
 			if (rinfo[NL80211_RATE_INFO_SHORT_GI])
 				printf(" short GI");
+			if (rinfo[NL80211_RATE_INFO_VHT_NSS])
+				printf(" VHT-NSS %d", nla_get_u8(rinfo[NL80211_RATE_INFO_VHT_NSS]));
 			printf("\n");
 		}
 	}
-- 
1.8.0.3

