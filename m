Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57583 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475Ab3E3Spb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 14:45:31 -0400
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r4UIjUsZ002149
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 11:45:30 -0700
Message-ID: <51A79E4A.7000609@candelatech.com> (sfid-20130530_204534_277778_C041AEF5)
Date: Thu, 30 May 2013 11:45:30 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Another try at getting pktgen to work with wifi.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm trying to come up with a more acceptable patch to the problem discussed a few years
ago:

http://thread.gmane.org/gmane.linux.kernel.wireless.general/64582/focus=64626

The patch below appears to work as expected.  In pktgen, you just have to set
the QoS to whatever value matches the queue you need.

This seem reasonable?

Thanks,
Ben

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index d445bb1..c770f19 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1544,6 +1544,18 @@ void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
                 }
         }

+       /* This check needs to go in before the QoS header is set below. */
+       if (skb->priority > 7 ||
+           skb->queue_mapping != ieee802_1d_to_ac[skb->priority]) {
+               WARN_ONCE(1, "Invalid queue-mapping, priority: %i  queue-mapping: %i.  This is an expected warning
+                         (int)(skb->priority), (int)(skb->queue_mapping));
+               /* Adjust queue-mapping to match what the wifi stack expects.
+                * pktgen will just have to set QoS bits accordingly instead
+                * of trying to set the queue_mapping directly.
+                */
+               skb_set_queue_mapping(skb, ieee80211_select_queue(sdata, skb));
+       }
+
         ieee80211_set_qos_hdr(sdata, skb);
         ieee80211_tx(sdata, skb, false, band);
  }


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

