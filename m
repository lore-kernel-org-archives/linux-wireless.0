Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39846 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbcFDO71 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2016 10:59:27 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2,1/2] brcmfmac: Fix kernel oops in failed chip_attach
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1463004409-28885-2-git-send-email-csd@broadcom.com>
To: Christian Daudt <csd@broadcom.com>
Cc: linux-wireless@vger.kernel.org, Christian Daudt <csd@broadcom.com>,
	brcm80211-dev-list@broadcom.com,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Franky Lin <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>
Message-Id: <20160604145926.A6D20613E2@smtp.codeaurora.org> (sfid-20160604_165930_300284_FFAE1646)
Date: Sat,  4 Jun 2016 14:59:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Daudt <csd@broadcom.com> wrote:
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

Thanks, 2 patches applied to wireless-drivers-next.git:

b88a2e80396b brcmfmac: Fix kernel oops in failed chip_attach
b746740147dc brcmfmac: Fix 'did not remove int handler' warning

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9075231/

