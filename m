Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30286 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412Ab2CSDuS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Mar 2012 23:50:18 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20326.44233.811876.892785@gargle.gargle.HOWL> (sfid-20120319_045022_784918_90A682FF)
Date: Mon, 19 Mar 2012 09:19:29 +0530
To: Adrian Chadd <adrian@freebsd.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: mac80211 20/40 coexist
In-Reply-To: <CAJ-VmomNGku0CNfX+feeeUET4mXEFDj976sSfg-GG-KUSGCWvw@mail.gmail.com>
References: <1331818214.3432.12.camel@jlt3.sipsolutions.net>
	<8F3AF1C9F856774F8C8D67AA7EDFEC8801E3005E@aphydexd01b>
	<1331902885.6753.10.camel@jlt3.sipsolutions.net>
	<8F3AF1C9F856774F8C8D67AA7EDFEC8801E3040B@aphydexd01b>
	<1332065984.3609.5.camel@jlt3.sipsolutions.net>
	<CAJ-VmomNGku0CNfX+feeeUET4mXEFDj976sSfg-GG-KUSGCWvw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adrian Chadd wrote:
> On 18 March 2012 03:19, Johannes Berg <johannes@sipsolutions.net> wrote:
> 
> > I'm not sure I can believe this -- surely the firmware has to have a way
> > of dealing with stations that can't do 40 MHz and stations that can, so
> > switching between the two doesn't seem like a major proposal? We also
> > don't currently handle the action frames for that, but it seems like we
> > should.
> >
> > Note, however, that we're now discussing something already done --
> > Paul's patch already removed the channel type update when all we wanted
> > was update the RC.
> 
> When are stations being notified of a CWM change?
> 
> I know FreeBSD handles it with a big stick at the moment - it just
> does a full interface reset and channel change. I don't necessarily
> like it, but I haven't yet sat down to look at when and why this is
> occuring.

For AP mode, we currently don't have dynamic CWM - and if it is ever implemented,
it would probably be in hostapd.

For station mode, HT bandwidth changes can be notified via beacons, probe responses
or action frames. mac80211 currently processes beacons and the HT operation element.

Also, only legacy CSA announcements are handled by mac80211 right now, the 11n
extensions to the CSA action frame are yet to be implemented.

As far as ath9k/ath9k_htc is concerned, I think we have to reset/reconfigure the HW
when a channel switch happens, since we reprogram various MAC/PHY registers based on
the HT bandwidth. Both ath9k and ath9k_htc update their rate control modules
correctly - ath9k via the rate_update() callback and ath9k_htc using BSS_CHANGED_HT
in bss_info_changed().

Sujith
