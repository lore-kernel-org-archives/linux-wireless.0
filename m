Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay0-omc2-s4.bay0.hotmail.com ([65.54.246.140]:53085 "EHLO
	bay0-omc2-s4.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750906AbYK1GKz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2008 01:10:55 -0500
Message-ID: <BAY104-DAV2759DEF86863A0B2E73A299040@phx.gbl> (sfid-20081128_071058_369940_80CDB262)
Message-ID: <492F8B65.40400@hotmail.com>
Date: Fri, 28 Nov 2008 17:10:45 +1100
From: Shaddy Baddah <shaddy_baddah@hotmail.com>
Reply-To: linux-wireless@vger.kernel.org,
	  Shaddy Baddah <shaddy_baddah@hotmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [PATCHv2] zd1211rw: use unaligned safe memcmp() in-place of compare_ether_addr()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Forgot the sign-off. Take two:

Under my 2.6.28-rc6 sparc64, when associating to an AP through my
zd1211rw device, I was seeing kernel log messages like (not exact output):

  Kernel unaligned access at TPC[10129b68] zd_mac_rx+0x144/0x32c [zd1211rw]

For the zd1211rw module, on RX, the 80211 packet will be located after
the PLCP header in the skb data buffer. The PLCP header being 5 bytes
long, the 80211 header will start unaligned from an aligned skb
buffer.

As per Documentation/unaligned-memory-access.txt, we must replace the
not unaligned() safe compare_ether_addr() with memcmp() to protect
architectures that require alignment.

Signed-off-by: Shaddy Baddah <shaddy_baddah@hotmail.com>

diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c
b/drivers/net/wireless/zd1211rw/zd_mac.c
index e48d605..dd93f23 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -616,7 +616,7 @@ static int filter_ack(struct ieee80211_hw *hw,
struct ieee80211_hdr *rx_hdr,
         struct ieee80211_hdr *tx_hdr;

         tx_hdr = (struct ieee80211_hdr *)skb->data;
-        if (likely(!compare_ether_addr(tx_hdr->addr2, rx_hdr->addr1)))
+        if (likely(!memcmp(tx_hdr->addr2, rx_hdr->addr1, ETH_ALEN)))
         {
             __skb_unlink(skb, q);
             tx_status(hw, skb, IEEE80211_TX_STAT_ACK, stats->signal, 1);


--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



