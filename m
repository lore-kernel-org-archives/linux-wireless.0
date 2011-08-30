Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45434 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab1H3Qxg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 12:53:36 -0400
Date: Tue, 30 Aug 2011 22:24:03 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>, <shafi.wireless@gmail.com>,
	<vthiagar@qca.qualcomm.com>
Subject: Re: [PATCH v9 2/4] ath9k: always call ath_reset from workqueue
 context
Message-ID: <20110830165402.GA9333@vmraj-lnx.users.atheros.com> (sfid-20110830_185340_228819_E345E410)
References: <1314693047-77839-1-git-send-email-nbd@openwrt.org>
 <1314693047-77839-2-git-send-email-nbd@openwrt.org>
 <20110830142008.GA9158@vmraj-lnx.users.atheros.com>
 <4E5D0722.7010606@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4E5D0722.7010606@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 30, 2011 at 05:52:02PM +0200, Felix Fietkau wrote:
> On 2011-08-30 4:20 PM, Rajkumar Manoharan wrote:
> >On Tue, Aug 30, 2011 at 10:30:45AM +0200, Felix Fietkau wrote:
> >> This makes it much easier to add further rework to avoid race conditions
> >> between reset and other work items.
> >> Move other functions to make ath_reset static.
> >>
> >> Signed-off-by: Felix Fietkau<nbd@openwrt.org>
> >> ---
> >> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> >> index 49b93c2..2b2a975 100644
> >> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> >> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> >> @@ -581,8 +581,10 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
> >>
> >>  	rcu_read_unlock();
> >>
> >> -	if (needreset)
> >> -		ath_reset(sc, false);
> >> +	if (needreset) {
> >> +		sc->sc_flags |= SC_OP_HW_RESET;
> >> +		ieee80211_queue_work(sc->hw,&sc->hw_reset_work);
> >> +	}
> >>  }
> >>
> >Still ath_txq_schedule can be scheduled. Return a error code from
> >ath_tx_complete_aggr to abort tx process intead of SC_OP_HW_RESET.
> >That looks much more generic and simple.
> I added this to make sure that there won't be any subsequent
> attempts at processing the tx queue until the reset (e.g. if there
> was a tx status IRQ in the mean time).
>
If so, it would be safer not to re-enable interrupts at the end of ath9k_tasklet
if SC_OP_HW_RESET is set.

--
Rajkumar
