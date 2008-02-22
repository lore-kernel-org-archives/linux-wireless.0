Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488AbYBVVIN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 16:08:13 -0500
Subject: Re: Link Quality stats not updating, recieved_channel
From: Dan Williams <dcbw@redhat.com>
To: Andrew Lunn <andrew.lunn@ascom.ch>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080222142614.GA18830@donkey.ma.tech.ascom.ch>
References: <20080222142614.GA18830@donkey.ma.tech.ascom.ch>
Content-Type: text/plain
Date: Fri, 22 Feb 2008 16:05:51 -0500
Message-Id: <1203714351.4422.2.camel@localhost.localdomain> (sfid-20080222_210820_181842_49F25A7C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-02-22 at 15:26 +0100, Andrew Lunn wrote:
> Hi Folks
> 
> I found a problem with the IPW2100/ieee80211 drivers which i think
> also affects other users of ieee80211 in stock 2.6.24 and earlier.
> 
> The function net/ieee80211/ieee80211_rx.c:update_network() gets called
> in response to a beacon or a probe response. It is responsible for
> updating the information we already have about the network described
> by the beacon or the probe response. At the beginning of the function
> is:
> 
>         /* We only update the statistics if they were created by receiving
>          * the network information on the actual channel the network is on.
>          *
>          * This keeps beacons received on neighbor channels from bringing
>          * down the signal level of an AP. */
>         if (dst->channel == src->stats.received_channel)
>                 memcpy(&dst->stats, &src->stats,
>                        sizeof(struct ieee80211_rx_stats));
>         else
>                 IEEE80211_DEBUG_SCAN("Network %s info received "
>                         "off channel (%d vs. %d)\n", print_mac(mac, src->bssid),
>                         dst->channel, src->stats.received_channel);
> 
> The problem is that the ipw2100 driver never fills in the
> stats.received_channel. So the RSSI and other link quality parameters
> never get updated. The RSSI is always the RSSI of the first frame
> which caused the network record to be created. 

Can you try the attached patch instead?  stats.received_channel really
should be filled by the hardware driver itself.  This patch essentially
does what bcm43xx does.  Can you test it please?

Dan



diff --git a/drivers/net/wireless/ipw2100.c b/drivers/net/wireless/ipw2100.c
index 5bf9e00..8a3ce3a 100644
--- a/drivers/net/wireless/ipw2100.c
+++ b/drivers/net/wireless/ipw2100.c
@@ -2654,6 +2654,8 @@ static void __ipw2100_rx_process(struct ipw2100_priv *priv)
 			stats.mask |= IEEE80211_STATMASK_RSSI;
 		stats.freq = IEEE80211_24GHZ_BAND;
 
+		stats.received_channel = priv->channel;
+
 		IPW_DEBUG_RX("%s: '%s' frame type received (%d).\n",
 			     priv->net_dev->name, frame_types[frame_type],
 			     stats.len);

