Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:27768 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752065Ab0JFCAC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 22:00:02 -0400
Received: from vs3000.wh2.ocn.ne.jp (125.206.180.163)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-011184400
	for <linux-wireless@vger.kernel.org>; Wed,  6 Oct 2010 11:00:00 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>, vasanth@atheros.com
Subject: Re: [PATCH 3/5] ath9k: Use common cycle counters
Date: Wed, 6 Oct 2010 11:00:01 +0900
Cc: linville@tuxdriver.com, nbd@openwrt.org,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
References: <20101005095510.3083.46174.stgit@tt-desk> <20101005095521.3083.87663.stgit@tt-desk> <AANLkTin5r7ig7-h9DRjwGrei9R5-CL6gW7kcBNKWP2Rs@mail.gmail.com>
In-Reply-To: <AANLkTin5r7ig7-h9DRjwGrei9R5-CL6gW7kcBNKWP2Rs@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201010061100.01949.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed October 6 2010 10:18:07 Luis R. Rodriguez wrote:
> On Tue, Oct 5, 2010 at 2:55 AM, Bruno Randolf <br1@einfach.org> wrote:
> > Update ath9k to use the common cycle counters.
> > 
> > This also includes other changes from Felix Fietkaus "[PATCH 2/4]
> > ath9k_hw: merge codepaths that access the cycle counter registers".
> > 
> > Compile tested only. ath9k team please review...
> > 
> > Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> > Signed-off-by: Bruno Randolf <br1@einfach.org>
> > ---
> >  drivers/net/wireless/ath/ath9k/ani.c        |   87
> > +++------------------------ drivers/net/wireless/ath/ath9k/ani.h      
> >  |    6 --
> >  drivers/net/wireless/ath/ath9k/ar5008_phy.c |    9 +--
> >  drivers/net/wireless/ath/ath9k/ar9003_phy.c |   18 +++---
> >  4 files changed, 22 insertions(+), 98 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/ath/ath9k/ani.c
> > b/drivers/net/wireless/ath/ath9k/ani.c index 0496f96..0c0d01d 100644
> > --- a/drivers/net/wireless/ath/ath9k/ani.c
> > +++ b/drivers/net/wireless/ath/ath9k/ani.c
> > @@ -549,47 +549,21 @@ static u8 ath9k_hw_chan_2_clockrate_mhz(struct
> > ath_hw *ah)
> > 
> >  static int32_t ath9k_hw_ani_get_listen_time(struct ath_hw *ah)
> >  {
> > -       struct ar5416AniState *aniState;
> >        struct ath_common *common = ath9k_hw_common(ah);
> > -       u32 txFrameCount, rxFrameCount, cycleCount;
> > -       int32_t listenTime;
> > +       int32_t listen_time;
> > +       int32_t clock_rate;
> > 
> > -       txFrameCount = REG_READ(ah, AR_TFCNT);
> > -       rxFrameCount = REG_READ(ah, AR_RFCNT);
> > -       cycleCount = REG_READ(ah, AR_CCCNT);
> > +       ath_hw_cycle_counters_lock(common);
> 
> Note the lock call here. This is what I'd like to see avoided. Can you
> perhaps have the lock called within the core driver instead, that is,
> add the lock call for the caller of ath9k_hw_ani_get_listen_time(). In
> this case I see ath9k_hw_ani_get_listen_time() is static though and so
> is its caller but ultimately we get to ath9k_hw_ani_monitor(). What
> I'm saying is how about calling the
> ath_hw_cycle_counters_lock(common); right before
> ath9k_hw_ani_monitor().

that would hold the lock for an unnecessarily long amount of time.
i'm not working with ath9k, so can i leave it to you to deal with this in 
subsequent patches? in the mean time, if you prefer, i can omit the lock.

bruno
