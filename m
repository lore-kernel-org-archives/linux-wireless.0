Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:57289 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752980AbaJTJBj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 05:01:39 -0400
Message-ID: <5444CF6C.8050208@openwrt.org> (sfid-20141020_110142_768187_5839FFA7)
Date: Mon, 20 Oct 2014 11:01:32 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 03/10] ath9k: fix processing RXORN interrupts
References: <1413651732-69783-1-git-send-email-nbd@openwrt.org>	<1413651732-69783-3-git-send-email-nbd@openwrt.org> <21572.50341.631533.278980@gargle.gargle.HOWL>
In-Reply-To: <21572.50341.631533.278980@gargle.gargle.HOWL>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-10-20 10:15, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> The "goto chip_reset" is a bit misleading, because it does not actually
>> issue a chip reset. Instead it is bypassing processing of other
>> interrupts and assumes that the tasklet will issue a chip reset.
> 
> Well, we kill interrupts and the tasklet sets ATH_OP_HW_RESET,
> so no more interrupts will be processed in ath_isr(), so this
> is a fair assumption.
Except it only does that for FATAL, not RXORN.

>> In the case of RXORN this does not happen, so bypassing processing of
>> other interrupts will simply allow them to fire again. Even if RXORN
>> was triggering a reset, it is not critical enough to need the bypass
>> here.
> 
> Wouldn't this be fixed by just processing RXORN in the tasklet,
> along with FATAL ? Or are you saying that RXORN doesn't need a
> chip reset in both edma/legacy, since the edma check has been dropped ?
I'm not sure if we should actually do the chip reset for RXORN, but even
if we should, we don't need this 'goto chip_reset' in ath_isr.

- Felix
