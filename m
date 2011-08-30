Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43983 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab1H3N6U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 09:58:20 -0400
Message-ID: <4E5CEC79.3090802@freedesktop.org> (sfid-20110830_155825_987711_F1F3ACBA)
Date: Tue, 30 Aug 2011 09:58:17 -0400
From: Jim Gettys <jg@freedesktop.org>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: Tom Herbert <therbert@google.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Dave Taht <dave.taht@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Andrew McGregor <andrewmcgr@gmail.com>,
	Matt Smith <smithm@qca.qualcomm.com>,
	Kevin Hayes <hayes@qca.qualcomm.com>,
	Derek Smithies <derek@indranet.co.nz>, netdev@vger.kernel.org
Subject: Re: BQL crap and wireless
References: <CAB=NE6VuP=AvYiJsYn_Noc1u0Q=jvQPutHRANdSiLP2v48ogfg@mail.gmail.com> <CAB=NE6VwWu5+Hk7=3ghkgiXss9kCqGyS-RWPYtyHRhDsx5r2rA@mail.gmail.com> <CAA93jw7c+Nxc6ZbWZWsQ+F78AoPWU=quSRaOUpT0yRcwJOXsGQ@mail.gmail.com> <4E5C3B47.1050809@freedesktop.org> <CA+mtBx-j_+mrNpntR7CfYOromDnM-ZGzvebpUCjC8Qf14X6u9g@mail.gmail.com> <CAJ-Vmonwur-SXddNwjPEidCMqes+PwbRWFBddfdwTp2jOMu64g@mail.gmail.com>
In-Reply-To: <CAJ-Vmonwur-SXddNwjPEidCMqes+PwbRWFBddfdwTp2jOMu64g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/29/2011 11:42 PM, Adrian Chadd wrote:
> On 30 August 2011 11:34, Tom Herbert <therbert@google.com> wrote:
>
>> The generalization of BQL would be to set the queue limit in terms of
>> a cost function implemented by the driver.  The cost function would
>> most likely be an estimate of time to transmit a packet.  So C(P)
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
>
> C(P) is going to be quite variable - a full frame retransmit of a 4ms
> long aggregate frame is SUM(exponential backoff, grab the air,
> preamble, header, 4ms, etc. for each pass.)
>
It's not clear to me that doing heroic measures to compute the cost is
going to be worthwhile due to the rate at which the costs can change on
wireless; just getting into the rough ballpark may be enough. But
buffering algorithms and AQM algorithms are going to need an estimate of
the *time* it will take to transmit data, more than # of bytes or packets.

Ultimately, if the queue starts builds, we'll need an AQM algorithm to
control the buffer growth.

Hopefully we can start testing SFB and other possibilities in CeroWrt
soon; Kathleen Nichols and Van Jacobson have been making some progress
on an algorithm called "RED light" which is based on the observed
transfer rate as well.  The eBDP algorithm in debloat testing also
helps, which Van pointed us at late last year when this came up (though
John Linville says eBDP needs rework before it can go upstream). We
didn't want to start testing SFB and other options while we were aware
of other problems in the wireless driver itself; Andrew and Felix's work
with Dave have apparently brought that problem to a decent point. 
                - Jim

