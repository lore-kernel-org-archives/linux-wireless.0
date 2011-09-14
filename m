Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37323 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab1INJCq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 05:02:46 -0400
Date: Wed, 14 Sep 2011 14:33:22 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Kalle Valo <kvalo@adurom.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <stable@kernel.org>
Subject: Re: [PATCH] ath9k_hw: Fix magnitude/phase coeff correction
Message-ID: <20110914090320.GA3074@vmraj-lnx.users.atheros.com> (sfid-20110914_110250_647214_503C861C)
References: <1315320530-2733-1-git-send-email-rmanohar@qca.qualcomm.com>
 <20110913173226.GF11772@tuxdriver.com>
 <20110914034922.GA23349@vmraj-lnx.users.atheros.com>
 <87ehzjjyvz.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <87ehzjjyvz.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 14, 2011 at 11:45:20AM +0300, Kalle Valo wrote:
> Rajkumar Manoharan <rmanohar@qca.qualcomm.com> writes:
> 
> > On Tue, Sep 13, 2011 at 01:32:26PM -0400, John W. Linville wrote:
> >> On Tue, Sep 06, 2011 at 08:18:50PM +0530, Rajkumar Manoharan wrote:
> >> > Do the magnitude/phase coeff correction only if the outlier
> >> > is detected.
> >> > 
> >> > Cc: stable@kernel.org
> >> > Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> >> > ---
> >> >  
> >> >  static void ar9003_hw_tx_iqcal_load_avg_2_passes(struct ath_hw *ah,
> >> 
> >> What is the effect of the bug being fixed here?  Is this fix intended for 3.1?
> >
> > The first entry of phase/mag got changed to average if outlier is
> > not detected. This patch ensures to update appropriate index of
> > magnitude/phase. This patch is applicable from 3.0 onwards.
> 
> Sorry, but this doesn't tell much. What's the user visible change
> with this patch? Better sensitivity, less transmission errors or what?
>
It has minor impact because of this bug, an undesirable Tx IQ correction value
will be assigned to Tx gain settings wheen outlier is not happened. The impacts
on overall system throughput should be very minor.

--
Rajkumar
