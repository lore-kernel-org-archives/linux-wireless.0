Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56158 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757186Ab1INRA3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 13:00:29 -0400
Date: Wed, 14 Sep 2011 12:54:47 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, kvalo@adurom.com
Subject: Re: [PATCH] ath9k_hw: Fix magnitude/phase coeff correction
Message-ID: <20110914165446.GB2485@tuxdriver.com> (sfid-20110914_190046_168852_EC1BC43E)
References: <1315320530-2733-1-git-send-email-rmanohar@qca.qualcomm.com>
 <20110913173226.GF11772@tuxdriver.com>
 <20110914034922.GA23349@vmraj-lnx.users.atheros.com>
 <87ehzjjyvz.fsf@purkki.adurom.net>
 <20110914090320.GA3074@vmraj-lnx.users.atheros.com>
 <20110914165426.GA13088@vmraj-lnx.users.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110914165426.GA13088@vmraj-lnx.users.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 14, 2011 at 10:24:27PM +0530, Rajkumar Manoharan wrote:
> On Wed, Sep 14, 2011 at 02:33:22PM +0530, Rajkumar Manoharan wrote:
> > On Wed, Sep 14, 2011 at 11:45:20AM +0300, Kalle Valo wrote:
> > > Rajkumar Manoharan <rmanohar@qca.qualcomm.com> writes:
> > > 
> > > > On Tue, Sep 13, 2011 at 01:32:26PM -0400, John W. Linville wrote:
> > > >> On Tue, Sep 06, 2011 at 08:18:50PM +0530, Rajkumar Manoharan wrote:
> > > >> > Do the magnitude/phase coeff correction only if the outlier
> > > >> > is detected.
> > > >> > 
> > > >> > Cc: stable@kernel.org
> > > >> > Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> > > >> > ---
> > > >> >  
> > > >> >  static void ar9003_hw_tx_iqcal_load_avg_2_passes(struct ath_hw *ah,
> > > >> 
> > > >> What is the effect of the bug being fixed here?  Is this fix intended for 3.1?
> > > >
> > > > The first entry of phase/mag got changed to average if outlier is
> > > > not detected. This patch ensures to update appropriate index of
> > > > magnitude/phase. This patch is applicable from 3.0 onwards.
> > > 
> > > Sorry, but this doesn't tell much. What's the user visible change
> > > with this patch? Better sensitivity, less transmission errors or what?
> > >
> > It has minor impact because of this bug, an undesirable Tx IQ correction value
> > will be assigned to Tx gain settings wheen outlier is not happened. The impacts
> > on overall system throughput should be very minor.
> >
> John,
> 
> Not doing the calibrations in proper manner could impact performance in congested
> network. Maybe i should update the impact in the commit log. Wanna send me v2
> patch?

Please.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
