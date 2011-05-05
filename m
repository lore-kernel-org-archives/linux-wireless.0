Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33482 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab1EEUoz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2011 16:44:55 -0400
Message-ID: <4DC30C42.6070402@candelatech.com> (sfid-20110505_224459_707820_DCDBBEE7)
Date: Thu, 05 May 2011 13:44:50 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Bisected:  ath9k: fix powersave frame filtering/buffering in AP mode
 broke STA association.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I bisected the problem I was having with ath9k STA configured for WPA
not being able to authenticate.  I'm using nohwcrypt=1, which may
be why no one else sees it.

According to bisect, this is the first bad commit:

commit 5519541d5a5f19893546883547e2f0f2e5934df7
Author: Felix Fietkau <nbd@openwrt.org>
Date:   Sun Apr 17 23:28:09 2011 +0200

     ath9k: fix powersave frame filtering/buffering in AP mode

     This patch fixes a long standing issue of pending packets in the queue being
     sent (and retransmitted many times) to sleeping stations.
     This was made worse by aggregation through driver-internal retransmitting
     of A-MDPU subframes.
     Previously the hardware tx filter was cleared unconditionally for every
     single packet - with this patch it uses the IEEE80211_TX_CTL_CLEAR_PS_FILT
     for unaggregated frames.
     A sta_notify driver op is added to stop aggregation for stations when they
     enter powersave mode. Subframes stay buffered inside the driver, to ensure
     that the BlockAck window keeps a sane state.
     Since the driver uses software aggregation, the clearing of the tx filter
     needs to be handled by the driver instead of mac80211 for aggregated frames.

     Signed-off-by: Felix Fietkau <nbd@openwrt.org>
     Signed-off-by: John W. Linville <linville@tuxdriver.com>


I'll be happy to test patches, it seems very easy to reproduce on
my setup.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

