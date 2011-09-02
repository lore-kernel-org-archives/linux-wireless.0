Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f42.google.com ([209.85.216.42]:59088 "EHLO
	mail-qw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756285Ab1IBWDY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 18:03:24 -0400
MIME-Version: 1.0
In-Reply-To: <20110901141304.GA2580@tuxdriver.com>
References: <CAB=NE6VuP=AvYiJsYn_Noc1u0Q=jvQPutHRANdSiLP2v48ogfg@mail.gmail.com>
 <CAB=NE6VwWu5+Hk7=3ghkgiXss9kCqGyS-RWPYtyHRhDsx5r2rA@mail.gmail.com>
 <CAA93jw7c+Nxc6ZbWZWsQ+F78AoPWU=quSRaOUpT0yRcwJOXsGQ@mail.gmail.com>
 <4E5C3B47.1050809@freedesktop.org> <CA+mtBx-j_+mrNpntR7CfYOromDnM-ZGzvebpUCjC8Qf14X6u9g@mail.gmail.com>
 <CAJ-Vmonwur-SXddNwjPEidCMqes+PwbRWFBddfdwTp2jOMu64g@mail.gmail.com>
 <4E5CEC79.3090802@freedesktop.org> <9BB251C1-A211-486D-A717-59149AC3A709@gmail.com>
 <4E5E36EE.8080501@freedesktop.org> <CAB=NE6Wj4BxSjZmTOg9EFMcJ+H0RBZE4q8+6DB3x8qP=r42yNQ@mail.gmail.com>
 <20110901141304.GA2580@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 2 Sep 2011 15:03:02 -0700
Message-ID: <CAB=NE6VvEX87on9QL7=3OrZtopoASzyLBTweEmzO0ZxU8NNJCA@mail.gmail.com> (sfid-20110903_000327_503802_E77EE841)
Subject: Re: BQL crap and wireless
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jim Gettys <jg@freedesktop.org>,
	Andrew McGregor <andrewmcgr@gmail.com>,
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

On Thu, Sep 1, 2011 at 7:13 AM, John W. Linville <linville@tuxdriver.com> wrote:
> On Wed, Aug 31, 2011 at 01:50:48PM -0700, Luis R. Rodriguez wrote:
>> On Wed, Aug 31, 2011 at 6:28 AM, Jim Gettys <jg@freedesktop.org> wrote:
>
>> > such as wireless, or even possibly modern broadband with
>> > PowerBoost, classic RED or similar algorithms that do not take the
>> > buffer drain rate cannot possibly hack it properly.
>>
>> Understood, just curious if anyone has tried a Minstrel approach.
>
> FWIW, eBDP and the related algorithms from Tianji Li's paper are
> philosophically similar to minstrel.

Oh look at that, awesome!!!

>  They depend on measuring recent
> conditions and modifying the current queue length accordingly.
>
>        http://www.hamilton.ie/tianji_li/buffersizing.pdf
>
> The hack I added in debloat-testing is based on my understanding
> of eBDP.  It timestamps the SKBs when they are handed to the driver
> for Tx and then checks the timestamp when the SKB is orphaned.  It is
> a bit crude and is an abuse of the skb_orphan API.

Neat!

>  Also while it
> accounts for the 802.11e queues separately, it doesn't account for
> 802.11n aggregation.

I see..

>  Still, it seems to improve latency w/o hugely
> impacting throughput in at least some environments -- YMMV!

Sweet dude. For aggregation it seems the way to go is to get some
helpers as Andrew has suggested. Andrew, can you elaborate a little on
that? If feasible, then maybe then we can add it to the TODO list
page:

http://wireless.kernel.org/en/developers/todo-list

and when one of us gets to it, we get cranking on it.

  Luis
