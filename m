Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35464 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751459AbdATJq4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 04:46:56 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,1/3] mwifiex: pcie: use posted write to wake up firmware
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170113233538.36196-1-briannorris@chromium.org>
References: <20170113233538.36196-1-briannorris@chromium.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Cathy Luo <cluo@marvell.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Brian Norris <briannorris@chromium.org>
Message-Id: <20170120094655.BB7AE607CD@smtp.codeaurora.org> (sfid-20170120_104724_123419_666D730D)
Date: Fri, 20 Jan 2017 09:46:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> wrote:
> Depending on system factors (e.g., the PCIe link PM state), the first
> read to wake up the Wifi firmware can take a long time. There is no
> reason to use a (blocking, non-posted) read at this point, so let's just
> use a write instead. Write vs. read doesn't matter functionality-wise --
> it's just a dummy operation. But let's make sure to re-write with the
> correct "ready" signature, since we check for that in other parts of the
> driver.
> 
> This has been shown to decrease the time spent blocking in this function
> on RK3399.
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>

3 patches applied to wireless-drivers-next.git, thanks.

062e008a6e83 mwifiex: pcie: use posted write to wake up firmware
5d5ddb5e0d9b mwifiex: pcie: don't loop/retry interrupt status checks
fe1167883939 mwifiex: pcie: read FROMDEVICE DMA-able memory with READ_ONCE()

-- 
https://patchwork.kernel.org/patch/9516615/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
