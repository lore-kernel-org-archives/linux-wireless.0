Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:21189 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbZJTMQb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 08:16:31 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: iw: [PATCH] display station noise
Date: Tue, 20 Oct 2009 14:16:10 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910201416.10574.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: iw/link.c
===================================================================
--- iw.orig/link.c	2009-10-20 12:32:55.000000000 +0200
+++ iw/link.c	2009-10-20 12:33:26.000000000 +0200
@@ -119,6 +119,7 @@ static int print_link_sta(struct nl_msg 
 		[NL80211_STA_INFO_RX_PACKETS] = { .type = NLA_U32 },
 		[NL80211_STA_INFO_TX_PACKETS] = { .type = NLA_U32 },
 		[NL80211_STA_INFO_SIGNAL] = { .type = NLA_U8 },
+		[NL80211_STA_INFO_NOISE] = { .type = NLA_U8 },
 		[NL80211_STA_INFO_TX_BITRATE] = { .type = NLA_NESTED },
 		[NL80211_STA_INFO_LLID] = { .type = NLA_U16 },
 		[NL80211_STA_INFO_PLID] = { .type = NLA_U16 },
@@ -157,6 +158,9 @@ static int print_link_sta(struct nl_msg 
 	if (sinfo[NL80211_STA_INFO_SIGNAL])
 		printf("\tsignal: %d dBm\n",
 			(int8_t)nla_get_u8(sinfo[NL80211_STA_INFO_SIGNAL]));
+	if (sinfo[NL80211_STA_INFO_NOISE])
+		printf("\tnoise: %d dBm\n",
+			(int8_t)nla_get_u8(sinfo[NL80211_STA_INFO_NOISE]));
 
 	if (sinfo[NL80211_STA_INFO_TX_BITRATE]) {
 		if (nla_parse_nested(rinfo, NL80211_RATE_INFO_MAX,

-- 
http://www.holgerschurig.de
