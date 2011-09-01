Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42893 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185Ab1IAPIP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 11:08:15 -0400
Message-ID: <4E5F9FDA.3020901@freedesktop.org> (sfid-20110901_170824_407340_BE9247BA)
Date: Thu, 01 Sep 2011 11:08:10 -0400
From: Jim Gettys <jg@freedesktop.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Andrew McGregor <andrewmcgr@gmail.com>,
	Adrian Chadd <adrian@freebsd.org>,
	Tom Herbert <therbert@google.com>,
	Dave Taht <dave.taht@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Matt Smith <smithm@qca.qualcomm.com>,
	Kevin Hayes <hayes@qca.qualcomm.com>,
	Derek Smithies <derek@indranet.co.nz>, netdev@vger.kernel.org
Subject: Re: BQL crap and wireless
References: <CAB=NE6VuP=AvYiJsYn_Noc1u0Q=jvQPutHRANdSiLP2v48ogfg@mail.gmail.com> <CAB=NE6VwWu5+Hk7=3ghkgiXss9kCqGyS-RWPYtyHRhDsx5r2rA@mail.gmail.com> <CAA93jw7c+Nxc6ZbWZWsQ+F78AoPWU=quSRaOUpT0yRcwJOXsGQ@mail.gmail.com> <4E5C3B47.1050809@freedesktop.org> <CA+mtBx-j_+mrNpntR7CfYOromDnM-ZGzvebpUCjC8Qf14X6u9g@mail.gmail.com> <CAJ-Vmonwur-SXddNwjPEidCMqes+PwbRWFBddfdwTp2jOMu64g@mail.gmail.com> <4E5CEC79.3090802@freedesktop.org> <9BB251C1-A211-486D-A717-59149AC3A709@gmail.com> <4E5E36EE.8080501@freedesktop.org> <CAB=NE6Wj4BxSjZmTOg9EFMcJ+H0RBZE4q8+6DB3x8qP=r42yNQ@mail.gmail.com> <20110901141304.GA2580@tuxdriver.com>
In-Reply-To: <20110901141304.GA2580@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/01/2011 10:13 AM, John W. Linville wrote:
> On Wed, Aug 31, 2011 at 01:50:48PM -0700, Luis R. Rodriguez wrote:
>> On Wed, Aug 31, 2011 at 6:28 AM, Jim Gettys <jg@freedesktop.org> wrote:
>> such as wireless, or even possibly modern broadband with
>> PowerBoost, classic RED or similar algorithms that do not take the
>> buffer drain rate cannot possibly hack it properly.
>> Understood, just curious if anyone has tried a Minstrel approach.
> FWIW, eBDP and the related algorithms from Tianji Li's paper are
> philosophically similar to minstrel.  They depend on measuring recent
> conditions and modifying the current queue length accordingly.
>
> 	http://www.hamilton.ie/tianji_li/buffersizing.pdf
>
> The hack I added in debloat-testing is based on my understanding
> of eBDP.  It timestamps the SKBs when they are handed to the driver
> for Tx and then checks the timestamp when the SKB is orphaned.  It is
> a bit crude and is an abuse of the skb_orphan API.  Also while it
> accounts for the 802.11e queues separately, it doesn't account for
> 802.11n aggregation.  Still, it seems to improve latency w/o hugely
> impacting throughput in at least some environments -- YMMV!
>
Certainly eBDP *sort of* works for me; I see somewhat more variation
(jitter) than I'd like, but at least latencies are at least somewhat
controlled and I've not seen performance (throughput) problems.  This is
on an Intel chipset.

Tanji Li's work and eBDP came to our attention after a conversation I
had with Van at the beginning of this year; Van send me a pointer to it
with the comments:

"As I said on the phone I think there's an easier, more robust way to accomplish the same
thing but they have running code and I don't."


But we've not had time to do any systematic testing on eBDP yet and the
implementation needs more work before it should go upstream.

About the time we were thinking of starting that testing, it became
clear that getting aggregation working better was pretty essential to
validating any results.  I'm looking forward to trying eBDP with the
revised Ath9k driver as soon as they get put into a single pool.  And if
Kathleen and Van can get a "RED Light" they are happy with, that will be
fun to try as well.
                                - Jim






