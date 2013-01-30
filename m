Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:33670 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab3A3F5B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 00:57:01 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20744.44999.48237.463434@gargle.gargle.HOWL> (sfid-20130130_065708_844233_986E04DD)
Date: Wed, 30 Jan 2013 10:59:43 +0530
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: WARNING: at drivers/net/wireless/ath/ath9k/beacon.c:362 ath9k_beacon_tasklet+0xcc/0x5f0)
In-Reply-To: <5108AD09.9020308@candelatech.com>
References: <5108AD09.9020308@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
> I hit this warning in ath9k.  Shortly after the machine blew up elsewhere,
> but not sure if this is to blame or not.
> 
> Code is slightly modified 3.7.5 (just a few patches, not my normal mass of hackings!)
> 
> The warning that hit is the one below:
> 
> 	bf = ath9k_beacon_generate(sc->hw, vif);
> 	WARN_ON(!bf);
> 
> Test case is dual-core Atom system with ath9k NIC, 10 or so virtual stations,
> two virtual APs.  Two stations send traffic to each other once everything associates, but
> not sure it got that far when this crash happened.
> 

Are these patches in your tree ?

commit 1381559ba48a04ca7c98f1b4c487bd44d0b75db5
Author: Felix Fietkau <nbd@openwrt.org>
Date:   Sun Jan 20 18:51:53 2013 +0100

    ath9k: clean up processing of pending tx frames on reset
    
    Dropping packets from aggregation sessions is usually not a good idea, as
    it might upset the synchronization of the BlockAck receive window of the
    remote node. The use of the retry_tx parameter to reset/tx-drain functions
    also seemed a bit arbitrary.
    This patch removes this parameter altogether and ensures that pending tx
    frames are not dropped for no good reason.
    
    Signed-off-by: Felix Fietkau <nbd@openwrt.org>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

commit 3adcf20afb585993ffee24de36d1975f6b26b120
Author: Felix Fietkau <nbd@openwrt.org>
Date:   Wed Jan 9 16:16:54 2013 +0100

    ath9k: remove the WARN_ON that triggers if generating a beacon fails
    
    During teardown, mac80211 will not return a new beacon. This is normal and
    handled properly in the driver, so there's no need to spam the user with a kernel
    warning here.
    
    Cc: stable@vger.kernel.org
    Signed-off-by: Felix Fietkau <nbd@openwrt.org>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>


Sujith
