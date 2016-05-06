Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49755 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758208AbcEFLyA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2016 07:54:00 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Christian Daudt <csd@broadcom.com>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Franky Lin <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [PATCH] Fix kernel oops in failed chip_attach
References: <1462390228-27863-1-git-send-email-csd@broadcom.com>
Date: Fri, 06 May 2016 14:53:54 +0300
In-Reply-To: <1462390228-27863-1-git-send-email-csd@broadcom.com> (Christian
	Daudt's message of "Wed, 4 May 2016 12:30:28 -0700")
Message-ID: <87lh3ns8q5.fsf@kamboji.qca.qualcomm.com> (sfid-20160506_135405_408840_B7350FAC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Daudt <csd@broadcom.com> writes:

> When chip attach fails, brcmf_sdiod_intr_unregister is being called
> but that is too early as sdiodev->settings has not been set yet
> nor has brcmf_sdiod_intr_register been called.
> Change to use oob_irq_requested + newly created sd_irq_requested
> to decide on what to unregister at intr_unregister time.
>
> Steps to reproduce problem:
> - modprobe brcmfmac using buggy FW
> - rmmod brcmfmac
> - modprobe brcmfmac again.
>
> If done with a buggy firmware, brcm_chip_attach will fail on the
> 2nd modprobe triggering the call to intr_unregister and the
> kernel oops when attempting to de-reference sdiodev->settings->bus.sdio
> which has not yet been set.
>
> Signed-off-by: Christian Daudt <csd@broadcom.com>

Please use prefix "brcmfmac: " in the title.

-- 
Kalle Valo
