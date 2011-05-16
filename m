Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18496 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755538Ab1EPO0n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 10:26:43 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/1] netlink: nla_nest_end return "unsigned init"
Date: Mon, 16 May 2011 07:23:30 -0700
Message-Id: <1305555810-17565-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110516_162647_053663_384CD15F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

skb->len has unsigned int, return the correct value from nla_nest_end call.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 include/net/netlink.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 8a3906a..241fc0d 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -1015,7 +1015,8 @@ static inline struct nlattr *nla_nest_start(struct sk_buff *skb, int attrtype)
  *
  * Returns the total data length of the skb.
  */
-static inline int nla_nest_end(struct sk_buff *skb, struct nlattr *start)
+static inline unsigned int nla_nest_end(struct sk_buff *skb,
+					struct nlattr *start)
 {
 	start->nla_len = skb_tail_pointer(skb) - (unsigned char *)start;
 	return skb->len;
-- 
1.7.0.4

