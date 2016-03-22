Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:36819 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758595AbcCVOYR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2016 10:24:17 -0400
Received: by mail-oi0-f41.google.com with SMTP id r187so177059884oih.3
        for <linux-wireless@vger.kernel.org>; Tue, 22 Mar 2016 07:24:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQ=hgkm2AwMb=kinx+Ezf3vjduCKNH4LNRcV_goDWH4_Vg@mail.gmail.com>
References: <CAA93jw5AAWua23TbQHZX47XcFLEqU6T=NpxuLqa6FiffBf91Fw@mail.gmail.com>
	<CA+BoTQ=hgkm2AwMb=kinx+Ezf3vjduCKNH4LNRcV_goDWH4_Vg@mail.gmail.com>
Date: Tue, 22 Mar 2016 07:24:15 -0700
Message-ID: <CAA93jw7h6sTe=4pFi3-Rxqa45bNoRyYMSfzWxbb5GbLRJ02SJQ@mail.gmail.com> (sfid-20160322_152420_058239_61D7DF8E)
Subject: Re: [RFCv2 0/3] mac80211: implement fq codel
From: Dave Taht <dave.taht@gmail.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Jasmine Strong <jas@eero.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	make-wifi-fast@lists.bufferbloat.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have a huge cc list on this thread, and admittedly this work does
cut across a great deal of wireless, potentially, but does netdev need
to be on it?
there's been nothing codel specific on it in a while, so I cut those
from the cc.

On Tue, Mar 22, 2016 at 1:05 AM, Michal Kazior <michal.kazior@tieto.com> wrote:
> On 21 March 2016 at 18:10, Dave Taht <dave.taht@gmail.com> wrote:
>> thx.
>>
>> a lot to digest.
>>
>> A) quick notes on "flent-gui bursts_11e-2016-03-21T09*.gz"
>>
>> 1) the new bursts_11e test *should* have stuck stuff in the VI and VO
>> queues, and there *should* have been some sort of difference shown on
>> the plots with it. There wasn't.
>
> traffic-gen generates only BE traffic. Everything else runs UDP_RR
> which doesn't generate a lot of traffic.
>
>
>> For diffserv markings I used BE=CS0, BK=CS1, VI=CS5, and VO=EF.
>> CS6/CS7 should also land in VO (at least with the soft mac handler
>> last I looked). Is there a way to check if you are indeed exercising
>> all four 802.11e hardware queues in this test? in ath9k it is the
>> "xmit" sysfs var....
>
> Hmm.. there are no txq stats. I guess it makes sense to have them?

ath9k xmit has been useful to capture. I'm kind of unconvinced those
stats are correct, at the moment, but...

> There is /sys/kernel/debug/ieee80211/phy*/fq which dumps state of all
> queues which will be mostly empty with UDP_RR. You can run netperf UDP
> stream with diffserv marking to see onto which tid they are mapped.
> You can see tid-AC mappings here:
> https://wireless.wiki.kernel.org/en/developers/documentation/mac80211/queues

We can try to capture those, but sampling summary per-station stats
ties back better to actual traffic analysis.

Also useful to capture has been the minstrel stats, the minstrel-blues
version provided these in a handy csv format.

> I just checked and EF ends up as tid5 which is VI. It's actually the
> same as CS5. You can use CS7 to run on tid7 which is VO.

The intent of CS6 is somewhat incompatible with VO's intent, but we
can argue diffserv's usefulness and mappings another day.

I have changed the bursts_11e test to use CS7, which will break
parsing our previous test runs' data, but actually test what I'd
intended to test in the first place.

>> 2) In all the old cases the BE UDP_RR flow died on the first burst
>> (why?), and the fullpatch preserved it.
>
> I think it's related to my setup which involves veth pairs. I use them
> to simulate bridging/AP behavior but maybe it's not doing the job
> right, hmm..
>
>
>> (I would have kind of hoped to
>> have seen the BK flow die, actually, in the fullpatch)
>
> There's no extra weight priority to BK. The difference between BE and
> BK in 802.11 is contention window access time so BK gets less txops
> statistically. Both share the same txop, which is 5.484ms in most
> cases.

Um, well, another day.

>
>> 3) I am also confused on 802.11ac - can VO aggregate? ( can't in in 802.11n).
>
> Yes, it should be albeit VI and VO have shorter txop compared to
> BE/BK: 3.008ms and 1.504ms respectively.

Not being able to aggregate in VO in n was a bad thing. There is an
awful lot I like about ac over n.

>
> UDP_RR doesn't really create a lot of opportunities for aggregation.
> If you want to see how different queues behave when loaded you'll need
> to modify traffic-gen and add bursts across different ACs in the
> bursts_11e test.

or flood the queues with other tests like rrul or toke's enhancement
to traffic-gen. :) I liked being able to arbitrarily mark udp packets
ecn capable...

>
>
> Michał
