Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32099 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab2JOJmD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 05:42:03 -0400
Date: Mon, 15 Oct 2012 15:01:39 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Sujith Manoharan <c_manoha@qti.qualcomm.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 05/12] ath9k_hw: Disable MCI stat counter by default for
 AR9565
Message-ID: <20121015093137.GA21551@hemis.qca.qualcomm.com> (sfid-20121015_114208_511268_EDAA1637)
References: <1350287738-18687-1-git-send-email-rmanohar@qca.qualcomm.com>
 <1350287738-18687-6-git-send-email-rmanohar@qca.qualcomm.com>
 <20603.54602.430150.78107@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20603.54602.430150.78107@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 15, 2012 at 02:50:10PM +0530, Sujith Manoharan wrote:
> Rajkumar Manoharan wrote:
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> > ---
> >  drivers/net/wireless/ath/ath9k/ar9003_mci.c | 11 ++++++++++-
> >  drivers/net/wireless/ath/ath9k/reg.h        |  3 +++
> >  2 files changed, 13 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
> > index c46d8f1..466ac8da 100644
> > --- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
> > +++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
> > @@ -938,6 +938,9 @@ int ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
> >  	mci->ready = true;
> >  	ar9003_mci_prep_interface(ah);
> >  
> > +	if (AR_SREV_9565(ah))
> > +		REG_RMW_FIELD(ah, AR_MCI_DBG_CNT_CTRL,
> > +			      AR_MCI_DBG_CNT_CTRL_ENABLE, 0);
> >  	if (en_int)
> >  		ar9003_mci_enable_interrupt(ah);
> >  
> > @@ -1179,13 +1182,19 @@ int ar9003_mci_setup(struct ath_hw *ah, u32 gpm_addr, void *gpm_buf,
> >  		     u16 len, u32 sched_addr)
> >  {
> >  	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
> > +	int ret;
> >  
> >  	mci->gpm_addr = gpm_addr;
> >  	mci->gpm_buf = gpm_buf;
> >  	mci->gpm_len = len;
> >  	mci->sched_addr = sched_addr;
> >  
> > -	return ar9003_mci_reset(ah, true, true, true);
> > +	ret = ar9003_mci_reset(ah, true, true, true);
> > +
> > +	if (AR_SREV_9565(ah))
> > +		REG_RMW_FIELD(ah, AR_MCI_DBG_CNT_CTRL,
> > +			      AR_MCI_DBG_CNT_CTRL_ENABLE, 0);
> > +	return ret;
> 
> Why do this is two different places, when reset() is actually called from
> setup() ?
>
Oops. Thanks

-Rajkumar
