Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53385 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbbERPCQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2015 11:02:16 -0400
Message-ID: <1431961331.10489.1.camel@sipsolutions.net> (sfid-20150518_170220_132763_1E264E2C)
Subject: Re: mac80211 drops packet with old IV after rekeying
From: Johannes Berg <johannes@sipsolutions.net>
To: "Peer, Ilan" <ilan.peer@intel.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	"alexander.wetzel@web.de" <alexander.wetzel@web.de>,
	Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 18 May 2015 17:02:11 +0200
In-Reply-To: <CB3B3D4774441E42AA3EA0E1BA8230A04DA98D91@HASMSX110.ger.corp.intel.com>
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
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-05-18 at 06:14 +0000, Peer, Ilan wrote:

> There is probably no synchronization between the 4way HS and other
> data traffic on the transmitter side, as these are different
> processes. So it is possible that after receiving message 3 and before
> setting the keys, the HW would be able to decrypt additional frames
> with the old key.

Right. I think the "new key with old PN" part is probably not really
happening, although it seems possible. I'd think we should look at the
receiver first and only then move on to the transmitter if issues
persist. Having a sniffer capture of the problem with known keys (!)
would be useful though.


> AFAIK, the PTK is installed immediately after the 4th message is sent
> without waiting to ACK or any other delay. As the AP (should) installs
> the keys only after processing the 4th message, so a delay is
> expected.

Makes sense.

johannes

