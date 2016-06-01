Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34219 "EHLO
	mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750697AbcFAEOp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2016 00:14:45 -0400
MIME-Version: 1.0
In-Reply-To: <1464358702-19083-2-git-send-email-javier@osg.samsung.com>
References: <1464358702-19083-1-git-send-email-javier@osg.samsung.com> <1464358702-19083-2-git-send-email-javier@osg.samsung.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 1 Jun 2016 14:14:25 +1000
Message-ID: <CAGRGNgWHGR_KJW1SExte-YSG1ynxy-GrtKjO-GRKEadUx4HpWA@mail.gmail.com> (sfid-20160601_061518_244845_3E250019)
Subject: Re: [PATCH 1/8] mwifiex: only call mwifiex_sdio_probe_of() if dev has
 an OF node
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

On Sat, May 28, 2016 at 12:18 AM, Javier Martinez Canillas
<javier@osg.samsung.com> wrote:
> SDIO is an auto enumerable bus so the SDIO devices are matched using the
> sdio_device_id table and not using compatible strings from a OF id table.
>
> However, commit ce4f6f0c353b ("mwifiex: add platform specific wakeup
> interrupt support") allowed to match nodes defined as child of the SDIO
> host controller in the probe function using a compatible string to setup
> platform specific parameters in the DT.
>
> The problem is that the OF parse function is always called regardless if
> the SDIO dev has an OF node associated or not, and prints an error if it
> is not found. So, on a platform that doesn't have a node for a SDIO dev,
> the following misleading error message will be printed:
>
> [  12.480042] mwifiex_sdio mmc2:0001:1: sdio platform data not available
>
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

This looks sensible to me.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

>  drivers/net/wireless/marvell/mwifiex/sdio.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
