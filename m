Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34606 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbbFPIhE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 04:37:04 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/2] brcmfmac: fix double free of p2pdev interface
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1434401319-16136-2-git-send-email-arend@broadcom.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Message-Id: <20150616083704.2A173140558@smtp.codeaurora.org> (sfid-20150616_103709_665684_414B16A9)
Date: Tue, 16 Jun 2015 08:37:04 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> When freeing the driver ifp pointer it should also be removed from
> the driver interface list, which is what brcmf_remove_interface()
> does. Otherwise, the ifp pointer will be freed twice triggering
> a kernel oops.
> 
> Fixes: f37d69a4babc ("brcmfmac: free ifp for non-netdev interface in p2p module")
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

Thanks, 2 patches applied to wireless-drivers-next.git:

cb700df8c8a6 brcmfmac: fix double free of p2pdev interface
40b503c76481 brcmfmac: make brcmf_p2p_detach() call conditional

Kalle Valo
