Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:58846 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191Ab0JRSh6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Oct 2010 14:37:58 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 18 Oct 2010 11:37:48 -0700
Date: Mon, 18 Oct 2010 11:37:56 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] iw: print out eirp for triplets on scan
Message-ID: <20101018183756.GC22887@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When debugging country IE parsing when scanning you will not see this:

	Channels [1 - 1] @ 14 dBm
	Channels [2 - 10] @ 21 dBm
	Channels [11 - 11] @ 14 dBm

Instead of this:

	Channels [1 - 1]
	Channels [2 - 10]
	Channels [11 - 11

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 scan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scan.c b/scan.c
index 3b5fb60..486a70e 100644
--- a/scan.c
+++ b/scan.c
@@ -222,7 +222,7 @@ static void print_country(const uint8_t type, uint8_t len, const uint8_t *data)
 		else
 			end_channel =  triplet->chans.first_channel + (4 * (triplet->chans.num_channels - 1));
 
-		printf("\t\tChannels [%d - %d]\n", triplet->chans.first_channel, end_channel);
+		printf("\t\tChannels [%d - %d] @ %d dBm\n", triplet->chans.first_channel, end_channel, triplet->chans.max_power);
 
 		data += 3;
 		len -= 3;
-- 
1.7.0.4

