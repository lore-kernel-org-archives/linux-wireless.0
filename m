Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43742 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750770AbdCHPIl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Mar 2017 10:08:41 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] rtl8187: Enable monitor mode to fix multicast reception
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170219235919.GA15763@tisys.org>
References: <20170219235919.GA15763@tisys.org>
To: Nils Holland <nholland@tisys.org>
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Message-Id: <20170308150803.DA679607A4@smtp.codeaurora.org> (sfid-20170308_160926_538182_24896B44)
Date: Wed,  8 Mar 2017 15:08:03 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nils Holland <nholland@tisys.org> wrote:
> The rtl8187 cards don't seem to receive multicast frames, which,
> among other things, makes them fail to receive RAs in IPv6 networks.
> The cause seems to be that the RTL818X_RX_CONF_MULTICAST flag doesn't
> have the desired effect.
> 
> Fix the issue by setting RTL818X_RX_CONF_MONITOR instead, which puts the
> card into monitor mode and resolves the problem so that multicast frames
> are sucessfully passed to the kernel.
> 
> The existence of the problem and the effectiveness of the solution has
> originally been confirmed on an 8187B based card with the USB id of
> 0bda:8197. Subsequent testing by Larry Finger on an 8187L based card,
> which follows the second (8187, i.e. "non-b") code path in the driver,
> has confirmed that the fix does not cause any noticeable regresssions
> there either.
> 
> Signed-off-by: Nils Holland <nholland@tisys.org>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Patch applied to wireless-drivers-next.git, thanks.

3beb27028c44 rtl8187: Enable monitor mode to fix multicast reception

-- 
https://patchwork.kernel.org/patch/9581905/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
