Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37515 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab3FKMb2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 08:31:28 -0400
Message-ID: <1370953885.8356.38.camel@jlt4.sipsolutions.net> (sfid-20130611_143131_236242_E2628075)
Subject: Re: [RFC 0/4] add master channel switch announcement support
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Tue, 11 Jun 2013 14:31:25 +0200
In-Reply-To: <20130514092734.GA16426@pandem0nium>
References: <1367867635-3459-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1368439778.8300.20.camel@jlt4.sipsolutions.net>
	 <20130514092734.GA16426@pandem0nium>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > >  * channels are announced by adding IEs (CSA and Extended CSA) in beacons
> > >  * after some (configurable) time, the channel is switched
> > >  * with the channel switch, CSA/ECSA IEs are removed and channel information
> > >    is updated.
> > >  * Userspace calls a new command NL80211_CMD_CHANNEL_SWITCH along with channel info
> > >    (freq + width), whether traffic should be blocked and timing information
> > >  * it currently works for me [TM] on my ath9k based machine
> > 
> > I don't really like your approach of building all the IEs in the kernel.
> > There are some things, like the country-after-switch in the CSA wrapper
> > (introduced in 11ac), that would be really awkward this way.
> 
> Hmm ... OK. I have not checked 802.11ac yet (actually I don't have access to the
> drafts anyway). So what we have to expect is changing the country after the switch,
> or also other new things?

There are a few things in the channel switch wrapper: new country, wide
bandwidth channel switch, new VHT transmit power envelope. I guess the
intention is to allow for extensions in the future.

> > >  * could other drivers (next to ath9k) work with this API?
> > 
> > Probably not easily. Any TI folks reading this?
> 
> I was thinking about adding another callback function or option for that for drivers
> who do the channel switch internally. Then we would only need mac80211 to adapt.
> 
> Would that help, or what would be problematic?

I don't really know. If you look at what we do in managed mode now, some
drivers will do the switching and report back when done.

> Yeah, that would be an alternative. I've been inspired by IEEE 802.11-2012/6.3.17
> (MLME-CHANNELSWITCH) originally. :)
> I think your suggestion is good for AP where we control the beacon. For IBSS it
> would be a little different: when a channel switch is triggered, userspace does
> not know the beacon (and will not set it). Therefore, we could only accept the
> change IEs and skip the "after-switch-beacon" IEs (these would be re-generated
> internally) in IBSS mode. I guess it would be similar for mesh.

Yeah, agree, IBSS/mesh modes are somewhat different here, userspace
doesn't really know the channel is switching at all, does it?

johannes

