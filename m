Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:54553 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbaJTIsO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 04:48:14 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21572.50341.631533.278980@gargle.gargle.HOWL> (sfid-20141020_104816_854047_47A81562)
Date: Mon, 20 Oct 2014 13:45:33 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 03/10] ath9k: fix processing RXORN interrupts
In-Reply-To: <1413651732-69783-3-git-send-email-nbd@openwrt.org>
References: <1413651732-69783-1-git-send-email-nbd@openwrt.org>
	<1413651732-69783-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> The "goto chip_reset" is a bit misleading, because it does not actually
> issue a chip reset. Instead it is bypassing processing of other
> interrupts and assumes that the tasklet will issue a chip reset.

Well, we kill interrupts and the tasklet sets ATH_OP_HW_RESET,
so no more interrupts will be processed in ath_isr(), so this
is a fair assumption.

> In the case of RXORN this does not happen, so bypassing processing of
> other interrupts will simply allow them to fire again. Even if RXORN
> was triggering a reset, it is not critical enough to need the bypass
> here.

Wouldn't this be fixed by just processing RXORN in the tasklet,
along with FATAL ? Or are you saying that RXORN doesn't need a
chip reset in both edma/legacy, since the edma check has been dropped ?

Sujith
