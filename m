Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:45499 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab2LGFxR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 00:53:17 -0500
Cc: Felix Fietkau <nbd@openwrt.org>, <linux-wireless@vger.kernel.org>,
	<linville@tuxdriver.com>, <rodrigue@qca.qualcomm.com>
Date: Fri, 7 Dec 2012 11:23:26 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Adrian Chadd <adrian@freebsd.org>
Subject: Re: [PATCH] Revert "ath9k_hw: Update AR9003 high_power tx gain table"
Message-ID: <20121207055322.GA27229@hemis.qca.qualcomm.com> (sfid-20121207_065321_547543_CBD7319E)
References: <1354815611-7220-1-git-send-email-nbd@openwrt.org>
 <CAJ-Vmonvo9tq4ZF8WosnXNQq=ArqoDuKtz5y8UnFoWfYAikMxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAJ-Vmonvo9tq4ZF8WosnXNQq=ArqoDuKtz5y8UnFoWfYAikMxQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 06, 2012 at 11:35:33AM -0800, Adrian Chadd wrote:
> On 6 December 2012 09:40, Felix Fietkau <nbd@openwrt.org> wrote:
> > This reverts commit f74b9d365ddd33a375802b064f96a5d0e99af7c0.
> >
> > Turns out reverting commit a240dc7b3c7463bd60cf0a9b2a90f52f78aae0fd
> > "ath9k_hw: Updated AR9003 tx gain table for 5GHz" was not enough to
> > bring the tx power back to normal levels on devices like the
> > Buffalo WZR-HP-G450H, this one needs to be reverted as well.
> >
> > This revert improves tx power by ~10 db on that device
> 
> Did anyone figure out why this was happening?
> 
> Maybe we should look at the HAL commits around the same time to see if
> someone changed the programming - eg, assuming TPC is always on, or
> the 2 stream / 3 stream reduction PHY register, or such.
> 
Generally we update initval taken from Systems team. We might have missed to
program the some registers while updating initvals. I prefer to fix the missing
portion rather than reverting ini tables. Otherwise we end up with using
older initvals and hard to debug hw related issues.

-Rajkumar
