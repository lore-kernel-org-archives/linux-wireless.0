Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59232 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbbCVFxI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2015 01:53:08 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: rtlwifi: Fix IOMMU mapping leak in AP mode
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1426968965-30161-1-git-send-email-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Kevin Mullican <kevin@mullican.com>,
	Shao Fu <shaofu@realtek.com>, Stable <stable@vger.kernel.org>
Message-Id: <20150322055307.B511F140187@smtp.codeaurora.org> (sfid-20150322_065323_253241_DB5E2C4B)
Date: Sun, 22 Mar 2015 05:53:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Transmission of an AP beacon does not call the TX interrupt service routine,
> which usually does the cleanup. Instead, cleanup is handled in a tasklet
> completion routine. Unfortunately, this routine has a serious bug in that it does
> not release the DMA mapping before it frees the skb, thus one IOMMU mapping is
> leaked for each beacon. The test system failed with no free IOMMU mapping slots
> approximately one hour after hostapd was used to start an AP.
> 
> This issue was reported and tested at https://github.com/lwfinger/rtlwifi_new/issues/30.
> 
> Reported-and-tested-by: Kevin Mullican <kevin@mullican.com>
> Cc: Kevin Mullican <kevin@mullican.com>
> Signed-off-by: Shao Fu <shaofu@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org>  [3.18+]

Thanks, applied to wireless-drivers.git.

Kalle Valo
