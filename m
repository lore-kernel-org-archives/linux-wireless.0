Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44386 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750935AbeBWJGI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Feb 2018 04:06:08 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 2/4] mac80211: support AP 4-addr mode fast-rx
Date: Fri, 23 Feb 2018 10:06:04 +0100
Message-Id: <20180223090606.55726-2-nbd@nbd.name> (sfid-20180223_100631_909282_6BC75D80)
In-Reply-To: <20180223090606.55726-1-nbd@nbd.name>
References: <20180223090606.55726-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/rx.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 1c947e005434..bef83c6bf50c 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3783,6 +3783,15 @@ void ieee80211_check_fast_rx(struct sta_info *sta)
 			!(sdata->flags & IEEE80211_SDATA_DONT_BRIDGE_PACKETS) &&
 			(sdata->vif.type != NL80211_IFTYPE_AP_VLAN ||
 			 !sdata->u.vlan.sta);
+
+		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
+		    sdata->u.vlan.sta) {
+			fastrx.expected_ds_bits |=
+				cpu_to_le16(IEEE80211_FCTL_FROMDS);
+			fastrx.sa_offs = offsetof(struct ieee80211_hdr, addr4);
+			fastrx.internal_forward = 0;
+		}
+
 		break;
 	default:
 		goto clear;
-- 
2.14.2
