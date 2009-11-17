Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51949 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbZKQOAb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 09:00:31 -0500
Date: Tue, 17 Nov 2009 08:58:17 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stephen Hemminger <shemminger@vyatta.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [RFC] mac80211: disallow bridging managed/adhoc interfaces
Message-ID: <20091117135817.GC27743@tuxdriver.com>
References: <1258465585.3682.7.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1258465585.3682.7.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 17, 2009 at 02:46:25PM +0100, Johannes Berg wrote:
> A number of people have tried to add a wireless interface
> (in managed mode) to a bridge and then complained that it
> doesn't work. It cannot work, however, because in 802.11
> networks all packets need to be acknowledged and as such
> need to be sent to the right address. Promiscuous doesn't
> help here. The wireless address format used for these
> links has only space for three addresses, the
>  * transmitter, which must be equal to the sender (origin)
>  * receiver (on the wireless medium), which is the AP in
>    the case of managed mode
>  * the recipient (destination), which is on the APs local
>    network segment
> 
> In an IBSS, it is similar, but the receiver and recipient
> must match and the third address is used as the BSSID.
> 
> To avoid such mistakes in the future, disallow adding a
> wireless interface to a bridge.
> 
> Felix has recently added a four-address mode to the AP
> and client side that can be used (after negotiating that
> it is possible, which must happen out-of-band by setting
> up both sides) for bridging, so allow that case.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

ACK -- we get these complaints fairly often...

I don't think I've sent the 4addr stuff to Dave yet.  Should I just
take this through my tree?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
