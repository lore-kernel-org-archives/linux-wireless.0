Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:41255 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757797Ab0LMNr0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 08:47:26 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 05:47:10 -0800
Date: Mon, 13 Dec 2010 19:16:38 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Felix Fietkau <nbd@nbd.name>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH v3 1/8] ath9k_hw: only use the PCIe disable register
 write sequence for AR5416
Message-ID: <20101213134638.GA4622@vmraj-lnx.users.atheros.com>
References: <1292111474-70939-1-git-send-email-nbd@openwrt.org>
 <20101213111207.GA3121@vmraj-lnx.users.atheros.com>
 <31A8EB58-AACD-4660-9C7D-6A077152E7C7@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <31A8EB58-AACD-4660-9C7D-6A077152E7C7@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 13, 2010 at 07:07:53PM +0530, Felix Fietkau wrote:
> On 13.12.2010, at 12:12, Rajkumar Manoharan <rmanoharan@atheros.com> wrote:
> 
> > On Sun, Dec 12, 2010 at 05:21:07AM +0530, Felix Fietkau wrote:
> >> Newer chips do not need this, and maybe these register writes could have
> >> negative side effects on newer hardware.
> >> 
> >> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> >> ---
> >> drivers/net/wireless/ath/ath9k/hw.c |    6 +-----
> >> 1 files changed, 1 insertions(+), 5 deletions(-)
> >> 
> >> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
> >> index 516227f..7bc6d22 100644
> >> --- a/drivers/net/wireless/ath/ath9k/hw.c
> >> +++ b/drivers/net/wireless/ath/ath9k/hw.c
> >> @@ -284,11 +284,9 @@ static void ath9k_hw_read_revisions(struct ath_hw *ah)
> >> 
> >> static void ath9k_hw_disablepcie(struct ath_hw *ah)
> >> {
> >> -    if (AR_SREV_9100(ah))
> >> +    if (!AR_SREV_5416(ah))
> >>        return;
> >> 
> >> -    ENABLE_REGWRITE_BUFFER(ah);
> > 
> > Why to disable multiple register write?
> Because it is only relevant for USB based devices.
>
True. This part is also applicable for HTC device like UB91.

--
Rajkumar
