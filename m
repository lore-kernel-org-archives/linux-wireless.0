Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:40932 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755375Ab1DXQCa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Apr 2011 12:02:30 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 24 Apr 2011 09:02:03 -0700
Date: Sun, 24 Apr 2011 21:32:26 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Sam Leffler <sleffler@google.com>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath9k_hw: Fix Tx IQ Calibration hang issue in AR9003
 chips
Message-ID: <20110424160226.GA3062@vmraj-lnx.users.atheros.com> (sfid-20110424_180241_345412_421469F0)
References: <1303464039-11574-1-git-send-email-rmanoharan@atheros.com>
 <BANLkTimGAg4nYcW=SW_T-1b06nZbyBvNJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <BANLkTimGAg4nYcW=SW_T-1b06nZbyBvNJA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 22, 2011 at 10:30:59PM +0530, Sam Leffler wrote:
> On Fri, Apr 22, 2011 at 2:20 AM, Rajkumar Manoharan
> <rmanoharan@atheros.com> wrote:
> > On AR9003 chips, doing three IQ calibrations will possibly cause chip
> > in stuck state. In noisy environment, chip could receive
> > a packet during the middle of three calibrations and it causes
> > the conflict of HW access and the eventual failure. It also
> > causes IQ calibration outliers which results in poor Tx EVM.
> > During the issue kernel log was filled with following message
> >
> > ath: timeout (100000 us) on reg 0xa640: 0x00000001 & 0x00000001 != 0x00000000
> > ath: timeout (100000 us) on reg 0xa2c4: 0x00158dd9 & 0x00000001 != 0x00000000
> > ath: Unable to reset channel (2412 MHz), reset status -5
> > ath: Unable to set channel
> >
> > Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
> 
> Please indicate the specific parts where this issue has been seen.  Is
> this specific to 9485 or has it been observed on 93xx devices too?
>
The IQ Cal procedure is after resetting the chip, run IQ cal 3 times 
per each cal cycle and find the two closest readings and average of two.
The advantage of running Tx IQ cal more than once is that we can compare
calibration results for the same gain setting over multiple iterations.
Most of the cases the IQ failures were observed after first pass.

For the AR9485 and later chips, Tx IQ Calibration is performed along
with AGC cal. But for pre-AR9485 chips, Tx IQ cal HW has to be separated
from the rest of calibration HW to avoid chip hang. After all calibrations
are done in HW, we can start SW post-processing. By doing this way, we
minimize the SW difference among all chips. 

The order of calibration (run IQ cal before other calibration) is also
needed to avoid chip hang for chips before AR9485. This issue was originally
observed with AR9382. Will send v2 patch with updated commit log.

Rajkumar
