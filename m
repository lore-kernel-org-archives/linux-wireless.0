Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55538 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671AbbERV4D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2015 17:56:03 -0400
Message-ID: <1431986157.10489.12.camel@sipsolutions.net> (sfid-20150518_235607_573466_6E77363E)
Subject: Re: mac80211 drops packet with old IV after rekeying
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Wetzel <alexander.wetzel@web.de>
Cc: "Peer, Ilan" <ilan.peer@intel.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 18 May 2015 23:55:57 +0200
In-Reply-To: <555A41EA.4090905@web.de>
References: <CANUX_P31bbOr8WhTY5D+M7QraVqJeCdw-qxME0GWmOQtLksb9A@mail.gmail.com>
		 <1431674716.2426.2.camel@sipsolutions.net>
		 <CANUX_P0HN5z-c6M_KcnJxT1LBPDP=OC9JnsaPPRf9RcDuw4hug@mail.gmail.com>
		 <1431714949.2117.0.camel@sipsolutions.net>
		 <CANUX_P2Xf9i9P3G5LgUm0bjCMSMpQwecJ1S4qH6RuurrkuSp-A@mail.gmail.com>
		 <1431806229.2120.6.camel@sipsolutions.net> <20150517160513.GA13175@w1.fi>
		 <CANUX_P0byd4Q+1gjiBmoGqd_hESUH_YVCD6iPx0_d6aw_r3JSw@mail.gmail.com>
		 <1431890756.2129.13.camel@sipsolutions.net>
		 <CANUX_P3ODruGc2rvV2gLNLU15kEmaJMXeU_ovtaBeOQGnYotoA@mail.gmail.com>
		 <1431893157.2129.18.camel@sipsolutions.net>
		 <CANUX_P0cJc4Ww5AY7sNFL5z4EPit+ngHvX=4eFXF96K-E8p3MA@mail.gmail.com>
		 (sfid-20150517_221304_420222_D8022C07) <1431894140.2129.20.camel@sipsolutions.net>
		 <CB3B3D4774441E42AA3EA0E1BA8230A04DA98D91@HASMSX110.ger.corp.intel.com>
	 <1431961331.10489.1.camel@sipsolutions.net> <555A41EA.4090905@web.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-05-18 at 21:47 +0200, Alexander Wetzel wrote:

> For my understanding that has already be done. And at least for me it
> looks like we have hard evidence for that fact.
[...]
> The Key information used to decrypt the packets is added in the same
> section as the key index, if you have problems finding it.

[building a new wireshark was awkward ... between their git being really
slow and the build needing to be completely deleted first ...]

I agree with you - what you can see in the capture, assuming the TK/PMK
display is correct, is that

packet 11: PN 0x11F2B, old key
packet 15: PN 0x11F40, old key 
packet 19: PN 0x11F2C, new key

Note how packet 15, since it's VO priority, goes out far before packet
19, although packet 19 got the sequence number immediately after packet
11.

So... I guess we can, for now, go back to my earlier email and look at
the transmitter problem after all. I still think the receiver has a
similar issue though.

To be honest though, I'm not sure how to really solve this. Without
multi index capability, the spec doesn't really support PTK rekeying
well. With it, this is clearly no problem, but that would depend on more
code and driver support etc. and perhaps can't even be done with all
drivers/devices.

The first idea here would be to stop using HW crypto for TX while
changing the key, but I think at least ath10k wouldn't support that, not
sure what would happen though? Either way, it'd need a TX path flush, so
I guess it doesn't really make a difference.

So really, I guess what we need to do - and this will suck for
performance - is to stop queues and flush the TX path while the old key
is still programmed into the device, reinstall the key, and only then
restart transmission...

johannes

