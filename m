Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36540 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759468AbZKKWpj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2009 17:45:39 -0500
Date: Wed, 11 Nov 2009 17:45:42 -0500
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: Aeolus Yang <Aeolus.Yang@Atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	lrodriguez@atheros.com
Subject: Re: [ath9k-devel] Oops on ath_txq_schedule() hit a BUG_ON()
Message-ID: <20091111224542.GA9584@bombadil.infradead.org>
References: <43e72e890911101606j46e1edfn64e331f3463d4da5@mail.gmail.com> <19194.14583.795686.199320@gargle.gargle.HOWL> <20091111204420.GA18071@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20091111204420.GA18071@bombadil.infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 11, 2009 at 03:44:20PM -0500, Luis R. Rodriguez wrote:
> On Wed, Nov 11, 2009 at 09:39:27AM +0530, Sujith wrote:
> > Luis R. Rodriguez wrote:
> > > I managed to get an oops the 2.6.32-rc wireless bits on ath9k by using
> > > linux-backports-modules package on Ubuntu 9.10 which is on 2.6.31. I'm
> > > pretty sure this is a real oops which can be reproduced on 2.6.32-rc6
> > > but I was unable to boot the same laptop on 2.6.32-rc6 [1] due to an
> > > early oops on what seems to be i915.
> > > 
> > > The EIP is at ath_txq_schedule() but the oops happens due to a
> > > BUG_ON() (used to be ASSERT()) on this piece of code:
> > 
> > I have seen this once, and I have a backtrace.
> 
> I got a full trace now, on Linus' tip.
> 
> Please excuse the double prints, I haven't figured out how to
> cure that with netconsole yet [1]
> 
> [1] http://www.spinics.net/lists/netdev/msg111823.html


Even better, now I got a full log even from when I connect
to the AP with full debug enabled (0xffffff). This amounted
to getting 222 MB of of data, compressed with bzip -9 it
came to only 18 MB, I've pasted the last 1k lines below but
if you want the full log you can grab it here:

http://bombadil.infradead.org/~mcgrof/logs/2.6.32-rc6/ath9k-ar9285-2.6.32-rc6-2009-11-11.txt.bz2

Note that both outputs still have the dummy double prints due to some
sort of issue I'm having with netconsoel (or the switch or something..)

  Luis

[ 4675.231635] ath9k: disable IER
[ 4675.231653] ath9k: new IMR 0x0
[ 4675.231695] ath9k: tx queue 1 (36092000), link f608cde0
[ 4675.231712] ath9k: TX complete: skb: f6582540
[ 4675.231726] ath9k: TX complete: skb: f65829c0
[ 4675.231741] ath9k: qnum: 1, txq depth: 4
[ 4675.231751] ath9k: link[1] (f608cde0)=360821c0 (f60821c0)
[ 4675.231761] ath9k: Enable TXE on queue: 1
[ 4675.231771] ath9k: 0x0 => 0xf4041071
[ 4675.231779] ath9k: new IMR 0x918414b4
[ 4675.231792] ath9k: enable IER
[ 4675.231621] ath9k: [ 4675.231805] ath9k: AR_IMR 0x918414b4 IER 0x1
0xf4041071 => 0x0
[ 4675.231635] ath9k: disable IER
[ 4675.231653] ath9k: new IMR 0x0
[ 4675.231695] ath9k: tx queue 1 (36092000), link f608cde0
[ 4675.231712] ath9k: TX complete: skb: f6582540
[ 4675.231726] ath9k: TX complete: skb: f65829c0
[ 4675.231741] ath9k: qnum: 1, txq depth: 4
[ 4675.231751] ath9k: link[1] (f608cde0)=360821c0 (f60821c0)
[ 4675.231761] ath9k: Enable TXE on queue: 1
[ 4675.231771] ath9k: 0x0 => 0xf4041071
[ 4675.231779] ath9k: new IMR 0x918414b4
[ 4675.231792] ath9k: enable IER
[ 4675.231805] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.241673] ath9k: 0xf4041071 => 0x0
[ 4675.241696] ath9k: disable IER
[ 4675.241720] ath9k: new IMR 0x0
[ 4675.241758] ath9k: tx queue 1 (36082490), link f6084140
[ 4675.241787] ath9k: TX complete: skb: f6546240
[ 4675.241817] ath9k: qnum: 1, txq depth: 4
[ 4675.241833] ath9k: link[1] (f6084140)=36088d30 (f6088d30)
[ 4675.241849] ath9k: Enable TXE on queue: 1
[ 4675.241864] ath9k: 0x0 => 0xf4041071
[ 4675.241878] ath9k: new IMR 0x918414b4
[ 4675.241899] ath9k: enable IER
[ 4675.241918] ath9k: [ 4675.241673] ath9k: AR_IMR 0x918414b4 IER 0x1
0xf4041071 => 0x0
[ 4675.241696] ath9k: disable IER
[ 4675.241720] ath9k: new IMR 0x0
[ 4675.241758] ath9k: tx queue 1 (36082490), link f6084140
[ 4675.241787] ath9k: TX complete: skb: f6546240
[ 4675.241817] ath9k: qnum: 1, txq depth: 4
[ 4675.241833] ath9k: link[1] (f6084140)=36088d30 (f6088d30)
[ 4675.241849] ath9k: Enable TXE on queue: 1
[ 4675.241864] ath9k: 0x0 => 0xf4041071
[ 4675.241878] ath9k: new IMR 0x918414b4
[ 4675.241899] ath9k: enable IER
[ 4675.241918] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.244447] ath9k: 0xf4041071 => 0x0
[ 4675.244461] ath9k: disable IER
[ 4675.244479] ath9k: new IMR 0x0
[ 4675.244516] ath9k: tx queue 1 (36081ef0), link f6091b80
[ 4675.244532] ath9k: TX complete: skb: f55196c0
[ 4675.244547] ath9k: TX complete: skb: f5519480
[ 4675.244559] ath9k: TX complete: skb: f5519840
[ 4675.244571] ath9k: TX complete: skb: f5519d80
[ 4675.244586] ath9k: qnum: 1, txq depth: 4
[ 4675.244596] ath9k: link[1] (f6091b80)=3608d380 (f608d380)
[ 4675.244606] ath9k: Enable TXE on queue: 1
[ 4675.244614] ath9k: 0x0 => 0xf4041071
[ 4675.244622] ath9k: new IMR 0x918414b4
[ 4675.244638] ath9k: [ 4675.244447] ath9k: enable IER
[ 4675.244651] ath9k: AR_IMR 0x918414b4 IER 0x1
0xf4041071 => 0x0
[ 4675.244461] ath9k: disable IER
[ 4675.244479] ath9k: new IMR 0x0
[ 4675.244516] ath9k: tx queue 1 (36081ef0), link f6091b80
[ 4675.244532] ath9k: TX complete: skb: f55196c0
[ 4675.244547] ath9k: TX complete: skb: f5519480
[ 4675.244559] ath9k: TX complete: skb: f5519840
[ 4675.244571] ath9k: TX complete: skb: f5519d80
[ 4675.244586] ath9k: qnum: 1, txq depth: 4
[ 4675.244596] ath9k: link[1] (f6091b80)=3608d380 (f608d380)
[ 4675.244606] ath9k: Enable TXE on queue: 1
[ 4675.244614] ath9k: 0x0 => 0xf4041071
[ 4675.244622] ath9k: new IMR 0x918414b4
[ 4675.244638] ath9k: enable IER
[ 4675.244651] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.289055] ath9k: invalid cmd 2
[ 4675.289080] ath9k: Writing ofdmbase=12582412   cckbase=12582712
[ 4675.289055] ath9k: invalid cmd 2
[ 4675.289080] ath9k: Writing ofdmbase=12582412   cckbase=12582712
[ 4675.295406] ath9k: 0xf4041071 => 0x0
[ 4675.295426] ath9k: disable IER
[ 4675.295451] ath9k: new IMR 0x0
[ 4675.295487] ath9k: tx queue 1 (360821c0), link f608d380
[ 4675.295524] ath9k: TX complete: skb: f5519e40
[ 4675.295555] ath9k: qnum: 1, txq depth: 4
[ 4675.295572] ath9k: link[1] (f608d380)=36081ef0 (f6081ef0)
[ 4675.295588] ath9k: Enable TXE on queue: 1
[ 4675.295603] ath9k: 0x0 => 0xf4041071
[ 4675.295406] ath9k: [ 4675.295618] ath9k: new IMR 0x918414b4
[ 4675.295638] ath9k: enable IER
[ 4675.295657] ath9k: AR_IMR 0x918414b4 IER 0x1
0xf4041071 => 0x0
[ 4675.295426] ath9k: disable IER
[ 4675.295451] ath9k: new IMR 0x0
[ 4675.295487] ath9k: tx queue 1 (360821c0), link f608d380
[ 4675.295524] ath9k: TX complete: skb: f5519e40
[ 4675.295555] ath9k: qnum: 1, txq depth: 4
[ 4675.295572] ath9k: link[1] (f608d380)=36081ef0 (f6081ef0)
[ 4675.295588] ath9k: Enable TXE on queue: 1
[ 4675.295603] ath9k: 0x0 => 0xf4041071
[ 4675.295618] ath9k: new IMR 0x918414b4
[ 4675.295638] ath9k: enable IER
[ 4675.295657] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.300944] ath9k: 0xf4041071 => 0x0
[ 4675.300959] ath9k: disable IER
[ 4675.300980] ath9k: new IMR 0x0
[ 4675.301013] ath9k: tx queue 1 (36088d30), link f6086b70
[ 4675.301040] ath9k: TX complete: skb: f6582480
[ 4675.301066] ath9k: qnum: 1, txq depth: 4
[ 4675.301079] ath9k: link[1] (f6086b70)=360821c0 (f60821c0)
[ 4675.301091] ath9k: Enable TXE on queue: 1
[ 4675.301103] ath9k: 
[ 4675.301105] ath9k: 0x0 => 0xf4041071
[ 4675.301111] ath9k: new IMR 0x918414b4
[ 4675.301122] ath9k: enable IER
[ 4675.300944] ath9k: [ 4675.301131] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.301145] transmitting packet, skb: f64ce000
[ 4675.301169] ath9k: qnum: 1, txq depth: 5
[ 4675.301183] ath9k: link[1] (f60834e0)=3608de30 (f608de30)
[ 4675.301200] ath9k: 0xf4041071 => 0x0
Enable TXE on queue: 1
[ 4675.301223] ath9k: 0xf4041071 => 0xf4041171
[ 4675.301237] ath9k: disable IER
[ 4675.301282] ath9k: new IMR 0x918414b4
[ 4675.301302] ath9k: [ 4675.300959] ath9k: enable IER
[ 4675.301321] ath9k: AR_IMR 0x918414b4 IER 0x1
disable IER
[ 4675.300980] ath9k: new IMR 0x0
[ 4675.301013] ath9k: tx queue 1 (36088d30), link f6086b70
[ 4675.301040] ath9k: TX complete: skb: f6582480
[ 4675.301066] ath9k: qnum: 1, txq depth: 4
[ 4675.301079] ath9k: link[1] (f6086b70)=360821c0 (f60821c0)
[ 4675.301091] ath9k: Enable TXE on queue: 1
[ 4675.301103] ath9k: 
[ 4675.301105] ath9k: 0x0 => 0xf4041071
[ 4675.301111] ath9k: new IMR 0x918414b4
[ 4675.301122] ath9k: enable IER
[ 4675.301131] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.301145] transmitting packet, skb: f64ce000
[ 4675.301169] ath9k: qnum: 1, txq depth: 5
[ 4675.301183] ath9k: link[1] (f60834e0)=3608de30 (f608de30)
[ 4675.301200] ath9k: Enable TXE on queue: 1
[ 4675.301223] ath9k: 0xf4041071 => 0xf4041171
disable IER
[ 4675.301282] ath9k: new IMR 0x918414b4
[ 4675.301302] ath9k: enable IER
[ 4675.301321] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.369381] ath9k: 0xf4041171 => 0x0
[ 4675.369400] ath9k: disable IER
[ 4675.369423] ath9k: new IMR 0x0
[ 4675.369457] ath9k: tx queue 1 (3608d380), link f608de30
[ 4675.369474] ath9k: TX complete: skb: f5647300
[ 4675.369521] ath9k: qnum: 1, txq depth: 5
[ 4675.369531] ath9k: link[1] (f608de30)=36088d30 (f6088d30)
[ 4675.369542] ath9k: Enable TXE on queue: 1
[ 4675.369551] ath9k: 0x0 => 0xf4041171
[ 4675.369558] ath9k: new IMR 0x918414b4
[ 4675.369573] ath9k: enable IER
[ 4675.369586] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.369381] ath9k: 0xf4041171 => 0x0
[ 4675.369400] ath9k: disable IER
[ 4675.369423] ath9k: new IMR 0x0
[ 4675.369457] ath9k: tx queue 1 (3608d380), link f608de30
[ 4675.369474] ath9k: TX complete: skb: f5647300
[ 4675.369521] ath9k: qnum: 1, txq depth: 5
[ 4675.369531] ath9k: link[1] (f608de30)=36088d30 (f6088d30)
[ 4675.369542] ath9k: Enable TXE on queue: 1
[ 4675.369551] ath9k: 0x0 => 0xf4041171
[ 4675.369558] ath9k: new IMR 0x918414b4
[ 4675.369573] ath9k: enable IER
[ 4675.369586] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.372289] ath9k: 0xf4041171 => 0x0
[ 4675.372303] ath9k: disable IER
[ 4675.372321] ath9k: new IMR 0x0
[ 4675.372388] ath9k: 0x0 => 0xf4041171
[ 4675.372401] ath9k: new IMR 0x918414b4
[ 4675.372418] ath9k: enable IER
[ 4675.372438] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.372447] ath9k: AWAKE -> NETWORK SLEEP
[ 4675.372289] ath9k: 0xf4041171 => 0x0
[ 4675.372303] ath9k: disable IER
[ 4675.372321] ath9k: new IMR 0x0
[ 4675.372388] ath9k: 0x0 => 0xf4041171
[ 4675.372401] ath9k: new IMR 0x918414b4
[ 4675.372418] ath9k: enable IER
[ 4675.372438] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.372447] ath9k: AWAKE -> NETWORK SLEEP
[ 4675.380314] ath9k: 0xf4041171 => 0x0
[ 4675.380336] ath9k: disable IER
[ 4675.380359] ath9k: new IMR 0x0
[ 4675.380391] ath9k: NETWORK SLEEP -> AWAKE
[ 4675.380486] ath9k: tx queue 1 (36081ef0), link f6088700
[ 4675.380510] ath9k: TX complete: skb: f56479c0
[ 4675.380541] ath9k: qnum: 1, txq depth: 5
[ 4675.380557] ath9k: link[1] (f6088700)=360827f0 (f60827f0)
[ 4675.380574] ath9k: Enable TXE on queue: 1
[ 4675.380592] ath9k: 0x0 => 0xf4041171
[ 4675.380606] ath9k: new IMR 0x918414b4
[ 4675.380625] ath9k: [ 4675.380314] ath9k: enable IER
0xf4041171 => 0x0
[ 4675.380645] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.380660] ath9k: AWAKE -> NETWORK SLEEP
[ 4675.380336] ath9k: disable IER
[ 4675.380359] ath9k: new IMR 0x0
[ 4675.380391] ath9k: NETWORK SLEEP -> AWAKE
[ 4675.380486] ath9k: tx queue 1 (36081ef0), link f6088700
[ 4675.380510] ath9k: TX complete: skb: f56479c0
[ 4675.380541] ath9k: qnum: 1, txq depth: 5
[ 4675.380557] ath9k: link[1] (f6088700)=360827f0 (f60827f0)
[ 4675.380574] ath9k: Enable TXE on queue: 1
[ 4675.380592] ath9k: 0x0 => 0xf4041171
[ 4675.380606] ath9k: new IMR 0x918414b4
[ 4675.380625] ath9k: enable IER
[ 4675.380645] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.380660] ath9k: AWAKE -> NETWORK SLEEP
[ 4675.383510] ath9k: 0xf4041171 => 0x0
[ 4675.383525] ath9k: disable IER
[ 4675.383544] ath9k: new IMR 0x0
[ 4675.383566] ath9k: NETWORK SLEEP -> AWAKE
[ 4675.383651] ath9k: tx queue 1 (360821c0), link f60827f0
[ 4675.383664] ath9k: TX complete: skb: f6172b40
[ 4675.383681] ath9k: TX complete: skb: f659e000
[ 4675.383693] ath9k: TX complete: skb: f5647000
[ 4675.383706] ath9k: TX complete: skb: f5647600
[ 4675.383721] ath9k: qnum: 1, txq depth: 5
[ 4675.383730] ath9k: link[1] (f60827f0)=3608d890 (f608d890)
[ 4675.383740] ath9k: Enable TXE on queue: 1
[ 4675.383749] ath9k: 0x0 => 0xf4041171
[ 4675.383757] ath9k: [ 4675.383510] ath9k: new IMR 0x918414b4
[ 4675.383771] ath9k: enable IER
[ 4675.383784] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.383793] ath9k: AWAKE -> NETWORK SLEEP
0xf4041171 => 0x0
[ 4675.383525] ath9k: disable IER
[ 4675.383544] ath9k: new IMR 0x0
[ 4675.383566] ath9k: NETWORK SLEEP -> AWAKE
[ 4675.383651] ath9k: tx queue 1 (360821c0), link f60827f0
[ 4675.383664] ath9k: TX complete: skb: f6172b40
[ 4675.383681] ath9k: TX complete: skb: f659e000
[ 4675.383693] ath9k: TX complete: skb: f5647000
[ 4675.383706] ath9k: TX complete: skb: f5647600
[ 4675.383721] ath9k: qnum: 1, txq depth: 5
[ 4675.383730] ath9k: link[1] (f60827f0)=3608d890 (f608d890)
[ 4675.383740] ath9k: Enable TXE on queue: 1
[ 4675.383749] ath9k: 0x0 => 0xf4041171
[ 4675.383757] ath9k: new IMR 0x918414b4
[ 4675.383771] ath9k: enable IER
[ 4675.383784] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.383793] ath9k: AWAKE -> NETWORK SLEEP
[ 4675.386293] ath9k: 0xf4041171 => 0x0
[ 4675.386321] ath9k: disable IER
[ 4675.386344] ath9k: new IMR 0x0
[ 4675.386378] ath9k: NETWORK SLEEP -> AWAKE
[ 4675.386476] ath9k: tx queue 1 (36088d30), link f608d890
[ 4675.386500] ath9k: TX complete: skb: f6582e40
[ 4675.386526] ath9k: TX complete: skb: f5647180
[ 4675.386547] ath9k: TX complete: skb: f5647e40
[ 4675.386565] ath9k: TX complete: skb: f5647d80
[ 4675.386597] ath9k: qnum: 1, txq depth: 5
[ 4675.386612] ath9k: link[1] (f608d890)=36089000 (f6089000)
[ 4675.386626] ath9k: Enable TXE on queue: 1
[ 4675.386642] ath9k: TX complete: skb: f64ce000
[ 4675.386661] ath9k: 0x0 => 0xf4041171
[ 4675.386675] ath9k: new IMR 0x918414b4
[ 4675.386695] ath9k: enable IER
[ 4675.386714] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.386728] ath9k: [ 4675.386293] ath9k: 
[ 4675.386734] ath9k: 0xf4041171 => 0x0
[ 4675.386740] ath9k: disable IER
[ 4675.386752] ath9k: new IMR 0x0
[ 4675.386768] AWAKE -> NETWORK SLEEP
0xf4041171 => 0x0
[ 4675.386789] ath9k: NETWORK SLEEP -> AWAKE
[ 4675.386321] ath9k: [ 4675.386882] ath9k: tx queue 1 (36088d30), link f6089000
[ 4675.386901] ath9k: 0x0 => 0xf4041171
[ 4675.386916] ath9k: new IMR 0x918414b4
[ 4675.386936] ath9k: disable IER
enable IER
[ 4675.386955] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.386970] ath9k: AWAKE -> NETWORK SLEEP
[ 4675.386344] ath9k: new IMR 0x0
[ 4675.386378] ath9k: NETWORK SLEEP -> AWAKE
[ 4675.386476] ath9k: tx queue 1 (36088d30), link f608d890
[ 4675.386500] ath9k: TX complete: skb: f6582e40
[ 4675.386526] ath9k: TX complete: skb: f5647180
[ 4675.386547] ath9k: TX complete: skb: f5647e40
[ 4675.387809] ath9k: [ 4675.386565] ath9k: NETWORK SLEEP -> AWAKE
TX complete: skb: f5647d80
[ 4675.387907] ath9k: 0xf4041171 => 0xf4041071
[ 4675.387921] ath9k: disable IER
[ 4675.387947] ath9k: [ 4675.386597] ath9k: new IMR 0x918414b4
[ 4675.387988] ath9k: enable IER
[ 4675.388016] ath9k: AR_IMR 0x918414b4 IER 0x1
qnum: 1, txq depth: 5
[ 4675.388058] ath9k: transmitting packet, skb: f654b300
[ 4675.388078] ath9k: [ 4675.386612] ath9k: transmitting packet, skb: f654b240
[ 4675.388095] ath9k: transmitting packet, skb: f654b0c0
[ 4675.388112] ath9k: transmitting packet, skb: f6582480
[ 4675.388128] ath9k: transmitting packet, skb: f6582e40
[ 4675.388146] ath9k: transmitting packet, skb: f65829c0
[ 4675.388164] ath9k: transmitting packet, skb: f6582540
[ 4675.388183] ath9k: transmitting packet, skb: f6582240
[ 4675.388200] ath9k: transmitting packet, skb: f65820c0
[ 4675.388221] ath9k: transmitting packet, skb: f5519e40
link[1] (f608d890)=36089000 (f6089000)
[ 4675.388240] ath9k: transmitting packet, skb: f5519d80
[ 4675.388259] ath9k: transmitting packet, skb: f5519840
[ 4675.388276] ath9k: transmitting packet, skb: f5519480
[ 4675.388293] ath9k: transmitting packet, skb: f55196c0
[ 4675.388313] ath9k: transmitting packet, skb: f5519a80
[ 4675.388332] ath9k: transmitting packet, skb: f5519180
[ 4675.388350] ath9k: transmitting packet, skb: f659e000
[ 4675.386626] ath9k: [ 4675.388368] ath9k: Enable TXE on queue: 1
[ 4675.386642] ath9k: transmitting packet, skb: f659e840
[ 4675.388388] ath9k: transmitting packet, skb: f659ecc0
[ 4675.388407] ath9k: transmitting packet, skb: f659e900
[ 4675.388425] ath9k: transmitting packet, skb: f659e3c0
[ 4675.388445] ath9k: transmitting packet, skb: f659e480
[ 4675.388464] ath9k: TX complete: skb: f64ce000
[ 4675.386661] ath9k: transmitting packet, skb: f67dfa80
[ 4675.388578] ath9k: transmitting packet, skb: f67df6c0
[ 4675.388602] ath9k: 0x0 => 0xf4041171
transmitting packet, skb: f67df3c0
[ 4675.388620] ath9k: transmitting packet, skb: f67dff00
[ 4675.386675] ath9k: [ 4675.388638] ath9k: transmitting packet, skb: f67df240
[ 4675.388658] ath9k: transmitting packet, skb: f67df9c0
[ 4675.388676] ath9k: transmitting packet, skb: f67df900
[ 4675.388694] ath9k: transmitting packet, skb: f697ecc0
new IMR 0x918414b4
[ 4675.388713] ath9k: transmitting packet, skb: f697ea80
[ 4675.388732] ath9k: transmitting packet, skb: f697e540
[ 4675.386695] ath9k: enable IER
[ 4675.386714] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.386728] ath9k: 
[ 4675.386734] ath9k: 0xf4041171 => 0x0
[ 4675.389278] ath9k: 0xf4041071 => 0x0
[ 4675.389299] ath9k: disable IER
[ 4675.389326] ath9k: new IMR 0x0
[ 4675.389361] ath9k: tx queue 1 (360827f0), link f6089000
[ 4675.389397] ath9k: TX complete: skb: f657b900
[ 4675.389423] ath9k: TX complete: skb: f6582840
[ 4675.389449] ath9k: qnum: 1, txq depth: 4
[ 4675.389463] ath9k: link[1] (f6089000)=3608acb0 (f608acb0)
[ 4675.389478] ath9k: Enable TXE on queue: 1
[ 4675.389493] ath9k: 0x0 => 0xf4041071
[ 4675.389506] ath9k: new IMR 0x918414b4
[ 4675.389525] ath9k: enable IER
[ 4675.389544] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.386740] ath9k: disable IER
[ 4675.386752] ath9k: new IMR 0x0
[ 4675.386768] AWAKE -> NETWORK SLEEP
[ 4675.386789] ath9k: NETWORK SLEEP -> AWAKE
[ 4675.386882] ath9k: tx queue 1 (36088d30), link f6089000
[ 4675.386901] ath9k: 0x0 => 0xf4041171
[ 4675.386916] ath9k: new IMR 0x918414b4
[ 4675.386936] ath9k: enable IER
[ 4675.386955] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.386970] ath9k: AWAKE -> NETWORK SLEEP
[ 4675.387809] ath9k: NETWORK SLEEP -> AWAKE
[ 4675.387907] ath9k: 0xf4041171 => 0xf4041071
[ 4675.387921] ath9k: disable IER
[ 4675.387947] ath9k: new IMR 0x918414b4
[ 4675.387988] ath9k: enable IER
[ 4675.388016] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.388058] ath9k: transmitting packet, skb: f654b300
[ 4675.388078] ath9k: transmitting packet, skb: f654b240
[ 4675.388095] ath9k: transmitting packet, skb: f654b0c0
[ 4675.388112] ath9k: transmitting packet, skb: f6582480
[ 4675.388128] ath9k: transmitting packet, skb: f6582e40
[ 4675.388146] ath9k: transmitting packet, skb: f65829c0
[ 4675.388164] ath9k: transmitting packet, skb: f6582540
[ 4675.388183] ath9k: transmitting packet, skb: f6582240
[ 4675.388200] ath9k: transmitting packet, skb: f65820c0
[ 4675.388221] ath9k: transmitting packet, skb: f5519e40
[ 4675.388240] ath9k: transmitting packet, skb: f5519d80
[ 4675.388259] ath9k: transmitting packet, skb: f5519840
[ 4675.388276] ath9k: transmitting packet, skb: f5519480
[ 4675.388293] ath9k: transmitting packet, skb: f55196c0
[ 4675.388313] ath9k: transmitting packet, skb: f5519a80
[ 4675.388332] ath9k: transmitting packet, skb: f5519180
[ 4675.388350] ath9k: transmitting packet, skb: f659e000
[ 4675.388368] ath9k: transmitting packet, skb: f659e840
[ 4675.388388] ath9k: transmitting packet, skb: f659ecc0
[ 4675.388407] ath9k: transmitting packet, skb: f659e900
[ 4675.388425] ath9k: transmitting packet, skb: f659e3c0
[ 4675.388445] ath9k: transmitting packet, skb: f659e480
[ 4675.388464] ath9k: transmitting packet, skb: f67dfa80
[ 4675.388578] ath9k: transmitting packet, skb: f67df6c0
[ 4675.388602] ath9k: transmitting packet, skb: f67df3c0
[ 4675.388620] ath9k: transmitting packet, skb: f67dff00
[ 4675.388638] ath9k: transmitting packet, skb: f67df240
[ 4675.388658] ath9k: transmitting packet, skb: f67df9c0
[ 4675.388676] ath9k: transmitting packet, skb: f67df900
[ 4675.388694] ath9k: transmitting packet, skb: f697ecc0
[ 4675.388713] ath9k: transmitting packet, skb: f697ea80
[ 4675.388732] ath9k: transmitting packet, skb: f697e540
[ 4675.389278] ath9k: 0xf4041071 => 0x0
[ 4675.389299] ath9k: disable IER
[ 4675.389326] ath9k: new IMR 0x0
[ 4675.389361] ath9k: tx queue 1 (360827f0), link f6089000
[ 4675.389397] ath9k: TX complete: skb: f657b900
[ 4675.389423] ath9k: TX complete: skb: f6582840
[ 4675.389449] ath9k: qnum: 1, txq depth: 4
[ 4675.389463] ath9k: link[1] (f6089000)=3608acb0 (f608acb0)
[ 4675.389478] ath9k: Enable TXE on queue: 1
[ 4675.389493] ath9k: 0x0 => 0xf4041071
[ 4675.389506] ath9k: new IMR 0x918414b4
[ 4675.389525] ath9k: enable IER
[ 4675.389544] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.404053] ath9k: 0xf4041071 => 0x0
[ 4675.404075] ath9k: disable IER
[ 4675.404093] ath9k: new IMR 0x0
[ 4675.404133] ath9k: tx queue 1 (3608d890), link f608aef0
[ 4675.404150] ath9k: TX complete: skb: f5647f00
[ 4675.404173] ath9k: qnum: 1, txq depth: 4
[ 4675.404182] ath9k: link[1] (f608aef0)=3608b0a0 (f608b0a0)
[ 4675.404194] ath9k: Enable TXE on queue: 1
[ 4675.404203] ath9k: 0x0 => 0xf4041071
[ 4675.404212] ath9k: new IMR 0x918414b4
[ 4675.404226] ath9k: enable IER
[ 4675.404239] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.404053] ath9k: 0xf4041071 => 0x0
[ 4675.404075] ath9k: disable IER
[ 4675.404093] ath9k: new IMR 0x0
[ 4675.404133] ath9k: tx queue 1 (3608d890), link f608aef0
[ 4675.404150] ath9k: TX complete: skb: f5647f00
[ 4675.404173] ath9k: qnum: 1, txq depth: 4
[ 4675.404182] ath9k: link[1] (f608aef0)=3608b0a0 (f608b0a0)
[ 4675.404194] ath9k: Enable TXE on queue: 1
[ 4675.404203] ath9k: 0x0 => 0xf4041071
[ 4675.404212] ath9k: new IMR 0x918414b4
[ 4675.404226] ath9k: enable IER
[ 4675.404239] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.418088] ath9k: 0xf4041071 => 0x0
[ 4675.418114] ath9k: disable IER
[ 4675.418140] ath9k: new IMR 0x0
[ 4675.418180] ath9k: tx queue 1 (3608acb0), link f608b0a0
[ 4675.418216] ath9k: TX complete: skb: f5647840
[ 4675.418246] ath9k: qnum: 1, txq depth: 4
[ 4675.418263] ath9k: link[1] (f608b0a0)=36087c50 (f6087c50)
[ 4675.418281] ath9k: Enable TXE on queue: 1
[ 4675.418295] ath9k: 0x0 => 0xf4041071
[ 4675.418310] ath9k: [ 4675.418088] ath9k: new IMR 0x918414b4
[ 4675.418329] ath9k: enable IER
[ 4675.418348] ath9k: AR_IMR 0x918414b4 IER 0x1
0xf4041071 => 0x0
[ 4675.418114] ath9k: disable IER
[ 4675.418140] ath9k: new IMR 0x0
[ 4675.418180] ath9k: tx queue 1 (3608acb0), link f608b0a0
[ 4675.418216] ath9k: TX complete: skb: f5647840
[ 4675.418246] ath9k: qnum: 1, txq depth: 4
[ 4675.418263] ath9k: link[1] (f608b0a0)=36087c50 (f6087c50)
[ 4675.418281] ath9k: Enable TXE on queue: 1
[ 4675.418295] ath9k: 0x0 => 0xf4041071
[ 4675.419529] ath9k: 0xf4041071 => 0x0
[ 4675.419546] ath9k: disable IER
[ 4675.419587] ath9k: new IMR 0x0
[ 4675.419617] ath9k: [ 4675.418310] ath9k: tx queue 1 (3608acb0), link f6087c50
new IMR 0x918414b4
[ 4675.419647] ath9k: TX complete: skb: f5647540
[ 4675.418329] ath9k: [ 4675.419672] ath9k: qnum: 1, txq depth: 4
[ 4675.419688] ath9k: link[1] (f6087c50)=36082640 (f6082640)
[ 4675.419705] ath9k: Enable TXE on queue: 1
[ 4675.419720] ath9k: 0x0 => 0xf4041071
enable IER
[ 4675.419733] ath9k: new IMR 0x918414b4
[ 4675.419753] ath9k: enable IER
[ 4675.419772] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.418348] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.419529] ath9k: 0xf4041071 => 0x0
[ 4675.419546] ath9k: disable IER
[ 4675.419587] ath9k: new IMR 0x0
[ 4675.419617] ath9k: tx queue 1 (3608acb0), link f6087c50
[ 4675.419647] ath9k: TX complete: skb: f5647540
[ 4675.419672] ath9k: qnum: 1, txq depth: 4
[ 4675.419688] ath9k: link[1] (f6087c50)=36082640 (f6082640)
[ 4675.419705] ath9k: Enable TXE on queue: 1
[ 4675.419720] ath9k: 0x0 => 0xf4041071
[ 4675.419733] ath9k: new IMR 0x918414b4
[ 4675.419753] ath9k: enable IER
[ 4675.419772] ath9k: [ 4675.422195] ath9k: 0xf4041071 => 0x0
[ 4675.422216] ath9k: disable IER
AR_IMR 0x918414b4 IER 0x1
[ 4675.422260] ath9k: new IMR 0x0
[ 4675.422291] ath9k: tx queue 1 (3608b0a0), link f6082640
[ 4675.422318] ath9k: TX complete: skb: f6582cc0
[ 4675.422342] ath9k: TX complete: skb: f56476c0
[ 4675.422362] ath9k: TX complete: skb: f56473c0
[ 4675.422383] ath9k: TX complete: skb: f64d0e40
[ 4675.422408] ath9k: qnum: 1, txq depth: 4
[ 4675.422422] ath9k: link[1] (f6082640)=36084380 (f6084380)
[ 4675.422439] ath9k: Enable TXE on queue: 1
[ 4675.422455] ath9k: 0x0 => 0xf4041071
[ 4675.422470] ath9k: new IMR 0x918414b4
[ 4675.422489] ath9k: enable IER
[ 4675.422509] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.422195] ath9k: 0xf4041071 => 0x0
[ 4675.422216] ath9k: disable IER
[ 4675.422260] ath9k: new IMR 0x0
[ 4675.422291] ath9k: tx queue 1 (3608b0a0), link f6082640
[ 4675.422318] ath9k: TX complete: skb: f6582cc0
[ 4675.422342] ath9k: TX complete: skb: f56476c0
[ 4675.422362] ath9k: TX complete: skb: f56473c0
[ 4675.422383] ath9k: TX complete: skb: f64d0e40
[ 4675.422408] ath9k: qnum: 1, txq depth: 4
[ 4675.422422] ath9k: [ 4675.423781] ath9k: 0xf4041071 => 0x0
[ 4675.423798] ath9k: disable IER
[ 4675.423821] ath9k: link[1] (f6082640)=36084380 (f6084380)
new IMR 0x0
[ 4675.423861] ath9k: tx queue 1 (36087c50), link f6084380
[ 4675.423884] ath9k: [ 4675.422439] ath9k: TX complete: skb: f64d0f00
[ 4675.423914] ath9k: qnum: 1, txq depth: 4
[ 4675.423928] ath9k: link[1] (f6084380)=3608c8d0 (f608c8d0)
[ 4675.423943] ath9k: Enable TXE on queue: 1
[ 4675.423956] ath9k: 0x0 => 0xf4041071
[ 4675.423970] ath9k: new IMR 0x918414b4
[ 4675.423990] ath9k: enable IER
[ 4675.424027] ath9k: AR_IMR 0x918414b4 IER 0x1
Enable TXE on queue: 1
[ 4675.422455] ath9k: 0x0 => 0xf4041071
[ 4675.422470] ath9k: new IMR 0x918414b4
[ 4675.422489] ath9k: enable IER
[ 4675.422509] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.423781] ath9k: 0xf4041071 => 0x0
[ 4675.423798] ath9k: disable IER
[ 4675.423821] ath9k: new IMR 0x0
[ 4675.423861] ath9k: tx queue 1 (36087c50), link f6084380
[ 4675.423884] ath9k: TX complete: skb: f64d0f00
[ 4675.423914] ath9k: qnum: 1, txq depth: 4
[ 4675.423928] ath9k: link[1] (f6084380)=3608c8d0 (f608c8d0)
[ 4675.423943] ath9k: Enable TXE on queue: 1
[ 4675.423956] ath9k: 0x0 => 0xf4041071
[ 4675.423970] ath9k: new IMR 0x918414b4
[ 4675.426706] ath9k: 0xf4041071 => 0x0
[ 4675.426727] ath9k: disable IER
[ 4675.423990] ath9k: [ 4675.426763] ath9k: new IMR 0x0
enable IER
[ 4675.426795] ath9k: tx queue 1 (36082640), link f608c8d0
[ 4675.424027] ath9k: [ 4675.426821] ath9k: TX complete: skb: f64d0540
[ 4675.426842] ath9k: qnum: 1, txq depth: 4
[ 4675.426851] ath9k: link[1] (f608c8d0)=360901a0 (f60901a0)
[ 4675.426861] ath9k: Enable TXE on queue: 1
AR_IMR 0x918414b4 IER 0x1
[ 4675.426870] ath9k: 0x0 => 0xf4041071
[ 4675.426879] ath9k: new IMR 0x918414b4
[ 4675.426893] ath9k: enable IER
[ 4675.426905] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.426706] ath9k: 0xf4041071 => 0x0
[ 4675.426727] ath9k: disable IER
[ 4675.426763] ath9k: new IMR 0x0
[ 4675.426795] ath9k: tx queue 1 (36082640), link f608c8d0
[ 4675.426821] ath9k: TX complete: skb: f64d0540
[ 4675.426842] ath9k: qnum: 1, txq depth: 4
[ 4675.426851] ath9k: link[1] (f608c8d0)=360901a0 (f60901a0)
[ 4675.426861] ath9k: Enable TXE on queue: 1
[ 4675.426870] ath9k: 0x0 => 0xf4041071
[ 4675.426879] ath9k: new IMR 0x918414b4
[ 4675.426893] ath9k: enable IER
[ 4675.426905] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.429723] ath9k: 0xf4041071 => 0x0
[ 4675.429743] ath9k: disable IER
[ 4675.429775] ath9k: new IMR 0x0
[ 4675.429809] ath9k: tx queue 1 (36084380), link f60901a0
[ 4675.429829] ath9k: TX complete: skb: f64d09c0
[ 4675.429875] ath9k: qnum: 1, txq depth: 4
[ 4675.429890] ath9k: link[1] (f60901a0)=36083d50 (f6083d50)
[ 4675.429906] ath9k: Enable TXE on queue: 1
[ 4675.429922] ath9k: 0x0 => 0xf4041071
[ 4675.429723] ath9k: [ 4675.429936] ath9k: new IMR 0x918414b4
[ 4675.429955] ath9k: enable IER
[ 4675.429973] ath9k: AR_IMR 0x918414b4 IER 0x1
0xf4041071 => 0x0
[ 4675.429743] ath9k: disable IER
[ 4675.429775] ath9k: new IMR 0x0
[ 4675.429809] ath9k: tx queue 1 (36084380), link f60901a0
[ 4675.429829] ath9k: TX complete: skb: f64d09c0
[ 4675.429875] ath9k: qnum: 1, txq depth: 4
[ 4675.429890] ath9k: link[1] (f60901a0)=36083d50 (f6083d50)
[ 4675.429906] ath9k: Enable TXE on queue: 1
[ 4675.429922] ath9k: 0x0 => 0xf4041071
[ 4675.429936] ath9k: new IMR 0x918414b4
[ 4675.429955] ath9k: enable IER
[ 4675.429973] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.434873] ath9k: 0xf4041071 => 0x0
[ 4675.434888] ath9k: disable IER
[ 4675.434906] ath9k: new IMR 0x0
[ 4675.434941] ath9k: tx queue 1 (3608c8d0), link f6083d50
[ 4675.434957] ath9k: TX complete: skb: f64d0240
[ 4675.434975] ath9k: qnum: 1, txq depth: 4
[ 4675.434984] ath9k: link[1] (f6083d50)=3608cba0 (f608cba0)
[ 4675.434994] ath9k: Enable TXE on queue: 1
[ 4675.435004] ath9k: 0x0 => 0xf4041071
[ 4675.435012] ath9k: new IMR 0x918414b4
[ 4675.435026] ath9k: enable IER
[ 4675.435039] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.434873] ath9k: 0xf4041071 => 0x0
[ 4675.434888] ath9k: disable IER
[ 4675.434906] ath9k: new IMR 0x0
[ 4675.434941] ath9k: tx queue 1 (3608c8d0), link f6083d50
[ 4675.434957] ath9k: TX complete: skb: f64d0240
[ 4675.434975] ath9k: qnum: 1, txq depth: 4
[ 4675.434984] ath9k: link[1] (f6083d50)=3608cba0 (f608cba0)
[ 4675.434994] ath9k: Enable TXE on queue: 1
[ 4675.435004] ath9k: 0x0 => 0xf4041071
[ 4675.435012] ath9k: new IMR 0x918414b4
[ 4675.435026] ath9k: enable IER
[ 4675.435039] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.449939] ath9k: 0xf4041071 => 0x0
[ 4675.449959] ath9k: disable IER
[ 4675.449977] ath9k: new IMR 0x0
[ 4675.450015] ath9k: tx queue 1 (360901a0), link f608cba0
[ 4675.450034] ath9k: TX complete: skb: f64d0900
[ 4675.450075] ath9k: qnum: 1, txq depth: 4
[ 4675.450087] ath9k: link[1] (f608cba0)=360871a0 (f60871a0)
[ 4675.450100] ath9k: Enable TXE on queue: 1
[ 4675.450111] ath9k: 0x0 => 0xf4041071
[ 4675.450121] ath9k: new IMR 0x918414b4
[ 4675.450137] ath9k: enable IER
[ 4675.449939] ath9k: [ 4675.450152] ath9k: AR_IMR 0x918414b4 IER 0x1
0xf4041071 => 0x0
[ 4675.449959] ath9k: disable IER
[ 4675.449977] ath9k: new IMR 0x0
[ 4675.450015] ath9k: tx queue 1 (360901a0), link f608cba0
[ 4675.450034] ath9k: TX complete: skb: f64d0900
[ 4675.450075] ath9k: qnum: 1, txq depth: 4
[ 4675.450087] ath9k: link[1] (f608cba0)=360871a0 (f60871a0)
[ 4675.450100] ath9k: Enable TXE on queue: 1
[ 4675.450111] ath9k: 0x0 => 0xf4041071
[ 4675.450121] ath9k: new IMR 0x918414b4
[ 4675.450137] ath9k: enable IER
[ 4675.450152] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.454474] ath9k: 0xf4041071 => 0x0
[ 4675.454492] ath9k: disable IER
[ 4675.454517] ath9k: new IMR 0x0
[ 4675.454558] ath9k: tx queue 1 (3608cba0), link f60871a0
[ 4675.454597] ath9k: TX complete: skb: f64d0180
[ 4675.454620] ath9k: qnum: 1, txq depth: 4
[ 4675.454631] ath9k: link[1] (f60871a0)=36089a20 (f6089a20)
[ 4675.454643] ath9k: Enable TXE on queue: 1
[ 4675.454655] ath9k: 0x0 => 0xf4041071
[ 4675.454666] ath9k: [ 4675.454474] ath9k: new IMR 0x918414b4
[ 4675.454681] ath9k: enable IER
[ 4675.454696] ath9k: AR_IMR 0x918414b4 IER 0x1
0xf4041071 => 0x0
[ 4675.454492] ath9k: disable IER
[ 4675.454517] ath9k: new IMR 0x0
[ 4675.454558] ath9k: tx queue 1 (3608cba0), link f60871a0
[ 4675.454597] ath9k: TX complete: skb: f64d0180
[ 4675.454620] ath9k: qnum: 1, txq depth: 4
[ 4675.454631] ath9k: link[1] (f60871a0)=36089a20 (f6089a20)
[ 4675.454643] ath9k: Enable TXE on queue: 1
[ 4675.454655] ath9k: 0x0 => 0xf4041071
[ 4675.454666] ath9k: new IMR 0x918414b4
[ 4675.454681] ath9k: enable IER
[ 4675.454696] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.461246] ath9k: 0xf4041071 => 0x0
[ 4675.461270] ath9k: disable IER
[ 4675.461295] ath9k: new IMR 0x0
[ 4675.461334] ath9k: tx queue 1 (3608cba0), link f6089a20
[ 4675.461379] ath9k: TX complete: skb: f64c5240
[ 4675.461402] ath9k: qnum: 1, txq depth: 4
[ 4675.461413] ath9k: link[1] (f6089a20)=36082c70 (f6082c70)
[ 4675.461425] ath9k: Enable TXE on queue: 1
[ 4675.461436] ath9k: 0x0 => 0xf4041071
[ 4675.461447] ath9k: new IMR 0x918414b4
[ 4675.461246] ath9k: [ 4675.461462] ath9k: enable IER
[ 4675.461477] ath9k: AR_IMR 0x918414b4 IER 0x1
0xf4041071 => 0x0
[ 4675.461270] ath9k: disable IER
[ 4675.461295] ath9k: new IMR 0x0
[ 4675.461334] ath9k: tx queue 1 (3608cba0), link f6089a20
[ 4675.461379] ath9k: TX complete: skb: f64c5240
[ 4675.461402] ath9k: qnum: 1, txq depth: 4
[ 4675.461413] ath9k: link[1] (f6089a20)=36082c70 (f6082c70)
[ 4675.461425] ath9k: Enable TXE on queue: 1
[ 4675.461436] ath9k: 0x0 => 0xf4041071
[ 4675.461447] ath9k: [ 4675.462743] ath9k: 0xf4041071 => 0x0
[ 4675.462765] ath9k: disable IER
new IMR 0x918414b4
[ 4675.462807] ath9k: new IMR 0x0
[ 4675.461462] ath9k: [ 4675.462841] ath9k: tx queue 1 (36089a20), link f6082c70
[ 4675.462865] ath9k: TX complete: skb: f64c5f00
enable IER
[ 4675.462912] ath9k: qnum: 1, txq depth: 4
[ 4675.462931] ath9k: link[1] (f6082c70)=3608f9c0 (f608f9c0)
[ 4675.462952] ath9k: Enable TXE on queue: 1
[ 4675.462971] ath9k: 0x0 => 0xf4041071
[ 4675.462989] ath9k: new IMR 0x918414b4
[ 4675.463012] ath9k: enable IER
[ 4675.463034] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.461477] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.462743] ath9k: 0xf4041071 => 0x0
[ 4675.462765] ath9k: disable IER
[ 4675.462807] ath9k: new IMR 0x0
[ 4675.462841] ath9k: tx queue 1 (36089a20), link f6082c70
[ 4675.462865] ath9k: TX complete: skb: f64c5f00
[ 4675.462912] ath9k: qnum: 1, txq depth: 4
[ 4675.462931] ath9k: link[1] (f6082c70)=3608f9c0 (f608f9c0)
[ 4675.464170] ath9k: 0xf4041071 => 0x0
[ 4675.464189] ath9k: disable IER
[ 4675.464221] ath9k: new IMR 0x0
[ 4675.464250] ath9k: tx queue 1 (36089a20), link f608f9c0
[ 4675.464279] ath9k: TX complete: skb: f64c5d80
[ 4675.464303] ath9k: qnum: 1, txq depth: 4
[ 4675.464318] ath9k: link[1] (f608f9c0)=36081170 (f6081170)
[ 4675.464335] ath9k: Enable TXE on queue: 1
[ 4675.464350] ath9k: 0x0 => 0xf4041071
[ 4675.464364] ath9k: new IMR 0x918414b4
[ 4675.464383] ath9k: enable IER
[ 4675.464402] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.462952] ath9k: Enable TXE on queue: 1
[ 4675.462971] ath9k: 0x0 => 0xf4041071
[ 4675.462989] ath9k: new IMR 0x918414b4
[ 4675.463012] ath9k: enable IER
[ 4675.463034] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.464170] ath9k: 0xf4041071 => 0x0
[ 4675.464189] ath9k: disable IER
[ 4675.464221] ath9k: new IMR 0x0
[ 4675.464250] ath9k: tx queue 1 (36089a20), link f608f9c0
[ 4675.464279] ath9k: TX complete: skb: f64c5d80
[ 4675.464303] ath9k: qnum: 1, txq depth: 4
[ 4675.464318] ath9k: link[1] (f608f9c0)=36081170 (f6081170)
[ 4675.464335] ath9k: Enable TXE on queue: 1
[ 4675.464350] ath9k: 0x0 => 0xf4041071
[ 4675.464364] ath9k: new IMR 0x918414b4
[ 4675.464383] ath9k: enable IER
[ 4675.464402] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.471821] ath9k: 0xf4041071 => 0x0
[ 4675.471836] ath9k: disable IER
[ 4675.471857] ath9k: new IMR 0x0
[ 4675.471897] ath9k: tx queue 1 (36082c70), link f6081170
[ 4675.471914] ath9k: TX complete: skb: f64c5780
[ 4675.471933] ath9k: qnum: 1, txq depth: 4
[ 4675.471942] ath9k: link[1] (f6081170)=36089990 (f6089990)
[ 4675.471952] ath9k: Enable TXE on queue: 1
[ 4675.471961] ath9k: 0x0 => 0xf4041071
[ 4675.471970] ath9k: new IMR 0x918414b4
[ 4675.471983] ath9k: enable IER
[ 4675.471996] ath9k: AR_IMR 0x918414b4 IER 0x1
[ 4675.471821] ath9k: 0xf4041071 => 0x0
[ 4675.471836] ath9k: disable IER
[ 4675.471857] ath9k: new IMR 0x0
[ 4675.471897] ath9k: tx queue 1 (36082c70), link f6081170
[ 4675.471914] ath9k: TX complete: skb: f64c5780
[ 4675.471933] ath9k: qnum: 1, txq depth: 4
[ 4675.471942] ath9k: link[1] (f6081170)=36089990 (f6089990)
[ 4675.471952] ath9k: Enable TXE on queue: 1
[ 4675.471961] ath9k: 0x0 => 0xf4041071
[ 4675.471970] ath9k: [ 4675.473290] ath9k: 0xf4041071 => 0x0
[ 4675.473304] ath9k: disable IER
[ 4675.473322] ath9k: new IMR 0x918414b4
new IMR 0x0
[ 4675.473364] ath9k: tx queue 1 (3608f9c0), link f6089990
[ 4675.473379] ath9k: TX complete: skb: f64c5a80
[ 4675.471983] ath9k: [ 4675.473425] ------------[ cut here ]------------
[ 4675.473434] kernel BUG at drivers/net/wireless/ath/ath9k/xmit.c:181!
[ 4675.473441] invalid opcode: 0000 [#1] SMP 
[ 4675.473453] last sysfs file: /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:0c/PNP0C0A:00/power_supply/BAT1/energy_full
[ 4675.473462] Modules linked in: ath9k mac80211 ath cfg80211enable IER
 netconsole configfs[ 4675.471996] ath9k:  binfmt_misc ppdev snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcmAR_IMR 0x918414b4 IER 0x1
 snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi bridge stp arc4 snd_seq_midi_event snd_seq[ 4675.473290] ath9k:  iptable_filter snd_timer bnep joydev snd_seq_device ip_tables snd lp0xf4041071 => 0x0
 psmouse btusb x_tables soundcore dell_laptop parport led_class snd_page_alloc serio_raw[ 4675.473304] ath9k:  dcdbas usbhid fbcon tileblit font bitblit softcursor i915disable IER
 usb_storage drm_kms_helper intel_agp r8169 drm i2c_algo_bit video mii agpgart output [last unloaded: cfg80211]
[ 4675.473787] 
[ 4675.473797] Pid: 648, comm: dd Tainted: G        W  (2.6.32-rc6 #3) Inspiron 1012
[ 4675.473805] EIP: 0060:[<f8a9f872>] EFLAGS: 00010286 CPU: 1
[ 4675.473825] EIP is at ath_txq_schedule+0x5f2/0x600 [ath9k]
[ 4675.473833] EAX: 00000002 EBX: f6676e40 ECX: 00000069 EDX: 0000006d
[ 4675.473841] ESI: f624422c EDI: 00000000 EBP: f649dcdc ESP: f649dc44
[ 4675.473322] ath9k: [ 4675.473848]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
new IMR 0x0
[ 4675.473856] Process dd (pid: 648, ti=f649c000 task=f6482610 task.ti=f649c000)
[ 4675.473862] Stack:
[ 4675.473867]  08000001 00000000 f649dcc8 f6030c28 f62465bc f62465b4[ 4675.473364] ath9k:  00000000 f62465ac
[ 4675.473960] <0> f6030c00 00490018 00000000 f6030c00 00000000tx queue 1 (3608f9c0), link f6089990
 000015a8 f6244234 f6244404
[ 4675.473990] <0> f6030c10 01548000 00000000[ 4675.473379] ath9k:  f6676e40 00000010 000015a8 f6676e40 0000007b
[ 4675.474089] Call Trace:
[ 4675.474110]  [<f8a9fb77>] ? ath_tx_tasklet+0x2f7/0x3c0 [ath9k]
TX complete: skb: f64c5a80
[ 4675.474129]  [<f8a9a99f>] ? ath9k_tasklet+0xcf/0x120 [ath9k]
[ 4675.474142]  [<c014ae72>] ? tasklet_action+0xa2/0xb0
[ 4675.474153]  [<c014c3b0>] ? __do_softirq+0x90/0x1a0
[ 4675.474163]  [<c0120786>] ? ack_apic_level+0x66/0x170
[ 4675.474172]  [<c014c4fd>] ? do_softirq+0x3d/0x40
[ 4675.474182]  [<c014c63d>] ? irq_exit+0x5d/0x70
[ 4675.474191]  [<c0104b40>] ? do_IRQ+0x50/0xc0
[ 4675.474201]  [<c0103830>] ? common_interrupt+0x30/0x40
[ 4675.474210]  [<c012007b>] ? set_ht_irq_affinity+0x1b/0x90
[ 4675.473425] ------------[ cut here ]------------
[ 4675.474222]  [<c0566e90>] ? _spin_unlock_irqrestore+0x10/0x20
[ 4675.474231]  [<c01342d7>] ? __wake_up_sync_key+0x47/0x60
[ 4675.474240]  [<c0134302>] ? __wake_up_sync+0x12/0x20
[ 4675.474251]  [<c01f75b1>] ? pipe_write+0x2f1/0x450
[ 4675.474330]  [<c01efa0c>] ? do_sync_write+0xbc/0x100
[ 4675.474340]  [<c014f3e0>] ? capable+0x10/0x40
[ 4675.474352]  [<c015fe10>] ? autoremove_wake_function+0x0/0x40
[ 4675.473434] kernel BUG at drivers/net/wireless/ath/ath9k/xmit.c:181!
[ 4675.474362]  [<c0566e58>] ? _spin_lock+0x8/0x10
[ 4675.474373]  [<c0230fc9>] ? pde_users_dec+0x39/0x50
[ 4675.474383]  [<c02d3bef>] ? security_file_permission+0xf/0x20
[ 4675.474393]  [<c01efbaf>] ? rw_verify_area+0x5f/0xe0
[ 4675.474402]  [<c01efcca>] ? vfs_write+0x9a/0x190
[ 4675.474412]  [<c01ef950>] ? do_sync_write+0x0/0x100
[ 4675.474421]  [<c01f077d>] ? sys_write+0x3d/0x70
[ 4675.474430]  [<c0103103>] ? sysenter_do_call+0x12/0x28
[ 4675.474437] Code: 08 8b 53 2c 89 4b 2c [ 4675.473441] invalid opcode: 0000 [#1] 8b SMP 9d 74 ff ff ff 89 50 0c 89 58 08 89 0a e9 f1 fc ff ff 8d b4 26 00 00 00 00 bf 01 00 00 00 e9 26 fc ff ff <0f> 0b eb fe 8d 76 00 8d bc 27 00 00 00 00 55 89 e5 57 56 53 83 
[ 4675.474797] EIP: [<f8a9f872>] ath_txq_schedule+0x5f2/0x600 [ath9k] SS:ESP 0068:f649dc44
[ 4675.474897] ---[ end trace 37e2cdd9bb879297 ]---
[ 4675.474905] Kernel panic - not syncing: Fatal exception in interrupt
[ 4675.474914] Pid: 648, comm: dd Tainted: G      D W  2.6.32-rc6 #3
[ 4675.474920] Call Trace:
[ 4675.474929]  [<c05644af>] ? printk+0x18/0x21
[ 4675.474938]  [<c05643ec>] panic+0x43/0xee
[ 4675.474948]  [<c0567c45>] oops_end+0xc5/0xd0
[ 4675.474957]  [<c01064bf>] die+0x4f/0x70
[ 4675.474966]  [<c0567386>] do_trap+0x96/0xc0
[ 4675.474974]  [<c01045e0>] ? do_invalid_op+0x0/0xa0
[ 4675.474983]  [<c0104666>] do_invalid_op+0x86/0xa0
[ 4675.475001]  [<f8a9f872>] ? ath_txq_schedule+0x5f2/0x600 [ath9k]
[ 4675.475013]  [<c0492638>] ? __kfree_skb+0x38/0x90
[ 4675.475022]  [<c0492638>] ? __kfree_skb+0x38/0x90
[ 4675.475107]  [<c04926ac>] ? consume_skb+0x1c/0x40
[ 4675.475126]  [<f8a5684f>] ? ieee80211_tx_status+0x41f/0x450 [mac80211]
[ 4675.475137]  [<c0126d18>] ? default_spin_lock_flags+0x8/0x10
[ 4675.475147]  [<c0566d7a>] ? _spin_lock_irqsave+0x2a/0x40
[ 4675.475156]  [<c0567103>] error_code+0x73/0x80
[ 4675.475174]  [<f8a9f872>] ? ath_txq_schedule+0x5f2/0x600 [ath9k]
[ 4675.475192]  [<f8a9fb77>] ath_tx_tasklet+0x2f7/0x3c0 [ath9k]
[ 4675.475209]  [<f8a9a99f>] ath9k_tasklet+0xcf/0x120 [ath9k]
[ 4675.475220]  [<c014ae72>] tasklet_action+0xa2/0xb0
[ 4675.475229]  [<c014c3b0>] __do_softirq+0x90/0x1a0
[ 4675.475238]  [<c0120786>] ? ack_apic_level+0x66/0x170
[ 4675.475248]  [<c014c4fd>] do_softirq+0x3d/0x40
[ 4675.475256]  [<c014c63d>] irq_exit+0x5d/0x70
[ 4675.475265]  [<c0104b40>] do_IRQ+0x50/0xc0
[ 4675.475274]  [<c0103830>] common_interrupt+0x30/0x40
[ 4675.475283]  [<c012007b>] ? set_ht_irq_affinity+0x1b/0x90
[ 4675.475293]  [<c0566e90>] ? _spin_unlock_irqrestore+0x10/0x20
[ 4675.475302]  [<c01342d7>] __wake_up_sync_key+0x47/0x60
[ 4675.475311]  [<c0134302>] __wake_up_sync+0x12/0x20

[ 4675.475321]  [<c01f75b1>] pipe_write+0x2f1/0x450
[ 4675.475331]  [<c01efa0c>] do_sync_write+0xbc/0x100
[ 4675.475341]  [<c014f3e0>] ? capable+0x10/0x40
[ 4675.475351]  [<c015fe10>] ? autoremove_wake_function+0x0/0x40
[ 4675.475361]  [<c0566e58>] ? _spin_lock+0x8/0x10
[ 4675.475370]  [<c0230fc9>] ? pde_users_dec+0x39/0x50
[ 4675.475380]  [<c02d3bef>] ? security_file_permission+0xf/0x20
[ 4675.475389]  [<c01efbaf>] ? rw_verify_area+0x5f/0xe0
[ 4675.475472]  [<c01efcca>] vfs_write+0x9a/0x190
[ 4675.475483]  [<c01ef950>] ? do_sync_write+0x0/0x100
[ 4675.475492]  [<c01f077d>] sys_write+0x3d/0x70
[ 4675.473453] last sysfs file: /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:0c/PNP0C0A:00/power_supply/BAT1/energy_full
[ 4675.475501]  [<c0103103>] sysenter_do_call+0x12/0x28
[ 4675.475520] [drm:drm_fb_helper_panic] *ERROR* panic occurred, switching back to text console
[ 4675.475532] BUG: scheduling while atomic: dd/648/0x10000200
[ 4675.473462] Modules linked in:[ 4675.475537] Modules linked in: ath9k mac80211 ath cfg80211 netconsole configfs binfmt_misc ppdev snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss ath9k snd_mixer_oss snd_pcm snd_seq_dummy mac80211 snd_seq_oss snd_seq_midi snd_rawmidi bridge stp arc4 snd_seq_midi_event snd_seq ath iptable_filter snd_timer bnep joydev snd_seq_device ip_tables snd lp psmouse cfg80211 btusb x_tables soundcore dell_laptop parport led_class snd_page_alloc serio_raw dcdbas netconsole usbhid fbcon tileblit font bitblit softcursor i915 usb_storage configfs drm_kms_helper intel_agp r8169 drm i2c_algo_bit video mii agpgart binfmt_misc output [last unloaded: cfg80211]
[ 4675.475866] 
[ 4675.475873] Pid: 648, comm: dd Tainted: G      D W  (2.6.32-rc6 #3) Inspiron 1012
[ 4675.475881] EIP: 0060:[<c0566e90>] EFLAGS: 00000292 CPU: 1
[ 4675.475891] EIP is at _spin_unlock_irqrestore+0x10/0x20
 ppdev[ 4675.475898] EAX: 00000292 EBX: 00000292 ECX: f6497204 EDX: 00000292
[ 4675.475905] ESI: 00000001 EDI: 00000292 EBP: f649de44 ESP: f649de40
[ 4675.475912]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 4675.475919] CR0: 8005003b CR2: 09519088 CR3: 36b59000 CR4: 000006d0
[ 4675.475926] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 4675.475933] DR6: ffff0ff0 DR7: 00000400
[ 4675.475938] Call Trace:
[ 4675.475947]  [<c01342d7>] __wake_up_sync_key+0x47/0x60
[ 4675.475956]  [<c0134302>] __wake_up_sync+0x12/0x20
[ 4675.475965]  [<c01f75b1>] pipe_write+0x2f1/0x450
[ 4675.475975]  [<c01efa0c>] do_sync_write+0xbc/0x100
[ 4675.475985]  [<c014f3e0>] ? capable+0x10/0x40
[ 4675.476063]  [<c015fe10>] ? autoremove_wake_function+0x0/0x40
[ 4675.476075]  [<c0566e58>] ? _spin_lock+0x8/0x10
[ 4675.476084]  [<c0230fc9>] ? pde_users_dec+0x39/0x50
 snd_hda_codec_realtek[ 4675.476094]  [<c02d3bef>] ? security_file_permission+0xf/0x20
 snd_hda_codec[ 4675.476103]  [<c01efbaf>] ? rw_verify_area+0x5f/0xe0
[ 4675.476113]  [<c01efcca>] vfs_write+0x9a/0x190
[ 4675.476122]  [<c01ef950>] ? do_sync_write+0x0/0x100
[ 4675.476131]  [<c01f077d>] sys_write+0x3d/0x70
 snd_hwdep[ 4675.476140]  [<c0103103>] sysenter_do_call+0x12/0x28
[ 4675.476187] [drm] Big FIFO is enabled
 snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi bridge stp arc4 snd_seq_midi_event iptable_filter snd_timer bnep snd_seq_device ip_tables snd lp psmouse btusb x_tables soundcore parport led_class snd_page_alloc serio_raw dcdbas usbhid fbcon tileblit font bitblit softcursor i915 drm_kms_helper intel_agp r8169 i2c_algo_bit video mii agpgart output [last unloaded: cfg80211][ 4675.473787] 
[ 4675.473797] Pid: 648, comm: dd Tainted: G        W  (2.6.32-rc6 #3) Inspiron 1012
[ 4675.473805] EIP: 0060:[<f8a9f872>] EFLAGS: 00010286 CPU: 1
[ 4675.473825] EIP is at ath_txq_schedule+0x5f2/0x600 [ath9k]
[ 4675.473833] EAX: 00000002 EBX: f6676e40 ECX: 00000069 EDX: 0000006d
[ 4675.473841] ESI: f624422c EDI: 00000000 EBP: f649dcdc ESP: f649dc44
[ 4675.473848]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 4675.473856] Process dd (pid: 648, ti=f649c000 task=f6482610 task.ti=f649c000)
[ 4675.473862] Stack:
[ 4675.473867]  08000001 00000000 f649dcc8 f6030c28 f62465bc f62465b4 00000000 f62465ac
[ 4675.473960] <0> f6030c00 00490018 00000000 f6030c00 00000000 000015a8 f6244234 f6244404
[ 4675.473990] <0> 01548000 00000000 f6676e40 00000010 000015a8 f6676e40 0000007b
[ 4675.474110]  [<f8a9fb77>] ? ath_tx_tasklet+0x2f7/0x3c0 [ath9k]
[ 4675.474142]  [<c014ae72>] ? tasklet_action+0xa2/0xb0
[ 4675.474153]  [<c014c3b0>] ? __do_softirq+0x90/0x1a0
[ 4675.474163]  [<c0120786>] ? ack_apic_level+0x66/0x170
[ 4675.474172]  [<c014c4fd>] ? do_softirq+0x3d/0x40
[ 4675.474182]  [<c014c63d>] ? irq_exit+0x5d/0x70
[ 4675.474191]  [<c0104b40>] ? do_IRQ+0x50/0xc0
[ 4675.474201]  [<c0103830>] ? common_interrupt+0x30/0x40
[ 4675.474210]  [<c012007b>] ? set_ht_irq_affinity+0x1b/0x90
[ 4675.474222]  [<c0566e90>] ? _spin_unlock_irqrestore+0x10/0x20
[ 4675.474231]  [<c01342d7>] ? __wake_up_sync_key+0x47/0x60
[ 4675.474240]  [<c0134302>] ? __wake_up_sync+0x12/0x20
[ 4675.474251]  [<c01f75b1>] ? pipe_write+0x2f1/0x450
[ 4675.474330]  [<c01efa0c>] ? do_sync_write+0xbc/0x100
[ 4675.474340]  [<c014f3e0>] ? capable+0x10/0x40
[ 4675.474352]  [<c015fe10>] ? autoremove_wake_function+0x0/0x40
[ 4675.474362]  [<c0566e58>] ? _spin_lock+0x8/0x10
[ 4675.474373]  [<c0230fc9>] ? pde_users_dec+0x39/0x50
[ 4675.474383]  [<c02d3bef>] ? security_file_permission+0xf/0x20
[ 4675.474393]  [<c01efbaf>] ? rw_verify_area+0x5f/0xe0
[ 4675.474402]  [<c01efcca>] ? vfs_write+0x9a/0x190
[ 4675.474412]  [<c01ef950>] ? do_sync_write+0x0/0x100
[ 4675.474421]  [<c01f077d>] ? sys_write+0x3d/0x70
[ 4675.474430]  [<c0103103>] ? sysenter_do_call+0x12/0x28
[ 4675.474437] Code: 08 8b 53 2c 89 4b 2c 8b 9d 74 ff ff ff 89 0c 89 58 08 89 0a f1 fc ff ff 8d b4 00 00 00 00 bf 01 00 00 e9 26 fc ff ff <0f> 0b fe 8d 76 00 8d bc 00 00 00 00 55 89 e5 57 53 83 
[ 4675.474797] EIP: [<f8a9f872>] ath_txq_schedule+0x5f2/0x600 [ath9k] SS:ESP 0068:f649dc44
[ 4675.474897] ---[ end trace 37e2cdd9bb879297 ]---
[ 4675.474905] Kernel panic - not syncing: Fatal exception in interrupt
[ 4675.474914] Pid: 648, comm: dd Tainted: G      D W  2.6.32-rc6 #3
[ 4675.474920] Call Trace:
[ 4675.474929]  [<c05644af>] ? printk+0x18/0x21
[ 4675.474938]  [<c05643ec>] panic+0x43/0xee
[ 4675.474948]  [<c0567c45>] oops_end+0xc5/0xd0
[ 4675.474957]  [<c01064bf>] die+0x4f/0x70
[ 4675.474966]  [<c0567386>] do_trap+0x96/0xc0
[ 4675.474974]  [<c01045e0>] ? do_invalid_op+0x0/0xa0
[ 4675.474983]  [<c0104666>] do_invalid_op+0x86/0xa0
[ 4675.475001]  [<f8a9f872>] ? ath_txq_schedule+0x5f2/0x600 [ath9k]
[ 4675.475013]  [<c0492638>] ? __kfree_skb+0x38/0x90
[ 4675.475022]  [<c0492638>] ? __kfree_skb+0x38/0x90
[ 4675.475107]  [<c04926ac>] ? consume_skb+0x1c/0x40
[ 4675.475126]  [<f8a5684f>] ? ieee80211_tx_status+0x41f/0x450 [mac80211]
[ 4675.475137]  [<c0126d18>] ? default_spin_lock_flags+0x8/0x10
[ 4675.475147]  [<c0566d7a>] ? _spin_lock_irqsave+0x2a/0x40
[ 4675.475156]  [<c0567103>] error_code+0x73/0x80
[ 4675.475174]  [<f8a9f872>] ? ath_txq_schedule+0x5f2/0x600 [ath9k]
[ 4675.475192]  [<f8a9fb77>] ath_tx_tasklet+0x2f7/0x3c0 [ath9k]
[ 4675.475209]  [<f8a9a99f>] ath9k_tasklet+0xcf/0x120 [ath9k]
[ 4675.475220]  [<c014ae72>] tasklet_action+0xa2/0xb0
[ 4675.475229]  [<c014c3b0>] __do_softirq+0x90/0x1a0
[ 4675.475238]  [<c0120786>] ? ack_apic_level+0x66/0x170
[ 4675.475248]  [<c014c4fd>] do_softirq+0x3d/0x40
[ 4675.475256]  [<c014c63d>] irq_exit+0x5d/0x70
[ 4675.475265]  [<c0104b40>] do_IRQ+0x50/0xc0
[ 4675.475274]  [<c0103830>] common_interrupt+0x30/0x40
[ 4675.475283]  [<c012007b>] ? set_ht_irq_affinity+0x1b/0x90
[ 4675.475293]  [<c0566e90>] ? _spin_unlock_irqrestore+0x10/0x20
[ 4675.475302]  [<c01342d7>] __wake_up_sync_key+0x47/0x60
[ 4675.475311]  [<c0134302>] __wake_up_sync+0x12/0x20
[ 4675.475321]  [<c01f75b1>] pipe_write+0x2f1/0x450
[ 4675.475331]  [<c01efa0c>] do_sync_write+0xbc/0x100
[ 4675.475341]  [<c014f3e0>] ? capable+0x10/0x40
[ 4675.475351]  [<c015fe10>] ? autoremove_wake_function+0x0/0x40
[ 4675.475361]  [<c0566e58>] ? _spin_lock+0x8/0x10
[ 4675.475370]  [<c0230fc9>] ? pde_users_dec+0x39/0x50
[ 4675.475380]  [<c02d3bef>] ? security_file_permission+0xf/0x20
[ 4675.475389]  [<c01efbaf>] ? rw_verify_area+0x5f/0xe0
[ 4675.475472]  [<c01efcca>] vfs_write+0x9a/0x190
[ 4675.475483]  [<c01ef950>] ? do_sync_write+0x0/0x100
[ 4675.475492]  [<c01f077d>] sys_write+0x3d/0x70
[ 4675.475501]  [<c0103103>] sysenter_do_call+0x12/0x28
[ 4675.475520] [drm:drm_fb_helper_panic] *ERROR* panic occurred, switching back to text console
[ 4675.475532] BUG: scheduling while atomic: dd/648/0x10000200
[ 4675.475537] Modules linked in: ath9k mac80211 ath cfg80211 netconsole configfs binfmt_misc ppdev snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_midi snd_rawmidi bridge stp arc4 snd_seq_midi_event snd_seq iptable_filter snd_timer joydev snd_seq_device ip_tables snd lp psmouse btusb x_tables dell_laptop parport led_class snd_page_alloc serio_raw dcdbas fbcon tileblit font bitblit softcursor i915 usb_storage drm_kms_helper intel_agp r8169 drm video mii agpgart output [last unloaded: cfg80211]
[ 4675.475866] 
[ 4675.475873] Pid: 648, comm: dd Tainted: G      D W  (2.6.32-rc6 #3) Inspiron 1012
[ 4675.475881] EIP: 0060:[<c0566e90>] EFLAGS: 00000292 CPU: 1
[ 4675.475891] EIP is at _spin_unlock_irqrestore+0x10/0x20
[ 4675.475898] EAX: 00000292 EBX: 00000292 ECX: f6497204 EDX: 00000292
[ 4675.475905] ESI: 00000001 EDI: 00000292 EBP: f649de44 ESP: f649de40
[ 4675.475912]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 4675.475919] CR0: 8005003b CR2: 09519088 CR3: 36b59000 CR4: 000006d0
[ 4675.475926] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 4675.475933] DR6: ffff0ff0 DR7: 00000400
[ 4675.475938] Call Trace:
[ 4675.475947]  [<c01342d7>] __wake_up_sync_key+0x47/0x60
[ 4675.475956]  [<c0134302>] __wake_up_sync+0x12/0x20
[ 4675.475965]  [<c01f75b1>] pipe_write+0x2f1/0x450
[ 4675.475975]  [<c01efa0c>] do_sync_write+0xbc/0x100
[ 4675.475985]  [<c014f3e0>] ? capable+0x10/0x40
[ 4675.476063]  [<c015fe10>] ? autoremove_wake_function+0x0/0x40
[ 4675.476075]  [<c0566e58>] ? _spin_lock+0x8/0x10
[ 4675.476084]  [<c0230fc9>] ? pde_users_dec+0x39/0x50
[ 4675.476094]  [<c02d3bef>] ? security_file_permission+0xf/0x20
[ 4675.476103]  [<c01efbaf>] ? rw_verify_area+0x5f/0xe0
[ 4675.476113]  [<c01efcca>] vfs_write+0x9a/0x190
[ 4675.476122]  [<c01ef950>] ? do_sync_write+0x0/0x100
[ 4675.476131]  [<c01f077d>] sys_write+0x3d/0x70
[ 4675.476140]  [<c0103103>] sysenter_do_call+0x12/0x28
[ 4675.476187] [drm] Big FIFO is enabled
