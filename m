Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:26348 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbZH0SP3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 14:15:29 -0400
Received: by qw-out-2122.google.com with SMTP id 8so311032qwh.37
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2009 11:15:31 -0700 (PDT)
From: Brian Cavagnolo <brian@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Brian Cavagnolo <brian@cozybit.com>
Subject: [PATCH] iw: fix NL80211_STA_INFO_PLINK_STATE printing in station dump
Date: Thu, 27 Aug 2009 11:15:20 -0700
Message-Id: <1251396920-3954-1-git-send-email-brian@cozybit.com>
In-Reply-To: <iw1>
References: <iw1>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

NL80211_STA_INFO_PLINK_STATE is a u8, not a u16.  This bug was causing
unexpected output on big endian machines.

Signed-off-by: Brian Cavagnolo <brian@cozybit.com>
---
 station.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/station.c b/station.c
index 0fff92d..a4865f9 100644
--- a/station.c
+++ b/station.c
@@ -127,7 +127,7 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 		printf("\n\tmesh plid:\t%d",
 			nla_get_u16(sinfo[NL80211_STA_INFO_PLID]));
 	if (sinfo[NL80211_STA_INFO_PLINK_STATE]) {
-		switch (nla_get_u16(sinfo[NL80211_STA_INFO_PLINK_STATE])) {
+		switch (nla_get_u8(sinfo[NL80211_STA_INFO_PLINK_STATE])) {
 		case LISTEN:
 			strcpy(state_name, "LISTEN");
 			break;
-- 
1.6.0.4

