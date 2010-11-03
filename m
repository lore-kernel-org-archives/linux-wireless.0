Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:60142 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106Ab0KCRsI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 13:48:08 -0400
Message-ID: <4CD1A050.4060709@openwrt.org>
Date: Wed, 03 Nov 2010 18:48:00 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [RFC] ath9k: fix tx queue selection
References: <alpine.DEB.2.00.1011021655080.23045@vtdt3>	<4CD046D2.4080703@openwrt.org>	<4CD04C61.4070007@openwrt.org>	<AANLkTikUUue=Nt0iFPcQC68kDCh=EeEpeBT9xnhW6bf+@mail.gmail.com>	<4CD05E49.70701@openwrt.org>	<AANLkTinBSeUSGR_9P-e5ZgKSeLfp36JfUbJOk73hpnQ2@mail.gmail.com>	<4CD08C86.9030202@openwrt.org>	<AANLkTi=zzGv7Vagb18Rpby=Xo_+g2yuVoFvAejU1KEud@mail.gmail.com>	<4CD14D39.5020401@openwrt.org>	<AANLkTinvmmqCsgKsfAikdsb88_bCV=VL2+1ZxrwdFHFm@mail.gmail.com>	<4CD19421.6000407@openwrt.org> <AANLkTik_dZ2ZVDLHOiDwj6XsxGkA=K4meW_LPPnnjDo7@mail.gmail.com>
In-Reply-To: <AANLkTik_dZ2ZVDLHOiDwj6XsxGkA=K4meW_LPPnnjDo7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-03 6:31 PM, Björn Smedman wrote:
> 2010/11/3 Felix Fietkau <nbd@openwrt.org>:
>> On 2010-11-03 5:27 PM, Björn Smedman wrote:
>>> Ok, regardless. So lets say there is a bug in mac80211 that allows a
>>> "mismatch" between header qos tid and skb queue mapping to occur
>>> (which in fact there is because this happens all the time with my
>>> frame injection heavy app). Then it's ok for ath9k to screw up the
>>> locking, possibly corrupt data and so on, silently?
>> I don't see potential for locking issues or data corruption here, even
>> if such a bug were to show up.
> 
> Then I think this is the only point we really disagree on. :)
> 
> It goes like this. When we get to ath_tx_start_dma() there already is
> a txq assigned (passed as txctl->txq) and we lock that txq. Then, if
> it's aggregation data we look up the tid:
> 
>                 an = (struct ath_node *)tx_info->control.sta->drv_priv;
>                 tid = ATH_AN_2_TID(an, bf->bf_tidno);
> 
> Notice how bf->bf_tidno is used. This contains the TID from the 802.11
> header qos field. That means tid->ac->txq may not be the same as
> txctl->txq if there is a mismatch between frame data and skb queue
> mapping. Now we call ath_tx_send_ampdu() which presumes the txq (and
> therefore the associated tid) is already locked and starts fiddling
> with e.g. tid->buf_q, in this case without holding
> tid->ac->txq->axq_lock. This is racy e.g. against ath_draintxq() /
> ath_txq_drain_pending_buffers() which does not know about this madness
> and locks the correct txq.
Hmm, I guess you have a point there ;)

>> I'm not saying we should assume that everything is always fine, but I do
>> object to adding defensive code against made up scenarios of potential
>> bugs that "might" be introduced at some point in the future.
> 
> I can see your point. I don't want lots of defensive stuff (like what
> you removed in your patch). But I still feel the balance is wrong.
> Take one recent case for example: We're not 100% sure we can always
> stop RX dma. In fact, a few weeks ago we weren't even sure what we
> didn't start it when we weren't supposed to. Yet for some reason there
> seems to be a consensus it is a good idea to keep ds_data of all those
> dma descriptors pointing at arbitrary kernel data. I realize it takes
> some time and adds some clutter to do "ds_data = 0". I also understand
> it does not help in all cases. But I think it's a reasonable
> precaution under the circumstances. It's like in medicine, patients
> will die but when they do you want to be able to say "we did
> everything we could". ;)
Actually, when dealing with hardware pointers, I'm not sure setting them
to 0 makes things any better, since 0 still points to a physical RAM
location :)

- Felix
