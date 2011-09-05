Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14005 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab1IEIQd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Sep 2011 04:16:33 -0400
Date: Mon, 5 Sep 2011 13:47:02 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Paul Stewart <pstew@google.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath9k_hw: Fix Tx IQ Calibration hang issue in AR9003
 chips
Message-ID: <20110905081701.GA9084@vmraj-lnx.users.atheros.com> (sfid-20110905_101638_263801_9D4A6B48)
References: <1303464039-11574-1-git-send-email-rmanoharan@atheros.com>
 <CAMcMvsgrjRFC9pwr_tJLuSfF8N68GUAATmcnkkKgDUx+ufYvuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <CAMcMvsgrjRFC9pwr_tJLuSfF8N68GUAATmcnkkKgDUx+ufYvuQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 31, 2011 at 03:16:22PM -0700, Paul Stewart wrote:
> On Fri, Apr 22, 2011 at 2:20 AM, Rajkumar Manoharan
> <rmanoharan@atheros.com> wrote:
> > On AR9003 chips, doing three IQ calibrations will possibly cause chip
> > in stuck state. In noisy environment, chip could receive
> > a packet during the middle of three calibrations and it causes
> > the conflict of HW access and the eventual failure. It also
> > causes IQ calibration outliers which results in poor Tx EVM.
> [...]
> > -       if (diff[0] <= diff[1] && diff[0] <= diff[2])
> > -               *mp_avg = (mp_coeff[0] + mp_coeff[1]) / 2;
> > -       else if (diff[1] <= diff[2])
> > -               *mp_avg = (mp_coeff[1] + mp_coeff[2]) / 2;
> > -       else
> > -               *mp_avg = (mp_coeff[2] + mp_coeff[0]) / 2;
> > +       /* find average (exclude max abs value) */
> > +       for (i = 0; i < nmeasurement; i++) {
> > +               if ((abs(mp_coeff[i]) < abs(mp_max)) ||
> > +                   (abs(mp_coeff[i]) < abs(mp_min)))
> Doesn't this potentially throw away more than one potential sample
> from your mp_avg sum if more than one value has the same (maximal
> absolute) value?  You don't account for it below since you divide by
> (nmeasurement - 1) so your average can get arbitrarily smaller than
> you intended, which may false-trigger your outlier detection.
Sorry for the delayed response. And yes it is a bug although it
has minor impact. Based on our Systems team folk's input this bug
itself does not affect the outlier detection because detection
relies on ABS(max-min). It does affect post-processing after outlier
is detected.

It has minor impact because of following facts:
1) Outlier happens very rarely according to the past experiment.
   Its frequency should be much less than once every 1000 calibrations.
2) Because of this bug, an undesirable Tx IQ correction value will be assigned
   to Tx gain settings where outlier happens. The impacts on overall
   system throughput should be minor.

Thanks for your valuable input. Will send the followup patch after
the verification.

--
Rajkumar
