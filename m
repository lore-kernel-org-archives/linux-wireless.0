Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f54.google.com ([209.85.192.54]:35522 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785AbbBBEFC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Feb 2015 23:05:02 -0500
Received: by mail-qg0-f54.google.com with SMTP id q108so45927198qgd.13
        for <linux-wireless@vger.kernel.org>; Sun, 01 Feb 2015 20:05:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAA_e5Z5PfimZeC5cqSk_xFpKOBeZ74htLeEdwtKieAYWJaEX+A@mail.gmail.com>
References: <CA+BoTQkVu23P3EOmY_Q3E1GJnWsyF==Pawz4iPOS_Bq5dvfO5Q@mail.gmail.com>
 <1422537297.21689.15.camel@edumazet-glaptop2.roam.corp.google.com>
 <54CB5D08.2070906@broadcom.com> <1422623975.21689.77.camel@edumazet-glaptop2.roam.corp.google.com>
 <54CB8B69.1070807@broadcom.com> <CAA93jw5fqhz0Hiw74L2GXgtZ9JsMg+NtYydKxKzGDrvQcZn4hA@mail.gmail.com>
 <CAA93jw7b0E9jjQYXrEPzjLLC9j8xNC0TFYXpWVtgFameJaNBdw@mail.gmail.com>
 <1422741065.199624134@apps.rackspace.com> <CAPp0ZBb2nkA6Y0s=W0kw=zvyn0wi0NMBRsBCw_xcD61ScOmgQg@mail.gmail.com>
 <CAA_e5Z46Bu+zZZFzf_ejzA35Gw3g1_OG85yv6yd7MpbwZcE-nw@mail.gmail.com>
 <CAA93jw7=oTex0Mp-0ThvuDRUnfR0N8tzdOQ8DD7QYWphp1b=4w@mail.gmail.com>
 <CAJq5cE3ETbpEtecFHmhgHQveNRUhVfrzjTOygHm-TRCTwHNyKA@mail.gmail.com>
 <1422801814.796219699@apps.rackspace.com> <CAA_e5Z5PfimZeC5cqSk_xFpKOBeZ74htLeEdwtKieAYWJaEX+A@mail.gmail.com>
From: Avery Pennarun <apenwarr@google.com>
Date: Sun, 1 Feb 2015 23:04:41 -0500
Message-ID: <CAPp0ZBbKu-B3yPf0Et=XByJ1SrnxBgVbRXr9PBe0f6P08w87=Q@mail.gmail.com> (sfid-20150202_050508_489331_8D46043F)
Subject: Re: [Cerowrt-devel] Fwd: Throughput regression with `tcp: refine TSO autosizing`
To: Andrew McGregor <andrewmcgr@gmail.com>
Cc: David Reed <dpreed@reed.com>,
	Jonathan Morton <chromatix99@gmail.com>,
	Dave Taht <dave.taht@gmail.com>,
	Matt Mathis <mattmathis@google.com>,
	Tim Shepard <shep@alum.mit.edu>, dstanley@arubanetworks.com,
	Kathy Giori <kgiori@qca.qualcomm.com>,
	Stig Thormodsrud <stig@ubnt.com>,
	Derrick Pallas <pallas@meraki.com>,
	"cerowrt-devel@lists.bufferbloat.net"
	<cerowrt-devel@lists.bufferbloat.net>,
	Mahesh Paolini-Subramanya <mahesh@dieswaytoofast.com>,
	Jim Gettys <jg@freedesktop.org>,
	Jesper Dangaard Brouer <jbrouer@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 1, 2015 at 6:34 PM, Andrew McGregor <andrewmcgr@gmail.com> wrote:
> I missed one item in my list of potential improvements: the most braindead
> thing 802.11 has to say about rates is that broadcast and multicast packets
> should be sent at 'the lowest basic rate in the current supported rate set',
> which is really wasteful.  There are a couple of ways of dealing with this:
> one, ignore the standard and pick the rate that is most likely to get the
> frame to as many neighbours as possible (by a scan of the Minstrel tables).
> Or two, fan it out as unicast, which might well take less airtime (due to
> aggregation) as well as being much more likely to be delivered, since you
> get ACKs and retries by doing that.

As far as I can see, the only sensible thing to do with
multicast/broadcast is some variation of the unicast fanout, unless
you've got a truly huge number of nodes.  I don't know of any
protocols (certainly not video streams) that actually work well with
the kind of packet loss you see at medium/long range with wifi if
retransmits aren't used.  I've heard that openwrt already has a patch
included that does this kind of fanout at the bridge layer.

I've also heard of a new "reliable multicast" in some newer 802.11
variant, which essentially sends out a single multicast packet and
expects an ACK from each intended recipient.  Other than adding
complexity, it seems like the best of both worlds.
