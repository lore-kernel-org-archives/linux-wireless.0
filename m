Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:32606 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962Ab0JUHFR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Oct 2010 03:05:17 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 21 Oct 2010 00:05:07 -0700
Date: Thu, 21 Oct 2010 12:35:15 +0530
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis Rodriguez" <Luis.Rodriguez@Atheros.com>,
	"stable@kernel.org" <stable@kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Kyungwan Nam <Kyungwan.Nam@Atheros.com>
Subject: Re: [PATCH 3/6] ath9k: rename rxflushlock to pcu_lock
Message-ID: <20101021070515.GD6948@senthil-lnx.users.atheros.com>
References: <1287616028-12547-1-git-send-email-lrodriguez@atheros.com>
 <1287616028-12547-4-git-send-email-lrodriguez@atheros.com>
 <20101021060335.GB6948@senthil-lnx.users.atheros.com>
 <AANLkTinSX63J6YwtT6h-5UicGZP4NJSXvfHSdWoVUuJ9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <AANLkTinSX63J6YwtT6h-5UicGZP4NJSXvfHSdWoVUuJ9@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 21, 2010 at 11:43:50AM +0530, Luis R. Rodriguez wrote:
> On Wed, Oct 20, 2010 at 11:03 PM, Senthil Balasubramanian
> <senthilkumar@atheros.com> wrote:
> > On Thu, Oct 21, 2010 at 04:37:05AM +0530, Luis R. Rodriguez wrote:
> >> The real way to lock RX is to contend on the PCU
> >> and reset, this will be fixed in the next patch but for
> >> now just do the renames so that the next patch which changes
> >> the locking order is crystal clear.
> >>
> >> This is part of a series that will help resolve the bug:
> >>
> >> https://bugzilla.kernel.org/show_bug.cgi?id=14624
> >>
> >> For more details about this issue refer to:
> >>
> >> http://marc.info/?l=linux-wireless&m=128629803703756&w=2
> >>
> >> Cc: stable@kernel.org
> >> Cc: Ben Greear <greearb@candelatech.com>
> >> Cc: Kyungwan Nam <kyungwan.nam@atheros.com>
> >> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> >> ---
> >>  drivers/net/wireless/ath/ath9k/ath9k.h |    2 +-
> >>  drivers/net/wireless/ath/ath9k/main.c  |    4 ++--
> >>  drivers/net/wireless/ath/ath9k/recv.c  |    6 +++---
> >>  3 files changed, 6 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
> >> index 0f0bc54..81fed83 100644
> >> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
> >> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
> >> @@ -309,7 +309,7 @@ struct ath_rx {
> >>       u8 rxotherant;
> >>       u32 *rxlink;
> >>       unsigned int rxfilter;
> >> -     spinlock_t rxflushlock;
> >> +     spinlock_t pcu_lock;
> >>       spinlock_t rxbuflock;
> >>       struct list_head rxbuf;
> >>       struct ath_descdma rxdma;
> >> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> >> index dcd94ba..37f18ef 100644
> >> --- a/drivers/net/wireless/ath/ath9k/main.c
> >> +++ b/drivers/net/wireless/ath/ath9k/main.c
> >> @@ -609,7 +609,7 @@ void ath9k_tasklet(unsigned long data)
> >>               rxmask = (ATH9K_INT_RX | ATH9K_INT_RXEOL | ATH9K_INT_RXORN);
> >>
> >>       if (status & rxmask) {
> >> -             spin_lock_bh(&sc->rx.rxflushlock);
> >> +             spin_lock_bh(&sc->rx.pcu_lock);
> > no need to disable bh as you are already in tasklet. I understand that the
> > existing code itself was doing this and I thought of fixing that anyway.
> > Can you plese fix this as well with this patch?
> 
> Nah, I rather this be a separate patch, which you can test and send yourself :)
Since we are sending this to stable, I thought we can send a clean patch.
> 
> >>
> >>               /* Check for high priority Rx first */
> >>               if ((ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) &&
> >> @@ -617,7 +617,7 @@ void ath9k_tasklet(unsigned long data)
> >>                       ath_rx_tasklet(sc, 0, true);
> >>
> >>               ath_rx_tasklet(sc, 0, false);
> >> -             spin_unlock_bh(&sc->rx.rxflushlock);
> >> +             spin_unlock_bh(&sc->rx.pcu_lock);
> > here also. spin_lock() is sufficient.
> 
> Ditto.
> 
>  Luis
