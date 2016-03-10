Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44505 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbcCJM6X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2016 07:58:23 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: brcmfmac: Remove waitqueue_active check
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1457508326-24420-1-git-send-email-hui.wang@canonical.com>
To: Hui Wang <hui.wang@canonical.com>
Cc: brudley@broadcom.com, arend@broadcom.com, frankyl@broadcom.com,
	meuleman@broadcom.com, pieterpg@broadcom.com,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	hui.wang@canonical.com
Message-Id: <20160310125822.6F63E60DB3@smtp.codeaurora.org> (sfid-20160310_135827_174994_8E59C3F3)
Date: Thu, 10 Mar 2016 12:58:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> We met a problem of pm_suspend  when repeated closing/opening the lid
> on a Lenovo laptop (1/20 reproduce rate), below is the log:
> 
> [ 199.735876] PM: Entering mem sleep
> [ 199.750516] e1000e: EEE TX LPI TIMER: 00000011
> [ 199.856638] Trying to free nonexistent resource <000000000000d000-000000000000d0ff>
> [ 201.753566] brcmfmac: brcmf_pcie_suspend: Timeout on response for entering D3 substate
> [ 201.753581] pci_legacy_suspend(): brcmf_pcie_suspend+0x0/0x1f0 [brcmfmac] returns -5
> [ 201.753585] dpm_run_callback(): pci_pm_suspend+0x0/0x160 returns -5
> [ 201.753589] PM: Device 0000:04:00.0 failed to suspend async: error -5
> 
> Through debugging, we found when problem happens, it is not the device
> fails to enter D3, but the signal D3_ACK comes too early to pass the
> waitqueue_active() check.
> 
> Just like this:
> brcmf_pcie_send_mb_data(devinfo, BRCMF_H2D_HOST_D3_INFORM);
> // signal is triggered here
> wait_event_timeout(devinfo->mbdata_resp_wait, devinfo->mbdata_completed,
> 		   BRCMF_PCIE_MBDATA_TIMEOUT);
> 
> So far I think it is safe to remove waitqueue_active check since there
> is only one place to trigger this signal (sending
> BRCMF_H2D_HOST_D3_INFORM). And it is not a problem calling wake_up
> event earlier than calling wait_event.
> 
> Cc: Brett Rudley <brudley@broadcom.com>
> Cc: Hante Meuleman <meuleman@broadcom.com>
> Cc: Franky (Zhenhui) Lin <frankyl@broadcom.com>
> Cc: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Cc: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Hui Wang <hui.wang@canonical.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
