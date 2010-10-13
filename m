Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:14614 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491Ab0JMFcF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 01:32:05 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 12 Oct 2010 22:31:55 -0700
Date: Wed, 13 Oct 2010 11:01:41 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Ben Greear <greearb@candelatech.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
Message-ID: <20101013053141.GA15798@vasanth-laptop>
References: <4CAE1DFB.303@candelatech.com> <1286479642.20974.32.camel@jlt3.sipsolutions.net> <AANLkTimxp703Gy_Atg8=wpFszRDR=OJCXwOUKRh-a-d7@mail.gmail.com> <AANLkTi=t-P_5c14brJohM8UgxeOknv+3syO=7W=ix6qf@mail.gmail.com> <AANLkTinC46a+nE-XOQuBCmRJwjzgh24uC7ZJ7HtbVHnT@mail.gmail.com> <4CB378CD.1080800@candelatech.com> <AANLkTim42zmDwf744BCrPwa1kT5ph57bNMyvSyOpesVv@mail.gmail.com> <4CB3D598.7050904@candelatech.com> <AANLkTimPEg3ZU8CQUXfdpGdfbmhdE9O=GNY=g9gysTo4@mail.gmail.com> <4CB4AA89.1070009@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4CB4AA89.1070009@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 13, 2010 at 12:05:53AM +0530, Ben Greear wrote:
> On 10/11/2010 11:10 PM, Luis R. Rodriguez wrote:
> > On Mon, Oct 11, 2010 at 8:27 PM, Ben Greear<greearb@candelatech.com>  wrote:
> 
> >> Another thing I was thinking about:  Maybe the queue of skbs and dma
> >> addresses
> >> in ath9k is getting corrupted by multiple VIFs trying to write at once?
> >>   Maybe
> >> some locking is needed in the xmit path?
> >
> > That was my second hunch. My first shot was to use spin_lock_irqsave()
> > over the the uses of the rxbuf list and that seemed to help but I
> > still managed to get a poison eventually. My next item to check for is
> > of the permissibility of creating too much pressure to the point we
> > end up looping over the rxbuf list and race against mac80211 free'ing
> > a buffer. Will test that tomorrow if nothing else comes up creeping my
> > priority queue.
> 
> This code looks weird to me.  One of the paprd branches
> deletes the skb, the other doesn't appear to.  Neither
> null out bf->bf_mpdu, which would appear to leave a dangling
> pointer in at least the dev_kfree_skb_any() branch.

Single skb is (re)used for sending paprd training frames on more
than one chains. This skb needs to be freed only when paprd fails on
any of the chains or it succeeded on all the chains. The failure
case is handled in ath_tx_complete_buf() and success case is in
ath_paprd_calibrate().
> 
> ath_tx_complete frees it's skb in all cases, so another
> bf->bf_mpdu dangling pointer issue.
> 
> Maybe at the least we should null out bf->bf_mpdu when
> skb is consumed?

I dont see any point in NULLing out bf->bf_mpdu. bf is
reclaimed onto a free tx buf pool as soon as it is done
with the skb. bf_mpdu of any of the bf's is never accessed
without any initialization (bf_ampdu = skb).


Vasanth
