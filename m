Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32636 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585AbZLDMWD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2009 07:22:03 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 04 Dec 2009 04:22:10 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	<stable@kernel.org>
Subject: [PATCH] mac80211: Fix bug in computing crc over dynamic IEs in beacon
Date: Fri, 4 Dec 2009 17:41:34 +0530
Message-ID: <1259928694-7824-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On a 32-bit machine, BIT() macro does not give the required
bit value if the bit is mroe than 31. In ieee802_11_parse_elems_crc(),
BIT() is suppossed to get the bit value more than 31 (42 (id of ERP_INFO_IE),
37 (CHANNEL_SWITCH_IE), (42), 32 (POWER_CONSTRAINT_IE), 45 (HT_CAP_IE),
61 (HT_INFO_IE)). As we do not get the required bit value for the above
IEs, crc over these IEs are never calculated, so any dynamic change in these
IEs after the association is not really handled on 32-bit platforms.
This patch fixes this issue.

Cc: stable@kernel.org
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 net/mac80211/util.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index d09f78b..78a6e92 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -579,7 +579,7 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 		if (elen > left)
 			break;
 
-		if (calc_crc && id < 64 && (filter & BIT(id)))
+		if (calc_crc && id < 64 && (filter & (1ULL << id)))
 			crc = crc32_be(crc, pos - 2, elen + 2);
 
 		switch (id) {
-- 
1.5.5.1

