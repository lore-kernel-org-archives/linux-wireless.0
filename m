Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55394 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab2GIHDd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 03:03:33 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20474.33283.881761.818702@gargle.gargle.HOWL> (sfid-20120709_090337_388912_D9CCBB69)
Date: Mon, 9 Jul 2012 12:32:27 +0530
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	<linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: fix reset work check properly
In-Reply-To: <20474.32213.21743.932687@gargle.gargle.HOWL>
References: <1341815640-6299-1-git-send-email-rmanohar@qca.qualcomm.com>
	<20474.32213.21743.932687@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan wrote:
> > diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
> > index 40775da..567a655 100644
> > --- a/drivers/net/wireless/ath/ath9k/beacon.c
> > +++ b/drivers/net/wireless/ath/ath9k/beacon.c
> > @@ -362,7 +362,7 @@ void ath_beacon_tasklet(unsigned long data)
> >  	int slot;
> >  	u32 bfaddr, bc = 0;
> >  
> > -	if (work_pending(&sc->hw_reset_work)) {
> > +	if (test_bit(SC_OP_HW_RESET, &sc->sc_flags)) {
> 
> This is not needed, since we bail out in ath_isr().
> (And interrupts are re-enabled only at the end of ath9k_tasklet()).

I am wrong - SWBA is handled differently compared to other interrupts.

Sujith
