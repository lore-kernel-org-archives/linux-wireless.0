Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52956 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab2I1KjO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2012 06:39:14 -0400
Message-ID: <1348828789.13298.5.camel@jlt4.sipsolutions.net> (sfid-20120928_123917_337659_1AA6C9C6)
Subject: Re: [RFC v2] cfg80211: VHT regulatory
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Date: Fri, 28 Sep 2012 12:39:49 +0200
In-Reply-To: <50655B36.5060500@posedge.com>
References: <5046FB3D.6090803@posedge.com>
	   <1346852356.4364.9.camel@jlt4.sipsolutions.net>
	   <50481C2E.5040303@posedge.com>
	  <1346925298.5469.4.camel@jlt4.sipsolutions.net>
	  <50489165.1080902@posedge.com>
	 <1347019809.4256.21.camel@jlt4.sipsolutions.net>
	 <50655B36.5060500@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-09-28 at 13:39 +0530, Mahesh Palivela wrote:
> On 09/07/2012 05:40 PM, Johannes Berg wrote:
> >
> > We don't have to do any calculation in kernel though as far as I can
> > tell? Maybe we do need the channel, but I think in terms of
> > *specifying*, in particular in the nl80211 and cfg80211 APIs, we should
> > stick to the standard if we're going to change it now.
> >
> 
> struct ieee80211_channel_config {
>          enum ieee80211_chan_width chan_width;
>          u16 center_freq1;
>          u16 center_freq2;
>          u16 prim_chan_freq;
> };
> 
> If we stick to standard, all u16 become u8, as their values range is 
> from 1-200. But these numbers have to be converted to freqKHz in 
> reg_chan_use_permitted() to find fits in reg rule or not?
> Is that ok?

I prefer MHz for center freqs, but offset for the primary channel, and
this is exactly like table 22-22 in the 802.11ac draft, so only the "u16
primary_channel_freq" becomes "u8 primary_channel_offset", not all of
them change, no?

johannes

