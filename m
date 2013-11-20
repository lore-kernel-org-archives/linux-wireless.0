Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:62373 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab3KTQT5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 11:19:57 -0500
Received: by mail-wg0-f46.google.com with SMTP id x12so9186471wgg.13
        for <linux-wireless@vger.kernel.org>; Wed, 20 Nov 2013 08:19:56 -0800 (PST)
Date: Wed, 20 Nov 2013 17:19:22 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: use capped prob when computing throughputs
Message-ID: <20131120161922.GC9335@magnum.frso.rivierawaves.com> (sfid-20131120_172000_879085_E090BDE9)
References: <1384908668-27869-1-git-send-email-karl.beldan@gmail.com>
 <528C6590.1000803@openwrt.org>
 <20131120135628.GA9335@magnum.frso.rivierawaves.com>
 <528CC172.1040402@openwrt.org>
 <20131120145035.GB9335@magnum.frso.rivierawaves.com>
 <528CDA23.9090303@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <528CDA23.9090303@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 20, 2013 at 04:49:55PM +0100, Felix Fietkau wrote:
> On 2013-11-20 15:50, Karl Beldan wrote:
> > On Wed, Nov 20, 2013 at 03:04:34PM +0100, Felix Fietkau wrote:
> >> On 2013-11-20 14:56, Karl Beldan wrote:
> >> > On Wed, Nov 20, 2013 at 08:32:32AM +0100, Felix Fietkau wrote:
> >> >> On 2013-11-20 01:51, Karl Beldan wrote:
> >> >> > From: Karl Beldan <karl.beldan@rivierawaves.com>
> >> >> > 
> >> >> > Commit 3e8b1eb "mac80211/minstrel_ht: improve rate selection stability"
> >> >> > introduced a local capped prob in minstrel_ht_calc_tp but omitted to use
> >> >> > it to compute the rate throughput.
> >> >> > 
> >> >> > Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
> >> >> > CC: Felix Fietkau <nbd@openwrt.org>
> >> >> Nice catch!
> >> >> Acked-by: Felix Fietkau <nbd@openwrt.org>
> >> >> 
> >> > Interestingly enough, consecutive coding rates (5/6, 3/4, 2/3) max ratio
> >> > is 9/10, did you do it on purpose ?  (e.g. (9/10) * (5/6) == 3/4,
> >> > (9/10) * (3/4) == 2/3 + 11/120).
> >> The change has nothing to do with coding rates, it's only about
> >> retransmissions caused by collisions under load.
> >> 
> > I understand this, my point was that along with this comes the following:
> > let's say my SNR is just not so good to get 5/6 as good as 3/4, and e.g.
> > case1 htMCS7 has  91% 
> >       htMCS6 has 100% success 
> > case2 htMCS7 has  80% 
> >       htMCS6 has 100% success 
> > capping at 90% will prefer htMCS7 in case1 and htMCS6 in case2 both
> > achieving best real throughput.
> > capping at 80% will prefer htMCS7 in case1 _but_ htMCS7 in case2 the
> > latter being the worst real throughput(90% of 5/6 == 100% of 3/4 > 80%
> > of 5/6).
> Not sure if that's a meaningful comparison at all - you're leaving out
> the per-packet overhead, which is important for the throughput
> calculation as well.
> 
The overhead breaks these numbers but the more we aggregate the more
this math is realistic as then the rates converge to these numbers ..
plus, IMHO using the overhead for throughput is wasteful since
throughputs are ranked and used relatively to each others and overhead
is shared by all rates.

 
Karl
