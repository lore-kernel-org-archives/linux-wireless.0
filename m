Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:25913 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647Ab0JNFhk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 01:37:40 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 13 Oct 2010 22:37:30 -0700
Date: Thu, 14 Oct 2010 11:07:17 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Ben Greear <greearb@candelatech.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
Message-ID: <20101014053717.GB21903@vasanth-laptop>
References: <AANLkTimxp703Gy_Atg8=wpFszRDR=OJCXwOUKRh-a-d7@mail.gmail.com> <AANLkTi=t-P_5c14brJohM8UgxeOknv+3syO=7W=ix6qf@mail.gmail.com> <AANLkTinC46a+nE-XOQuBCmRJwjzgh24uC7ZJ7HtbVHnT@mail.gmail.com> <4CB378CD.1080800@candelatech.com> <AANLkTim42zmDwf744BCrPwa1kT5ph57bNMyvSyOpesVv@mail.gmail.com> <4CB3D598.7050904@candelatech.com> <AANLkTimPEg3ZU8CQUXfdpGdfbmhdE9O=GNY=g9gysTo4@mail.gmail.com> <4CB4AA89.1070009@candelatech.com> <20101013053141.GA15798@vasanth-laptop> <4CB5E0A8.5020502@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4CB5E0A8.5020502@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >
> > I dont see any point in NULLing out bf->bf_mpdu. bf is
> > reclaimed onto a free tx buf pool as soon as it is done
> > with the skb. bf_mpdu of any of the bf's is never accessed
> > without any initialization (bf_ampdu = skb).
> 
> The code can use skb after its deleted currently, because
> ath_debug_stat_tx(sc, txq, bf, ts); references the bf_ampdu
> object (I think I added that reference lately..so it's really
> a bug that I caused).  At the least, we should move the ath_debug_stat_tx
> logic before the ath_tx_complete() call.

Yes, this is a serious issue irrespective of initializing bf_mpdu to
NULL.

> 
> As for the paprd path, it looks racy to me:  What if the paprd timer
> expires while the ath_tx_complete_buf logic is running?

That is the goal here, if we timed out on paprd training
, ath_tx_complete_buf() has to free the skb. At least I dont
see any race here, can you elaborate on your finding?, remember
ath_tx_complete_buf() is in tasklet context.

Vasanth
