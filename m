Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42726 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965452AbbLPNZN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 08:25:13 -0500
Message-ID: <1450272308.8247.11.camel@sipsolutions.net> (sfid-20151216_142519_012370_8D223887)
Subject: Re: question on "mac80211_hwsim: support any address in userspace"
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>
Date: Wed, 16 Dec 2015 14:25:08 +0100
In-Reply-To: <56716386.4070107@candelatech.com>
References: <5670DA9A.4010102@candelatech.com>
		 (sfid-20151216_042934_976896_DCE1A2B3) <1450257464.3159.1.camel@sipsolutions.net>
	 <56716386.4070107@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-12-16 at 05:13 -0800, Ben Greear wrote:
> On 12/16/2015 01:17 AM, Johannes Berg wrote:
> > On Tue, 2015-12-15 at 19:29 -0800, Ben Greear wrote:
> > > This patch below was added to the kernel around 2/24/2015
> > > 
> > > I am curious mostly about the first change:  I thought the
> > > transmitter-addr relates to the radio device, not the vdev (sta,
> > > ap,
> > > etc).
> > 
> > It doesn't, even on real hardware.
> 
> No, I mean that the HWSIM_ATTR_ADDR_TRANSMITTER should relate to the
> radio, and not the vdev, see the mac80211_hwsim.h:
> 
>   * @HWSIM_ATTR_ADDR_TRANSMITTER: MAC address of the radio device that
>   *	the frame was broadcasted from

I think that just means the documentation is misleading. Clearly, the
TA (hdr->addr2) is intended and implemented. "radio device" is a bit of
a misleading term when you have virtual interfaces.

> Since we are asking user-space to provide HWSIM_ATTR_ADDR_TRANSMITTER,
> then we can use that to find the radio device.  Then, normal mac80211
> logic can handle finding the vdevs (just as it does for ath9k).

Oh.

So you're basically arguing that we should treat it as a cookie, and on
outgoing frames give the hardware address, and on incoming frames use
it only to look up the struct mac80211_hwsim_data.

> And in this case, there is no reason to have more than one address
> associated with the hwsim radio device.  We could add a pretty simple
> hash to keep the lookup near constant time instead of linear search
> as the current behaviour is...

Yeah, ok, that would be (have been) doable I guess. We'd still have the
real TA in the frame itself (hdr->addr2).

> I think that wmediumd should keep it's own mapping of what radio
> a vdev is on and use the proper hwsim radio addr for the
> HWSIM_ATTR_ADDR_TRANSMITTER attribute.

That's somewhat difficult for it, since it could only populate that
mapping on actual TX frames.

I think this is pretty much a done deal by now though since I don't
really want to break wmediumd.

If we wanted to go this route I think we should be more explicit and
simply use the HWSIM_ATTR_RADIO_ID attribute. We could support that
easily - just see if the RADIO_ID is present and look up the
transmitter (or receiver btw) radio based on the RADIO_ID if present -
that gives a clean path forward too since wmediumd can be taught to
specify both knowing the kernel will prefer the radio ID if present.

johannes
