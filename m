Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:61678 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab1H3EXV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 00:23:21 -0400
Subject: Re: BQL crap and wireless
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=US-ASCII
From: Andrew McGregor <andrewmcgr@gmail.com>
In-Reply-To: <CAJ-Vmonwur-SXddNwjPEidCMqes+PwbRWFBddfdwTp2jOMu64g@mail.gmail.com>
Date: Tue, 30 Aug 2011 16:23:14 +1200
Cc: Tom Herbert <therbert@google.com>, Jim Gettys <jg@freedesktop.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Dave Taht <dave.taht@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Matt Smith <smithm@qca.qualcomm.com>,
	Kevin Hayes <hayes@qca.qualcomm.com>,
	Derek Smithies <derek@indranet.co.nz>, netdev@vger.kernel.org
Message-Id: <5DE4D38D-82A8-413B-98A4-A544C40D3827@gmail.com> (sfid-20110830_062326_392226_7751E8D8)
References: <CAB=NE6VuP=AvYiJsYn_Noc1u0Q=jvQPutHRANdSiLP2v48ogfg@mail.gmail.com> <CAB=NE6VwWu5+Hk7=3ghkgiXss9kCqGyS-RWPYtyHRhDsx5r2rA@mail.gmail.com> <CAA93jw7c+Nxc6ZbWZWsQ+F78AoPWU=quSRaOUpT0yRcwJOXsGQ@mail.gmail.com> <4E5C3B47.1050809@freedesktop.org> <CA+mtBx-j_+mrNpntR7CfYOromDnM-ZGzvebpUCjC8Qf14X6u9g@mail.gmail.com> <CAJ-Vmonwur-SXddNwjPEidCMqes+PwbRWFBddfdwTp2jOMu64g@mail.gmail.com>
To: Adrian Chadd <adrian@freebsd.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 30/08/2011, at 3:42 PM, Adrian Chadd wrote:

> On 30 August 2011 11:34, Tom Herbert <therbert@google.com> wrote:
> 
>> The generalization of BQL would be to set the queue limit in terms of
>> a cost function implemented by the driver.  The cost function would
>> most likely be an estimate of time to transmit a packet.  

That's a great idea.  Best that it be in nanoseconds, we may well have some seriously fast network interfaces to deal with.

>> So C(P)
>> could represent cost of a packet, sum(C(P) for P queued) is aggregate
>> cost of queue packets, and queue limit is the maximum cost sum.  For
>> wired Ethernet, number of bytes in packet might be a reasonable
>> function (although framing cost could be included, but I'm not sure
>> that would make a material difference).  For wireless, maybe the
>> function could be more complex possibly taking multicast, previous
>> history of transmission times, or other arbitrary characteristics of
>> the packet into account...
>> 
>> I can post a new patch with this generalization if this is interesting.
> 
> As I said before, I think this is the kind of thing the rate control
> code needs to get its dirty hands into.
> 
> With 802.11 you have to care about the PHY side of things too, so your
> cost suddenly would include the PER for combinations of {remote node,
> antenna setup, TX rate, sub-frame length, aggregate length}, etc. Do
> you choose that up front and then match a cost to it, or do you
> involve the rate control code in deciding a "good enough" way of
> handling what's on the queue by making rate decisions, then implement
> random/weighted/etc drop of what's left? Do you do some weighted/etc
> drop beforehand in the face of congestion, then pass what's left to
> the rate control code, then discard the rest?

Since Minstrel already knows an estimate of the PER to each remote node (expressed in terms of success probability per shot, so there's a bit of math to do), and the stack knows about transmit times, implementing a way to ask the question isn't particularly hard.  Other rate controls could make up their own guesstimates based on whatever factors they want to use.

However, that's going to change rapidly, so I suggest that we want some backlog grooming on a regular basis (like, after each rate control iteration) that might well reevaluate and drop or mark packets that are already in the queues.

> 
> C(P) is going to be quite variable - a full frame retransmit of a 4ms
> long aggregate frame is SUM(exponential backoff, grab the air,
> preamble, header, 4ms, etc. for each pass.)
> 
> 
> Adrian

Indeed.

Andrew

