Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-3.exch022.serverdata.net ([206.225.164.186]:20904
	"EHLO HUB022-nj-3.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936360Ab3DIQDi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 12:03:38 -0400
From: Naveenraj Subramanian <naveenrajs@posedge.com>
To: Vivekananda Holla <vivekanandah@posedge.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
Subject: RE: RFC: SMPS for AP mode
Date: Tue, 9 Apr 2013 15:55:32 +0000
Message-ID: <E010768E26DFE947BD731EFACA2252B70DE20788@MBX022-E1-NJ-8.exch022.domain.local> (sfid-20130409_180341_309987_3D3A6828)
References: <fbef7a2278fe739a398430949087c950@posedge.com>
	 (sfid-20130403_093709_189406_740B7438)
 <1364976319.8351.2.camel@jlt4.sipsolutions.net>
	 <7a1a483e9382db42e8f648c3933bc2cd@posedge.com>
	 <1364978764.8351.6.camel@jlt4.sipsolutions.net>
	 <021a065e3ab402466e8049b2f4cd3fdd@posedge.com>,<1365502750.8465.30.camel@jlt4.sipsolutions.net>
In-Reply-To: <1365502750.8465.30.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Vivek,

Do you plan to implement this piece of code?

Regards,
Naveen.
________________________________________
From: linux-wireless-owner@vger.kernel.org [linux-wireless-owner@vger.kernel.org] on behalf of Johannes Berg [johannes@sipsolutions.net]
Sent: Tuesday, April 09, 2013 3:49 PM
To: Vivekananda Holla
Cc: linux-wireless@vger.kernel.org; nbd@openwrt.org
Subject: Re: RFC: SMPS for AP mode

Hi,

> based on the discussion, i have come out with an RFC for SMPS support
> for AP in minstrel_ht. kindly see the explanation below and indicate to
> me, if this okay or any changes are required?

Code talks ;-)

> RFC To send out RTS for AP connected to a dynamic SMPS station
>
> This code change addresses the AP requirement of sending out a
> RTS frame when dynamic SMPS is enabled at the station
>
> the minstrel_ht rate module needs to provide the lower driver layer
> an indication of enabling RTS frame transmission for an AP connected
> to a dynamic SMPS station.

It really just needs to set the RTS flag on the frames.

> the SMPS state of the station is stored in the ieee80211_sta
> structure's ht_cap variable.

No, not any more.

> the minstrel_ht_get_rate function can be modified to check if the
> station is a dynamic SMPS
> station and a new flag can be incorporated for the ieee80211_tx_info
> flags (e.g. IEEE80211_TX_CTL_SMPS_SET_RTS)
> that indicates to the lower layer that the station is a dynamic SMPS
> enabled station.
>
> the lower AP driver can then enable RTS before the first frame
> transmission to the station by checking for the above flag.

Sounds about right.

johannes

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
