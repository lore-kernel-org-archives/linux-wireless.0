Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:50679 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab1CUViP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 17:38:15 -0400
Received: from kpbe20.cbf.corp.google.com (kpbe20.cbf.corp.google.com [172.25.105.84])
	by smtp-out.google.com with ESMTP id p2LLcEH2002551
	for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 14:38:14 -0700
Received: from glenhelen.mtv.corp.google.com (glenhelen.mtv.corp.google.com [172.22.72.223])
	by kpbe20.cbf.corp.google.com with ESMTP id p2LLcC5g003525
	for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 14:38:13 -0700
From: Paul Stewart <pstew@google.com>
Date: Mon, 21 Mar 2011 14:17:15 -0700
Subject: [PATCH 3/4] nl80211: Add bss info to station message
To: linux-wireless@vger.kernel.org
Message-Id: <20110321213812.ADB8A20880@glenhelen.mtv.corp.google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Paul Stewart <pstew@google.com>
---
 net/wireless/nl80211.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4ebce42..88b98dd 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2002,7 +2002,7 @@ static int nl80211_send_station(struct sk_buff *msg, u32 pid, u32 seq,
 				const u8 *mac_addr, struct station_info *sinfo)
 {
 	void *hdr;
-	struct nlattr *sinfoattr;
+	struct nlattr *sinfoattr, *bss_param;
 
 	hdr = nl80211hdr_put(msg, pid, seq, flags, NL80211_CMD_NEW_STATION);
 	if (!hdr)
@@ -2062,6 +2062,25 @@ static int nl80211_send_station(struct sk_buff *msg, u32 pid, u32 seq,
 	if (sinfo->filled & STATION_INFO_TX_FAILED)
 		NLA_PUT_U32(msg, NL80211_STA_INFO_TX_FAILED,
 			    sinfo->tx_failed);
+	if (sinfo->filled & STATION_INFO_BSS_PARAM) {
+		bss_param = nla_nest_start(msg, NL80211_STA_INFO_BSS_PARAM);
+		if (!bss_param)
+			goto nla_put_failure;
+
+		if (sinfo->bss_param.flags & BSS_PARAM_FLAGS_CTS_PROT)
+			NLA_PUT_FLAG(msg, NL80211_STA_BSS_PARAM_CTS_PROT);
+		if (sinfo->bss_param.flags & BSS_PARAM_FLAGS_SHORT_PREAMBLE)
+			NLA_PUT_FLAG(msg, NL80211_STA_BSS_PARAM_SHORT_PREAMBLE);
+		if (sinfo->bss_param.flags & BSS_PARAM_FLAGS_SHORT_SLOT_TIME)
+			NLA_PUT_FLAG(msg,
+				     NL80211_STA_BSS_PARAM_SHORT_SLOT_TIME);
+		NLA_PUT_U8(msg, NL80211_STA_BSS_PARAM_DTIM_PERIOD,
+			   sinfo->bss_param.dtim_period);
+		NLA_PUT_U16(msg, NL80211_STA_BSS_PARAM_BEACON_INTERVAL,
+			    sinfo->bss_param.beacon_interval);
+
+		nla_nest_end(msg, bss_param);
+	}
 	nla_nest_end(msg, sinfoattr);
 
 	return genlmsg_end(msg, hdr);
-- 
1.7.3.1

