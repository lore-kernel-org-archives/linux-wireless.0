Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34657 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757785Ab3DCIFX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 04:05:23 -0400
Message-ID: <1364976319.8351.2.camel@jlt4.sipsolutions.net> (sfid-20130403_100533_037667_8C1E2D23)
Subject: Re: question on SMPS for AP
From: Johannes Berg <johannes@sipsolutions.net>
To: vivekanandah@posedge.com
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 03 Apr 2013 10:05:19 +0200
In-Reply-To: <fbef7a2278fe739a398430949087c950@posedge.com> (sfid-20130403_093709_189406_740B7438)
References: <fbef7a2278fe739a398430949087c950@posedge.com>
	 (sfid-20130403_093709_189406_740B7438)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Vivek,

> i was looking into the MAC80211 code for Spatial multiplexing Power 
> Save handling.
> 
> i see that for the station side, the code seems to be handled.
> is the same true for an AP interface as well? this is my current 
> understanding and i do not see any code handling for AP for SMPS.

Which part? There are two sides to SMPS handling:
 1) changing our own SMPS mode
 2) handling stations changing their SMPS mode

1) is implemented only for station mode, 2) is implemented for both AP
and station mode (though is less relevant for station mode)

>  From the perspective of an AP, the only thing it needs to do, is to 
> monitor the station for change to dynamic SMPS mode and if the station 
> is in dynamic SMPS mode, set the RTS flag for the first packet to be 
> sent out to the station so that an RTS/CTS mechanism is employed before 
> the packet transfer. this will make the station to wake up its receive 
> chains for the impending packet tranfer.
> 
> can anyone provide any inputs for the same and direct me to any code 
> that will help in understanding SMPS for AP?

Yes this is implemented, it starts in ieee80211_rx_h_action(),
WLAN_CATEGORY_HT, WLAN_HT_ACTION_SMPS and ends by calling
rate_control_rate_update(). The driver or rate control algorithm has to
take this into account, I'm not certain that all drivers and algorithms
do this correctly (yet).

johannes

