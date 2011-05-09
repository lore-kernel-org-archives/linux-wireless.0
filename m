Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:46825 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911Ab1EIJjR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 05:39:17 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 09 May 2011 02:38:48 -0700
Date: Mon, 9 May 2011 15:09:05 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>
CC: Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [RFC] ath9k: make npending frames check as bool
Message-ID: <20110509093905.GD17465@vasanth-laptop> (sfid-20110509_113919_289712_A2002C37)
References: <1304697291-6850-1-git-send-email-mshajakhan@atheros.com> <20110506161541.GB6002@vasanth-laptop> <4DC76DD9.5010000@atheros.com> <20110509092854.GC17465@vasanth-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20110509092854.GC17465@vasanth-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 09, 2011 at 02:58:54PM +0530, Vasanth Thiagarajan wrote:
> On Mon, May 09, 2011 at 10:00:17AM +0530, Mohammed Shajakhan wrote:
> > On Friday 06 May 2011 09:45 PM, Vasanth Thiagarajan wrote:
> > > On Fri, May 06, 2011 at 09:24:51PM +0530, Mohammed Shafi Shajakhan wrote:
> > >> From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
> > >>
> > >> Signed-off-by: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
> > >> ---
> > >>   drivers/net/wireless/ath/ath9k/main.c |    7 +++++--
> > >>   1 files changed, 5 insertions(+), 2 deletions(-)
> > >>
> > >> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> > >> index 3de115d..2b78ea2 100644
> > >> --- a/drivers/net/wireless/ath/ath9k/main.c
> > >> +++ b/drivers/net/wireless/ath/ath9k/main.c
> > >> @@ -2267,7 +2267,7 @@ static void ath9k_flush(struct ieee80211_hw *hw, bool drop)
> > >>   		timeout = 1;
> > >>
> > >>   	for (j = 0; j<  timeout; j++) {
> > >> -		int npend = 0;
> > >> +		bool npend = false;
> > >>
> > >>   		if (j)
> > >>   			usleep_range(1000, 2000);
> > >> @@ -2276,7 +2276,10 @@ static void ath9k_flush(struct ieee80211_hw *hw, bool drop)
> > >>   			if (!ATH_TXQ_SETUP(sc, i))
> > >>   				continue;
> > >>
> > >> -			npend += ath9k_has_pending_frames(sc,&sc->tx.txq[i]);
> > >> +			npend = ath9k_has_pending_frames(sc,&sc->tx.txq[i]);
> > >> +
> > >> +			if (npend)
> > >> +				break;
> > >
> > > We need not bail out as soon as there is a pending frame in a queue.
> > > There is a possibility that it could be transmitted successfully by
> > > the time the given timeout expires.
> > 
> > Hi Vasanth,
> > 	the timeout is before we enter into the loop for checking pending 
> > frames, so I thought it won't be affecting it. am I missing something? 
> > please tell me.
> 
> I meant the total timeout (200ms). Even though there are frames in
> tx queues after the given timeout for that particular queue, it is
> quite possible that those frames can be completed successfully by
> the time we are done with the waiting on the last queue.

Never mind, I misread your change.

Vasanth
