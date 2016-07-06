Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33396 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753129AbcGFKoY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:44:24 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:25 +0300
Message-Id: <1467801651-1816-30-git-send-email-luca@coelho.fi> (sfid-20160706_125027_470500_1627C5D5)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 30/56] iwlwifi: mvm: checksum IPv6 fragmented packet
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Our HW does not support checksum of fragmented packets.
Fix code accordingly to checksum those packets in the driver.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Fixes: 5e6a98dc4863 ("iwlwifi: mvm: enable TCP/UDP checksum support for 9000 family")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 2373142..f3a6e95 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -138,28 +138,19 @@ static void iwl_mvm_tx_csum(struct iwl_mvm *mvm, struct sk_buff *skb,
 
 		protocol = ipv6h->nexthdr;
 		while (protocol != NEXTHDR_NONE && ipv6_ext_hdr(protocol)) {
+			struct ipv6_opt_hdr *hp;
+
 			/* only supported extension headers */
 			if (protocol != NEXTHDR_ROUTING &&
 			    protocol != NEXTHDR_HOP &&
-			    protocol != NEXTHDR_DEST &&
-			    protocol != NEXTHDR_FRAGMENT) {
+			    protocol != NEXTHDR_DEST) {
 				skb_checksum_help(skb);
 				return;
 			}
 
-			if (protocol == NEXTHDR_FRAGMENT) {
-				struct frag_hdr *hp =
-					OPT_HDR(struct frag_hdr, skb, off);
-
-				protocol = hp->nexthdr;
-				off += sizeof(struct frag_hdr);
-			} else {
-				struct ipv6_opt_hdr *hp =
-					OPT_HDR(struct ipv6_opt_hdr, skb, off);
-
-				protocol = hp->nexthdr;
-				off += ipv6_optlen(hp);
-			}
+			hp = OPT_HDR(struct ipv6_opt_hdr, skb, off);
+			protocol = hp->nexthdr;
+			off += ipv6_optlen(hp);
 		}
 		/* if we get here - protocol now should be TCP/UDP */
 #endif
-- 
2.8.1

