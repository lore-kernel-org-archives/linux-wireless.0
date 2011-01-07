Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:19412 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753888Ab1AGF7p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 00:59:45 -0500
Received: from vs3003.wh2.ocn.ne.jp (125.206.180.231)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0438359982
	for <linux-wireless@vger.kernel.org>; Fri,  7 Jan 2011 14:59:42 +0900 (JST)
Subject: [PATCH 4/4] iw: Add signal average to station dump information
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: nbd@openwrt.org, linux-wireless@vger.kernel.org
Date: Fri, 07 Jan 2011 15:00:41 +0900
Message-ID: <20110107060041.21507.24000.stgit@localhost6.localdomain6>
In-Reply-To: <20110107060025.21507.11061.stgit@localhost6.localdomain6>
References: <20110107060025.21507.11061.stgit@localhost6.localdomain6>
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

