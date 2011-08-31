Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42895 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab1HaUvJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 16:51:09 -0400
MIME-Version: 1.0
In-Reply-To: <4E5E36EE.8080501@freedesktop.org>
References: <CAB=NE6VuP=AvYiJsYn_Noc1u0Q=jvQPutHRANdSiLP2v48ogfg@mail.gmail.com>
 <CAB=NE6VwWu5+Hk7=3ghkgiXss9kCqGyS-RWPYtyHRhDsx5r2rA@mail.gmail.com>
 <CAA93jw7c+Nxc6ZbWZWsQ+F78AoPWU=quSRaOUpT0yRcwJOXsGQ@mail.gmail.com>
 <4E5C3B47.1050809@freedesktop.org> <CA+mtBx-j_+mrNpntR7CfYOromDnM-ZGzvebpUCjC8Qf14X6u9g@mail.gmail.com>
 <CAJ-Vmonwur-SXddNwjPEidCMqes+PwbRWFBddfdwTp2jOMu64g@mail.gmail.com>
 <4E5CEC79.3090802@freedesktop.org> <9BB251C1-A211-486D-A717-59149AC3A709@gmail.com>
 <4E5E36EE.8080501@freedesktop.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 31 Aug 2011 13:50:48 -0700
Message-ID: <CAB=NE6Wj4BxSjZmTOg9EFMcJ+H0RBZE4q8+6DB3x8qP=r42yNQ@mail.gmail.com> (sfid-20110831_225114_498953_9AA5B1D0)
Subject: Re: BQL crap and wireless
To: Jim Gettys <jg@freedesktop.org>
Cc: Andrew McGregor <andrewmcgr@gmail.com>,
	Adrian Chadd <adrian@freebsd.org>,
	Tom Herbert <therbert@google.com>,
	Dave Taht <dave.taht@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Matt Smith <smithm@qca.qualcomm.com>,
	Kevin Hayes <hayes@qca.qualcomm.com>,
	Derek Smithies <derek@indranet.co.nz>, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 31, 2011 at 6:28 AM, Jim Gettys <jg@freedesktop.org> wrote:
> On 08/30/2011 05:47 PM, Andrew McGregor wrote:
>> On 31/08/2011, at 1:58 AM, Jim Gettys wrote:
>>
>>> On 08/29/2011 11:42 PM, Adrian Chadd wrote:
>>>> On 30 August 2011 11:34, Tom Herbert <therbert@google.com> wrote:
>>>>
>>>> C(P) is going to be quite variable - a full frame retransmit of a 4ms
>>>> long aggregate frame is SUM(exponential backoff, grab the air,
>>>> preamble, header, 4ms, etc. for each pass.)
>>>>
>>> It's not clear to me that doing heroic measures to compute the cost is
>>> going to be worthwhile due to the rate at which the costs can change on
>>> wireless; just getting into the rough ballpark may be enough. But
>>> buffering algorithms and AQM algorithms are going to need an estimate of
>>> the *time* it will take to transmit data, more than # of bytes or packets.
>> That's not heroic measures; mac80211 needs all the code to calculate these times anyway, it's just a matter of collecting together some things we already know and calling the right function.
>>
>>
>
> Fine; if it's easy, accurate is better (presuming the costs get
> recalculated when circumstances change). We also will need the amount of
> data being transmitted; it is the rate of transmission (the rate at
> which the buffers are draining) that we'll likely need.
>
> Here's what I've gleaned from reading "RED in a different light",  Van
> Jacobson's Mitre talk and several conversations with Kathleen Nichols
> and Van: AQM algorithms that can handle variable bandwidth environments
> will need to be able to know the rate at which buffers empty.  It's the
> direction they are going with their experiments on a "RED light" algorithm.
>
> The fundamental insight as to why classic RED can't work in the wireless
> environment is that the instantaneous queue length has little actual
> information in it.

Can you elaborate? Mind you I know squat about AQM but am curious
about what *is* required here.

> Classic RED is tuned using the queue length as its
> basic parameter.  Their belief as to algorithms that will work is that
> the need to keep track of the running queue length *minimum over time*;
> you want to keep the buffers small on a longer term basis (so they both
> can absorb transients, which is their reason for existence, while
> keeping the latency typically low).

I think I get this.

Now, I do care about the above details of what is needed but -- it
still puzzles me that no algorithm on addressing this has been
developed that simply does trial and error to fixate on the
appropriate queue length. Do we know the outcome of using a "bad queue
length", is it the latency issues? If so then can we not use latency
as a reactive measure to help us fine-tune the desired queue length.
This would be PHY agnostic. This is what I was luring to earlier when
I had mentioned using the approach Minstrel takes to solve the rate
control problem. I've lately been fixating on these sort of algorithms
approaches as solutions to complex problems as inspired by Tim
Harford's elaboration on the God complex on a TED Talk:

http://www.youtube.com/watch?v=K5wCfYujRdE

> The additional major challenge we
> face that core routers do not is the highly variable traffic of mixed
> mice and elephants.  What actually works only time will tell.

Thank you for elaborating on this, it helps to further dissect the
issues. When mixing them together it makes the task harder to address.
As for 802.11 we'd just need to worry about management frames. Dave
and Andrew had also pointed out issues with multicast and the low
rates used for them in comparison to unicast transmissions.

> So in an environment in which the rate of transmission is highly
> variable,

Not only that, remember we have different possible topologies
depending on the type of 802.11 service used, IBSS, the typical AP-STA
environment, Mesh, P2P (AP-STA really), and now with 802.11ad we get
PBSS. What counts here is we may have variable rate of transmission to
different possible peers, as such the queue length will depend on all
of the expected transmissions.

> such as wireless, or even possibly modern broadband with
> PowerBoost, classic RED or similar algorithms that do not take the
> buffer drain rate cannot possibly hack it properly.

Understood, just curious if anyone has tried a Minstrel approach.

Lets try to document all of this here:

http://wireless.kernel.org/en/developers/bufferbloat

  Luis
