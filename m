Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:47367 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757092Ab3DXTZ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Apr 2013 15:25:58 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] iw/event:  Print out PROBE_CLIENT event information.
Date: Wed, 24 Apr 2013 12:25:52 -0700
Message-Id: <1366831552-4698-1-git-send-email-greearb@candelatech.com> (sfid-20130424_212604_576887_CA1D7E5C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

For instance:
vap0 (phy #0): probe client 00:ab:cd:ef:03:5c (cookie f54bb400): no ack

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 fbe3e0e... 603b072... M	event.c
 event.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/event.c b/event.c
index fbe3e0e..603b072 100644
--- a/event.c
+++ b/event.c
@@ -517,6 +517,16 @@ static int print_event(struct nl_msg *msg, void *arg)
 	case NL80211_CMD_SET_WOWLAN:
 		parse_wowlan_wake_event(tb);
 		break;
+	case NL80211_CMD_PROBE_CLIENT:
+		if (tb[NL80211_ATTR_MAC])
+			mac_addr_n2a(macbuf, nla_data(tb[NL80211_ATTR_MAC]));
+		else
+			strcpy(macbuf, "??");
+		printf("probe client %s (cookie %llx): %s\n",
+		       macbuf,
+		       (unsigned long long)nla_get_u64(tb[NL80211_ATTR_COOKIE]),
+		       tb[NL80211_ATTR_ACK] ? "acked" : "no ack");
+		break;
 	default:
 		printf("unknown event %d\n", gnlh->cmd);
 		break;
-- 
1.7.3.4

