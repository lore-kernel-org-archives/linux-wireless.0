Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:33913 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbaFDPVh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 11:21:37 -0400
Received: by mail-lb0-f178.google.com with SMTP id w7so4446150lbi.9
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2014 08:21:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1401889560.6079.26.camel@jlt4.sipsolutions.net>
References: <1400180784-26008-1-git-send-email-kyeyoonp@qca.qualcomm.com>
 <1400231795.4112.21.camel@jlt4.sipsolutions.net> <E3DE377D7E4999489B304A8FF33FC0D103A211A7@nasanexd01g.na.qualcomm.com>
 <1401882426.6079.20.camel@jlt4.sipsolutions.net> <20140604134217.GA21759@jouni.qca.qualcomm.com>
 <1401889560.6079.26.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 4 Jun 2014 08:21:16 -0700
Message-ID: <CAB=NE6ULriTGGXs4Ht+KYEKkBKR38UV8L8XDhLp53nCDGOpXEA@mail.gmail.com> (sfid-20140604_172141_037526_58A0AA74)
Subject: Re: [RFC] cfg80211/mac80211: Add support for Proxy ARP
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	"Park, Kyeyoon" <kyeyoonp@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 4, 2014 at 6:46 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2014-06-04 at 16:42 +0300, Jouni Malinen wrote:
>> On Wed, Jun 04, 2014 at 01:47:06PM +0200, Johannes Berg wrote:
>> > It seems to me that ebtables should be able to filter on the ports
>> > already, so I'm not really sure what you mean by this.
>> >
>> > The real issue is the internal forwarding. Is that even necessary? Maybe
>> > instead the bridge could forward back to the same port in some cases,
>> > and you could just disable the internal forwarding in mac80211 entirely?
>>
>> I'd assume that for most Hotspot 2.0 use cases, internal forwarding
>> would be disabled completely, but there may very well be cases where one
>> would like to use ProxyARP with forwarding between associated stations.
>> Doing that through the bridge code above mac80211 should be fine,
>> though, i.e., there is no particular reason why the internal forwarding
>> really needs to be internal within mac80211 as long as the
>> implementation outside is doable (forward back to same port).
>
> Right - I think currently the forward back to the same port part would
> be missing. We should probably have a wider discussion with
> bridging/nftables/etc. folks.

I have some virtualization interests on this topic as well. The same
problem and need is present if one wants to implement a clean solution
to use 802.11 on the backend dom0 to share given we can't bridge
802.11, additionally there is a bit of overhead I see with existing
virtualization strategies on relying on full backend device drivers in
*addition* to the TAP interfaces created by qemu, what I hope for is
doing away with the backend device drivers completely. There are
issues with this architecturally though and although I'm not yet a fan
of the existing code the DPDK [0] code is one example strategy. The
way I was thinking about this was having APIs for userspace to deal
with the a proxy arp requirements which are currently not handled in
the kernel.

[0] http://dpdk.org/

  Luis
