Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out06.msg.oleane.net ([62.161.7.4]:56449 "EHLO
	smtp-out06.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab3FYSwz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jun 2013 14:52:55 -0400
Received: from smtp26.msg.oleane.net (smtp26.mail.priv [172.17.20.148])
	by smtp-out06.msg.oleane.net with ESMTP id r5PFpuw0025165
	for <linux-wireless@vger.kernel.org>; Tue, 25 Jun 2013 17:51:56 +0200
Received: from acksys.fr ([195.6.104.67]) (authenticated)
	by smtp26.msg.oleane.net (MTA) with ESMTP id r5PFVU6u018724
	for <linux-wireless@vger.kernel.org>; Tue, 25 Jun 2013 17:31:30 +0200
From: cedric.voncken@acksys.fr
To: linux-wireless@vger.kernel.org
Cc: Cedric Voncken <cedric.voncken@acksys.fr>
Subject: [PATCH] wireless: vlan priority handling in WMM
Date: Tue, 25 Jun 2013 17:31:02 +0200
Message-Id: <1372174262-13526-1-git-send-email-cedric.voncken@acksys.fr> (sfid-20130625_205307_645728_289E3D48)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Cedric Voncken <cedric.voncken@acksys.fr>

If the VLAN priority is set in skb->vlan_tci use it to determine the WMM priority.

Signed-off-by: Cedric Voncken <cedric.voncken@acksys.fr>
---
 net/wireless/util.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 74458b7..6f57ae7 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -685,6 +685,7 @@ EXPORT_SYMBOL(ieee80211_amsdu_to_8023s);
 unsigned int cfg80211_classify8021d(struct sk_buff *skb)
 {
 	unsigned int dscp;
+	unsigned char vlan_priority;
 
 	/* skb->priority values from 256->263 are magic values to
 	 * directly indicate a specific 802.1d priority.  This is used
@@ -694,6 +695,10 @@ unsigned int cfg80211_classify8021d(struct sk_buff *skb)
 	if (skb->priority >= 256 && skb->priority <= 263)
 		return skb->priority - 256;
 
+	vlan_priority = (skb->vlan_tci >> 13) & 0x07;
+		if (vlan_priority > 0)
+			return vlan_priority;
+
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
 		dscp = ipv4_get_dsfield(ip_hdr(skb)) & 0xfc;
-- 
1.7.2.5

