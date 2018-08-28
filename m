Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54866 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727224AbeH1QOI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 12:14:08 -0400
From: Sathishkumar Muruganandam <murugana@codeaurora.org>
To: linux-wireless@vger.kernel.org
Cc: Sathishkumar Muruganandam <murugana@codeaurora.org>
Subject: [PATCH v2] mac80211: add missing WFA Multi-AP backhaul STA Rx requirement
Date: Tue, 28 Aug 2018 17:51:38 +0530
Message-Id: <20180828122138.28764-1-murugana@codeaurora.org> (sfid-20180828_142246_810659_CB15B07C)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current mac80211 WDS (4-address mode) can be used to cover most of the
Multi-AP requirements for Data frames per the WFA Multi-AP Specification v1.0.
When configuring AP/STA interfaces in 4-address mode, they are able to function
as fronthaul AP/backhaul STA of Multi-AP device complying below
Tx, Rx requirements except one missing STA Rx requirement added by this patch.

Multi-AP specification section 14.1 describes the following requirements:

Transmitter requirements
------------------------
1. Fronthaul AP
        i) When DA!=RA of backhaul STA, must use 4-address format
        ii) When DA==RA of backhaul STA, shall use either 3-address
            or 4-address format with RA updated with STA MAC

            (mac80211 support 4-address format via AP/VLAN interface)

2. Backhaul STA
        i) When SA!=TA of backhaul STA, must use 4-address format
        ii) When SA==TA of backhaul STA, shall use either 3-address
            or 4-address format with RA updated with AP MAC

            (mac80211 support 4-address format via use_4addr)

Receiver requirements
---------------------
1. Fronthaul AP
        i) When SA!=TA of backhaul STA, must support receiving 4-address
           format frames
        ii) When SA==TA of backhaul STA, must support receiving both
            3-address and 4-address format frames

            (mac80211 support both 3-addr & 4-addr via AP/VLAN interface)

2. Backhaul STA
        i) When DA!=RA of backhaul STA, must support receiving 4-address
           format frames
        ii) When DA==RA of backhaul STA,  must support receiving both
            3-address and 4-address format frames

            (mac80211 support only receiving 4-address format via
             use_4addr)

This patch addresses the above Rx requirement (ii) for backhaul STA to receive
unicast (DA==RA) 3-address frames in addition to 4-address frames.

The current design doesn't accept 3-address frames when configured in 4-address
mode (use_4addr). Hence add a check to allow 3-address frames when DA==RA of
backhaul STA (adhering to Table 9-26 of IEEE Std 802.11™-2016).

This case was tested with a bridged station interface when associated with
a non-mac80211 based vendor AP implementation using 3-address frames for WDS.

STA was able to support the Multi-AP Rx requirement when DA==RA. No issues,
no loops seen when tested with mac80211 based AP as well.

Verified and confirmed all other Tx and Rx requirements of AP and STA for
Multi-AP respectively. They all work using the current mac80211-WDS design.

Signed-off-by: Sathishkumar Muruganandam <murugana@codeaurora.org>
---
Changes in v2:
	* Changed subject title
	* Cleaned up commit log
---
 net/mac80211/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 64742f2765c4..134bbbc9cd6e 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2313,7 +2313,7 @@ __ieee80211_data_to_8023(struct ieee80211_rx_data *rx, bool *port_control)
 
 		if (!sdata->u.mgd.use_4addr)
 			return -1;
-		else
+		else if (!ether_addr_equal(hdr->addr1, sdata->vif.addr))
 			check_port_control = true;
 	}
 
-- 
2.17.1
