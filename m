Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:33761 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758003AbcCVIFf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2016 04:05:35 -0400
Received: by mail-wm0-f53.google.com with SMTP id l68so180580003wml.0
        for <linux-wireless@vger.kernel.org>; Tue, 22 Mar 2016 01:05:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA93jw5AAWua23TbQHZX47XcFLEqU6T=NpxuLqa6FiffBf91Fw@mail.gmail.com>
References: <CAA93jw5AAWua23TbQHZX47XcFLEqU6T=NpxuLqa6FiffBf91Fw@mail.gmail.com>
Date: Tue, 22 Mar 2016 09:05:32 +0100
Message-ID: <CA+BoTQ=hgkm2AwMb=kinx+Ezf3vjduCKNH4LNRcV_goDWH4_Vg@mail.gmail.com> (sfid-20160322_090548_664809_C2E17077)
Subject: Re: [RFCv2 0/3] mac80211: implement fq codel
From: Michal Kazior <michal.kazior@tieto.com>
To: Dave Taht <dave.taht@gmail.com>
Cc: Jasmine Strong <jas@eero.com>,
	Network Development <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"codel@lists.bufferbloat.net" <codel@lists.bufferbloat.net>,
	make-wifi-fast@lists.bufferbloat.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 March 2016 at 18:10, Dave Taht <dave.taht@gmail.com> wrote:
> thx.
>
> a lot to digest.
>
> A) quick notes on "flent-gui bursts_11e-2016-03-21T09*.gz"
>
> 1) the new bursts_11e test *should* have stuck stuff in the VI and VO
> queues, and there *should* have been some sort of difference shown on
> the plots with it. There wasn't.

traffic-gen generates only BE traffic. Everything else runs UDP_RR
which doesn't generate a lot of traffic.


> For diffserv markings I used BE=CS0, BK=CS1, VI=CS5, and VO=EF.
> CS6/CS7 should also land in VO (at least with the soft mac handler
> last I looked). Is there a way to check if you are indeed exercising
> all four 802.11e hardware queues in this test? in ath9k it is the
> "xmit" sysfs var....

Hmm.. there are no txq stats. I guess it makes sense to have them?

There is /sys/kernel/debug/ieee80211/phy*/fq which dumps state of all
queues which will be mostly empty with UDP_RR. You can run netperf UDP
stream with diffserv marking to see onto which tid they are mapped.
You can see tid-AC mappings here:
https://wireless.wiki.kernel.org/en/developers/documentation/mac80211/queues

I just checked and EF ends up as tid5 which is VI. It's actually the
same as CS5. You can use CS7 to run on tid7 which is VO.


> 2) In all the old cases the BE UDP_RR flow died on the first burst
> (why?), and the fullpatch preserved it.

I think it's related to my setup which involves veth pairs. I use them
to simulate bridging/AP behavior but maybe it's not doing the job
right, hmm..


> (I would have kind of hoped to
> have seen the BK flow die, actually, in the fullpatch)

There's no extra weight priority to BK. The difference between BE and
BK in 802.11 is contention window access time so BK gets less txops
statistically. Both share the same txop, which is 5.484ms in most
cases.


> 3) I am also confused on 802.11ac - can VO aggregate? ( can't in in 802.11n).

Yes, it should be albeit VI and VO have shorter txop compared to
BE/BK: 3.008ms and 1.504ms respectively.

UDP_RR doesn't really create a lot of opportunities for aggregation.
If you want to see how different queues behave when loaded you'll need
to modify traffic-gen and add bursts across different ACs in the
bursts_11e test.


Michał
