Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from investici.nine.ch ([217.150.252.179]:28102 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab2AHL5i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jan 2012 06:57:38 -0500
From: Antonio Quartulli <ordex@autistici.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <ordex@autistici.org>
Subject: [PATCH] iw: add support for NL80211_CMD_DEL_STATION event
Date: Sun,  8 Jan 2012 12:39:26 +0100
Message-Id: <1326022766-1881-1-git-send-email-ordex@autistici.org> (sfid-20120108_125742_266016_159B2625)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Actually iw event does not recognise the NL80211_CMD_DEL_STATION event. This
patch makes it print the appropriate message.

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---
 event.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/event.c b/event.c
index 18cde45..bc39662 100644
--- a/event.c
+++ b/event.c
@@ -321,6 +321,10 @@ static int print_event(struct nl_msg *msg, void *arg)
 		mac_addr_n2a(macbuf, nla_data(tb[NL80211_ATTR_MAC]));
 		printf("new station %s\n", macbuf);
 		break;
+	case NL80211_CMD_DEL_STATION:
+		mac_addr_n2a(macbuf, nla_data(tb[NL80211_ATTR_MAC]));
+		printf("del station %s\n", macbuf);
+		break;
 	case NL80211_CMD_JOIN_IBSS:
 		mac_addr_n2a(macbuf, nla_data(tb[NL80211_ATTR_MAC]));
 		printf("IBSS %s joined\n", macbuf);
-- 
1.7.3.4

