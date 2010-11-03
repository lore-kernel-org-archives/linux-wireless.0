Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:33263 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756017Ab0KCQ4J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 12:56:09 -0400
Message-ID: <4CD19421.6000407@openwrt.org>
Date: Wed, 03 Nov 2010 17:56:01 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [RFC] ath9k: fix tx queue selection
References: <alpine.DEB.2.00.1011021655080.23045@vtdt3>	<4CD046D2.4080703@openwrt.org>	<4CD04C61.4070007@openwrt.org>	<AANLkTikUUue=Nt0iFPcQC68kDCh=EeEpeBT9xnhW6bf+@mail.gmail.com>	<4CD05E49.70701@openwrt.org>	<AANLkTinBSeUSGR_9P-e5ZgKSeLfp36JfUbJOk73hpnQ2@mail.gmail.com>	<4CD08C86.9030202@openwrt.org>	<AANLkTi=zzGv7Vagb18Rpby=Xo_+g2yuVoFvAejU1KEud@mail.gmail.com>	<4CD14D39.5020401@openwrt.org> <AANLkTinvmmqCsgKsfAikdsb88_bCV=VL2+1ZxrwdFHFm@mail.gmail.com>
In-Reply-To: <AANLkTinvmmqCsgKsfAikdsb88_bCV=VL2+1ZxrwdFHFm@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-03 5:27 PM, Björn Smedman wrote:
>>> It comes down to this: either we look at the header qos when we select
>>> the queue (so the above cannot happen) or we relay on mac80211 to set
>>> the header qos and the skb queue mapping in a certain way. If we
>>> choose the later I vote for a BUG_ON(txctl->txq != tid->ac->txq) in
>>> ath_tx_send_ampdu().
>> For regular QoS data frames (and no other frames ever hit the
>> aggregation code) there is only one possible way to map tid -> ac ->
>> queue. I did review those code paths, and I believe them to be safe.
>> If you want, we can add a WARN_ON_ONCE later, but definitely no BUG_ON.
> 
> I've briefly looked through the IEEE Std 802.11e-2005. There is a
> clear requirement that "There shall be no reordering of unicast MSDUs
> with the same TID value and addressed to the same destination" in
> analog to what Hulmut pointed out earlier. Other than that the only
> reference I can find is that: "The MAC data service for QSTAs shall
> incorporate a TID with each MA-UNITDATA.request service. This TID
> associates the MSDU with the AC or TS queue for the indicated
> traffic." Why are you sure there is only one way to map tid -> ac ->
> queue? I don't think it's hard to come up with a case where you want
> to map differently (e.g. depending on RA or even TA).
Take a look at Table 9-1 on page 253 (PDF page 301) in 802.11-2007.

> Ok, regardless. So lets say there is a bug in mac80211 that allows a
> "mismatch" between header qos tid and skb queue mapping to occur
> (which in fact there is because this happens all the time with my
> frame injection heavy app). Then it's ok for ath9k to screw up the
> locking, possibly corrupt data and so on, silently?
I don't see potential for locking issues or data corruption here, even
if such a bug were to show up.

> Other than that I guess that it's basically an argument about
> aesthetics, and you may very well be right. All I know is that I've
> been following ath9k development now for almost two years and I'm
> amazed by the severity of bugs that are still found, and I guess yet
> to be found. We're dma:ing all over the place, deadlocking queues and
> so on, on a regular basis, or at least we where 3 months ago. After
> each one of these is fixed the attitude seems to be "now everything is
> perfect and suggesting there could be some more problems or will be in
> the future is just plain rude". Then yet another is found...
I'm not saying we should assume that everything is always fine, but I do
object to adding defensive code against made up scenarios of potential
bugs that "might" be introduced at some point in the future.

> If you relay on something so fragile as the contents of frame data
> "matching" skb_get_queue_mapping() I think you owe me at least a
> WARN_ON_ONCE before you start corrupting memory. ;)
The assumption that I make is not just about some random field in the
frame contents. I'm assuming that ieee80211_select_queue() makes a sane
decision that matches the description in the standard, and that the
network stack preserves the decision that this function made.
And besides - it's not like part of ath9k that cares about the TID is
going to live on for much longer :)

- Felix
