Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout2-sn1.fre.skanova.net ([81.228.11.159]:45640 "EHLO
	pne-smtpout2-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759551AbYB0U2j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2008 15:28:39 -0500
From: "Lars Ericsson" <Lars_Ericsson@telia.com>
To: "'Johannes Berg'" <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>,
	<rt2400-devel@lists.sourceforge.net>
Subject: RE: Roaming issues: Monitoring of a usable link to the AP.
Date: Wed, 27 Feb 2008 21:27:50 +0100
Message-ID: <008501c8797f$38e7c520$0b3ca8c0@gotws1589> (sfid-20080227_202911_095940_6768066E)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
In-Reply-To: <1204134256.6309.31.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, 

I have split my issues ito individual disussions:

> Monitoring of a usable link to the AP.
> ======================================
> The ieee80211_rx_h_sta_process() and  ieee80211_associated() are 
> involved in monitors for dead AP connection. A last_rx value is set to 
> indicate a working connection.
> 
> The porblem is the following lines.
> 	if (!is_multicast_ether_addr(hdr->addr1) ||
> 	    rx->sdata->vif.type == IEEE80211_IF_TYPE_STA) {
> 
> Any package that arrives to an STA will update the last_rx value and 
> prohibit a link lost action.
> 
> I have noticed in my system that this function receives the following 
> type of frames:
> 1) Broad cast frames from my BSS (beacons).
> 2) Data frames addressed to me ;)
> 3) Data frames from other STA addressed to other MAC addresses but 
> using the same BSS.
> 
> It is the case 3 that creates the problem. Another STA, closer to my 
> BSS will update my last_rx value even I do not receive the BSS.
>
> I'm pretty sure case 3 can't create a problem there since rx->sta wouldn't
be set to the AP. Can you please print out "rx->sta->addr"
> after the !sta check in ieee80211_rx_h_sta_process and send me the log
indicating that we can actually get into there with sta != our own AP?
> If we can that's a bug elsewhere but I doubt it.
 
Ok. I will come back with a trace.

/Lars

