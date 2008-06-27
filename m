Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:9052 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755670AbYF0UUF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2008 16:20:05 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 3/5] hostap: don't skip any headers in
	hostap_80211_header_parse()
To: Jouni Malinen <j@w1.fi>, John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Fri, 27 Jun 2008 16:20:04 -0400
Message-ID: <20080627202004.18603.41908.stgit@dv.roinet.com> (sfid-20080627_222010_712867_EA5F2166)
In-Reply-To: <20080627201952.18603.98308.stgit@dv.roinet.com>
References: <20080627201952.18603.98308.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't try to skip any headers in hostap_80211_header_parse().  We never
use that function for interfaces affected by local->monitor_type.  Both
the master and the AP interface receive 802.11 frames without any
additional headers.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/hostap/hostap_main.c |   20 +-------------------
 1 files changed, 1 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_main.c b/drivers/net/wireless/hostap/hostap_main.c
index a38e85f..756ab56 100644
--- a/drivers/net/wireless/hostap/hostap_main.c
+++ b/drivers/net/wireless/hostap/hostap_main.c
@@ -597,25 +597,7 @@ void hostap_dump_tx_header(const char *name, const struct hfa384x_tx_frame *tx)
 static int hostap_80211_header_parse(const struct sk_buff *skb,
 				     unsigned char *haddr)
 {
-	struct hostap_interface *iface = netdev_priv(skb->dev);
-	local_info_t *local = iface->local;
-
-	if (local->monitor_type == PRISM2_MONITOR_PRISM ||
-	    local->monitor_type == PRISM2_MONITOR_CAPHDR) {
-		const unsigned char *mac = skb_mac_header(skb);
-
-		if (*(u32 *)mac == LWNG_CAP_DID_BASE) {
-			memcpy(haddr,
-			       mac + sizeof(struct linux_wlan_ng_prism_hdr) + 10,
-			       ETH_ALEN); /* addr2 */
-		} else { /* (*(u32 *)mac == htonl(LWNG_CAPHDR_VERSION)) */
-			memcpy(haddr,
-			       mac + sizeof(struct linux_wlan_ng_cap_hdr) + 10,
-			       ETH_ALEN); /* addr2 */
-		}
-	} else
-		memcpy(haddr, skb_mac_header(skb) + 10, ETH_ALEN); /* addr2 */
-
+	memcpy(haddr, skb_mac_header(skb) + 10, ETH_ALEN); /* addr2 */
 	return ETH_ALEN;
 }
 
