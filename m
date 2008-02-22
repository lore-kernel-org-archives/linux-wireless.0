Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ascomax.hasler.ascom.ch ([139.79.135.1]:51201 "EHLO
	ascomax.hasler.ascom.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbYBVO0S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 09:26:18 -0500
Received: from eiger.ma.tech.ascom.ch (eiger.ma.tech.ascom.ch [139.79.100.1])
	by ascomax.hasler.ascom.ch (8.14.1/8.14.1) with ESMTP id m1MEQFvs019549
	for <linux-wireless@vger.kernel.org>; Fri, 22 Feb 2008 15:26:15 +0100 (MET)
Received: from [139.79.100.143] (helo=donkey.ma.tech.ascom.ch)
	by eiger.ma.tech.ascom.ch with esmtp (Exim 3.16 #1)
	id 1JSYqr-00063G-00
	for linux-wireless@vger.kernel.org; Fri, 22 Feb 2008 15:26:13 +0100
Received: from lunn by donkey.ma.tech.ascom.ch with local (Exim 3.36 #1 (Debian))
	id 1JSYqs-0000Ph-00
	for <linux-wireless@vger.kernel.org>; Fri, 22 Feb 2008 15:26:14 +0100
Date: Fri, 22 Feb 2008 15:26:14 +0100
From: Andrew Lunn <andrew.lunn@ascom.ch>
To: linux-wireless@vger.kernel.org
Subject: Link Quality stats not updating, recieved_channel 
Message-ID: <20080222142614.GA18830@donkey.ma.tech.ascom.ch> (sfid-20080222_142621_823852_5E1CE99F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Folks

I found a problem with the IPW2100/ieee80211 drivers which i think
also affects other users of ieee80211 in stock 2.6.24 and earlier.

The function net/ieee80211/ieee80211_rx.c:update_network() gets called
in response to a beacon or a probe response. It is responsible for
updating the information we already have about the network described
by the beacon or the probe response. At the beginning of the function
is:

        /* We only update the statistics if they were created by receiving
         * the network information on the actual channel the network is on.
         *
         * This keeps beacons received on neighbor channels from bringing
         * down the signal level of an AP. */
        if (dst->channel == src->stats.received_channel)
                memcpy(&dst->stats, &src->stats,
                       sizeof(struct ieee80211_rx_stats));
        else
                IEEE80211_DEBUG_SCAN("Network %s info received "
                        "off channel (%d vs. %d)\n", print_mac(mac, src->bssid),
                        dst->channel, src->stats.received_channel);

The problem is that the ipw2100 driver never fills in the
stats.received_channel. So the RSSI and other link quality parameters
never get updated. The RSSI is always the RSSI of the first frame
which caused the network record to be created. 

I have an application which triggers periodic scans and prints out the
results and clearly shows this problem if you walk around. Using
iwlist ethX scan should also demonstrate the problem and enabling
IEEE80211_DEBUG_SCAN can demonstrate the problem as well.

I took a quick look at some of the drivers. As far as i can see, only
the IPW2200 driver fills in stats.received_channel before calling
80211_rx().

To get my application working i changed the test above. I update the
stats if src->stats.received_channel is zero, or if
src->stats.received_channel is not zero it must equal dst->channel.

However i don't know the big picture, so i don't know if this is the
correct fix. If it is correct, i would be happy to submit a patch.  

        Thanks
                Andrew
