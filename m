Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58269 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab0JLSgB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 14:36:01 -0400
Message-ID: <4CB4AA89.1070009@candelatech.com>
Date: Tue, 12 Oct 2010 11:35:53 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
References: <4CAB59B2.5050106@candelatech.com> <4CAB627F.8020804@candelatech.com> <AANLkTi=sT5QJe4V8gFGjF-nzx0uJAMLG_XG2715qrEEd@mail.gmail.com> <4CAB64AD.4080105@candelatech.com> <AANLkTi=3dHbB5tmQDp3Ba54-DqQydVCkNdFo1vKbfaGY@mail.gmail.com> <4CAB6B08.4050801@candelatech.com> <4CAE0474.4090605@candelatech.com> <1286475250.20974.22.camel@jlt3.sipsolutions.net> <AANLkTinbRSnPVgbBxvVpMdnP+K--bye=Q-miHf4X44kz@mail.gmail.com> <4CAE13F6.2010003@candelatech.com> <AANLkTimEZ5GY7WFz-F4YyC+6MEwNn2Dki4tonp645XrS@mail.gmail.com> <4CAE1DFB.303@candelatech.com> <1286479642.20974.32.camel@jlt3.sipsolutions.net> <AANLkTimxp703Gy_Atg8=wpFszRDR=OJCXwOUKRh-a-d7@mail.gmail.com> <AANLkTi=t-P_5c14brJohM8UgxeOknv+3syO=7W=ix6qf@mail.gmail.com> <AANLkTinC46a+nE-XOQuBCmRJwjzgh24uC7ZJ7HtbVHnT@mail.gmail.com> <4CB378CD.1080800@candelatech.com> <AANLkTim42zmDwf744BCrPwa1kT5ph57bNMyvSyOpesVv@mail.gmail.com> <4CB3D598.7050904@candelatech.com> <AANLkTimPEg3ZU8CQUXfdpGdfbmhdE9O=GNY=g9gysTo4@mail.gmail.com>
In-Reply-To: <AANLkTimPEg3ZU8CQUXfdpGdfbmhdE9O=GNY=g9gysTo4@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/11/2010 11:10 PM, Luis R. Rodriguez wrote:
> On Mon, Oct 11, 2010 at 8:27 PM, Ben Greear<greearb@candelatech.com>  wrote:

>> Another thing I was thinking about:  Maybe the queue of skbs and dma
>> addresses
>> in ath9k is getting corrupted by multiple VIFs trying to write at once?
>>   Maybe
>> some locking is needed in the xmit path?
>
> That was my second hunch. My first shot was to use spin_lock_irqsave()
> over the the uses of the rxbuf list and that seemed to help but I
> still managed to get a poison eventually. My next item to check for is
> of the permissibility of creating too much pressure to the point we
> end up looping over the rxbuf list and race against mac80211 free'ing
> a buffer. Will test that tomorrow if nothing else comes up creeping my
> priority queue.

This code looks weird to me.  One of the paprd branches
deletes the skb, the other doesn't appear to.  Neither
null out bf->bf_mpdu, which would appear to leave a dangling
pointer in at least the dev_kfree_skb_any() branch.

ath_tx_complete frees it's skb in all cases, so another
bf->bf_mpdu dangling pointer issue.

Maybe at the least we should null out bf->bf_mpdu when
skb is consumed?

static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
				struct ath_txq *txq, struct list_head *bf_q,
				struct ath_tx_status *ts, int txok, int sendbar)
{
	struct sk_buff *skb = bf->bf_mpdu;
	unsigned long flags;
	int tx_flags = 0;

	if (sendbar)
		tx_flags = ATH_TX_BAR;

	if (!txok) {
		tx_flags |= ATH_TX_ERROR;

		if (bf_isxretried(bf))
			tx_flags |= ATH_TX_XRETRY;
	}

	dma_unmap_single(sc->dev, bf->bf_dmacontext, skb->len, DMA_TO_DEVICE);

	if (bf->bf_state.bfs_paprd) {
		if (time_after(jiffies,
			       bf->bf_state.bfs_paprd_timestamp +
			       msecs_to_jiffies(ATH_PAPRD_TIMEOUT)))
			dev_kfree_skb_any(skb);
		else
			complete(&sc->paprd_complete);
	} else {
		ath_tx_complete(sc, skb, bf->aphy, tx_flags);
		ath_debug_stat_tx(sc, txq, bf, ts);
	}


>
>    Luis


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

