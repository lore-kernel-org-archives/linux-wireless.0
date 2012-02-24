Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59865 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab2BXIBa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 03:01:30 -0500
Subject: Re: [RFCv2] cfg80211: 80Mhz Bandwidth channel flags in 5Gig band
From: Johannes Berg <johannes@sipsolutions.net>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Mahesh <maheshp@posedge.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <CAJ-Vmong58rRX_sMA3Zgg+17=ebAGmG9U+9rGC8Fw4q_=B2hDg@mail.gmail.com> (sfid-20120224_064351_670956_75D41CFC)
References: <f17c700977012ada368da4f339b9c639@posedge.com>
	 <1329933458.4657.2.camel@jlt3.sipsolutions.net>
	 <1329937072.4657.4.camel@jlt3.sipsolutions.net>
	 <4F471F40.8060503@posedge.com>
	 <CAJ-Vmong58rRX_sMA3Zgg+17=ebAGmG9U+9rGC8Fw4q_=B2hDg@mail.gmail.com>
	 (sfid-20120224_064351_670956_75D41CFC)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Feb 2012 09:01:25 +0100
Message-ID: <1330070485.3426.14.camel@jlt3.sipsolutions.net> (sfid-20120224_090133_771796_44A52C47)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-02-23 at 21:43 -0800, Adrian Chadd wrote:
> Hi,
> 
> Since what your _actual_ commit is doing is "begin fleshing out
> 802.11ac support", I suggest someone spark a discussion or two about
> it first..

Now you did ;-)

I think the regulatory stuff is important, but obviously we also need
VHT advertising, all the mac80211 (and hostapd) bits to add the IEs in
the right places, station capability stuff. Some extensions for bitrate
information/rate control will be needed -- maybe we should get started
on radiotap VHT extensions also.

Then stuff like CSA with wide bandwidth channel switch, VHT transmit
power envelope, extended power constraint & quiet channel handling.

If anyone wants beamforming, I'm not sure where that needs to be
implemented, and MU-MIMO will be interesting as well.

I also suspect A-MSDU will become more interesting, and I don't even
want to think about VHT-IBSS.

johannes

