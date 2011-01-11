Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:19788 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754841Ab1AKAuZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 19:50:25 -0500
Received: from vs3006.wh2.ocn.ne.jp (125.206.180.169)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0434697023
	for <linux-wireless@vger.kernel.org>; Tue, 11 Jan 2011 09:50:23 +0900 (JST)
Subject: [PATCH v2 4/4] iw: Add signal average to station dump information
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: nbd@openwrt.org, linux-wireless@vger.kernel.org
Date: Tue, 11 Jan 2011 09:51:23 +0900
Message-ID: <20110111005123.10231.19628.stgit@localhost6.localdomain6>
In-Reply-To: <20110111005107.10231.81618.stgit@localhost6.localdomain6>
References: <20110111005107.10231.81618.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Print station signal average in station dump.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 station.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/station.c b/station.c
index be2301f..6581d50 100644
--- a/station.c
+++ b/station.c
@@ -107,6 +107,9 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 	if (sinfo[NL80211_STA_INFO_SIGNAL])
 		printf("\n\tsignal:  \t%d dBm",
 			(int8_t)nla_get_u8(sinfo[NL80211_STA_INFO_SIGNAL]));
+	if (sinfo[NL80211_STA_INFO_SIGNAL_AVG])
+		printf("\n\tsignal avg:\t%d dBm",
+			(int8_t)nla_get_u8(sinfo[NL80211_STA_INFO_SIGNAL_AVG]));
 
 	if (sinfo[NL80211_STA_INFO_TX_BITRATE]) {
 		if (nla_parse_nested(rinfo, NL80211_RATE_INFO_MAX,

