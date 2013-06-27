Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp02.msg.oleane.net ([62.161.4.2]:45867 "EHLO
	smtp02.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab3F0HwR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 03:52:17 -0400
From: cedric.voncken@acksys.fr
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	cedric voncken <cedric.voncken@acksys.fr>
Subject: [PATCH V2] vlan priority handling in WMM
Date: Thu, 27 Jun 2013 09:52:00 +0200
Message-Id: <1372319520-29087-1-git-send-email-cedric.voncken@acksys.fr> (sfid-20130627_095239_965352_681095C2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: cedric voncken <cedric.voncken@acksys.fr>

If the VLAN tci is set in skb->vlan_tci use the priority field to determine the WMM priority.

V2 modifications :
	Fix indentation
	Use symbolic constant
	include the header linux/if_vlan.h

Signed-off-by: cedric Voncken <cedric.voncken@acksys.fr>
---
 net/wireless/util.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 74458b7..13937db 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -10,6 +10,7 @@
 #include <net/cfg80211.h>
 #include <net/ip.h>
 #include <net/dsfield.h>
+#include <linux/if_vlan.h>
 #include "core.h"
 #include "rdev-ops.h"
 
@@ -685,6 +686,7 @@ EXPORT_SYMBOL(ieee80211_amsdu_to_8023s);
 unsigned int cfg80211_classify8021d(struct sk_buff *skb)
 {
 	unsigned int dscp;
+	unsigned char vlan_priority;
 
 	/* skb->priority values from 256->263 are magic values to
 	 * directly indicate a specific 802.1d priority.  This is used
@@ -694,6 +696,10 @@ unsigned int cfg80211_classify8021d(struct sk_buff *skb)
 	if (skb->priority >= 256 && skb->priority <= 263)
 		return skb->priority - 256;
 
+	vlan_priority = (skb->vlan_tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
+	if (vlan_priority > 0)
+		return vlan_priority;
+
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
 		dscp = ipv4_get_dsfield(ip_hdr(skb)) & 0xfc;
-- 
1.7.2.5

