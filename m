Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49164 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab0ITGmj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Sep 2010 02:42:39 -0400
Received: from [71.117.12.23] (pool-71-117-12-23.sttlwa.dsl-w.verizon.net [71.117.12.23])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id o8K6gcPU017283
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sun, 19 Sep 2010 23:42:38 -0700
Message-ID: <4C97025D.9050006@candelatech.com>
Date: Sun, 19 Sep 2010 23:42:37 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: __ieee80211_rx_handle_packet problem with multiple vifs.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The  __ieee80211_rx_handle_packet logic is broken when multiple
VIFS can receive the same data packet (ARP, for instance).  It may have similar issues
for non-data packets, but it seems it at least mostly works in that
case.

The patch below makes it function better, but I suspect there are
still bugs with this approach because prepare_for_handlers() is
called with 'current' sta, but the packet may be processed for
'prev'.

I could make the logic more duplicated and take different code paths
if prev exists, or I could re-call the prepare_for_handlers right
before sending to invoke_rx_handlers.

Or maybe merge data and non-date loops into a single loop?

Any suggestions for preferred way to go about this?

Thanks,
Ben

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index ac205a3..521b086 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2657,8 +2657,19 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
                                 if (status->flag & RX_FLAG_MMIC_ERROR) {
                                         if (rx.flags & IEEE80211_RX_RA_MATCH)
                                                 ieee80211_rx_michael_mic_report(hdr, &rx);
-                               } else
-                                       prev = rx.sdata;
+                               } else {
+                                       if (prev) {
+                                               skb_new = skb_copy(skb, GFP_ATOMIC);
+                                               if (!skb_new) {
+                                                       if (net_ratelimit())
+                                                               wiphy_debug(local->hw.wiphy,
+                                                                           "failed to copy data frame for %s\n
+                                                                           prev->name);
+                                               } else
+                                                       ieee80211_invoke_rx_handlers(prev, &rx, skb_new);
+                                       }
+                                       prev = sta->sdata;
+                               }
                         }
                 }
         }

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
