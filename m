Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35317 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762Ab1INDst (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 23:48:49 -0400
Date: Wed, 14 Sep 2011 09:19:24 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <stable@kernel.org>
Subject: Re: [PATCH] ath9k_hw: Fix magnitude/phase coeff correction
Message-ID: <20110914034922.GA23349@vmraj-lnx.users.atheros.com> (sfid-20110914_054854_917720_D0FDD38E)
References: <1315320530-2733-1-git-send-email-rmanohar@qca.qualcomm.com>
 <20110913173226.GF11772@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20110913173226.GF11772@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 13, 2011 at 01:32:26PM -0400, John W. Linville wrote:
> On Tue, Sep 06, 2011 at 08:18:50PM +0530, Rajkumar Manoharan wrote:
> > Do the magnitude/phase coeff correction only if the outlier
> > is detected.
> > 
> > Cc: stable@kernel.org
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> > ---
> >  
> >  static void ar9003_hw_tx_iqcal_load_avg_2_passes(struct ath_hw *ah,
> 
> What is the effect of the bug being fixed here?  Is this fix intended for 3.1?
>
The first entry of phase/mag got changed to average if outlier is not detected.
This patch ensures to update appropriate index of magnitude/phase. This patch is
applicable from 3.0 onwards.

--
Rajkumar
