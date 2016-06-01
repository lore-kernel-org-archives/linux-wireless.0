Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33424 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbcFAEXc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2016 00:23:32 -0400
MIME-Version: 1.0
In-Reply-To: <1464358702-19083-9-git-send-email-javier@osg.samsung.com>
References: <1464358702-19083-1-git-send-email-javier@osg.samsung.com> <1464358702-19083-9-git-send-email-javier@osg.samsung.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 1 Jun 2016 14:23:11 +1000
Message-ID: <CAGRGNgV+7wzboLKLupfwF+1KT=MGEuarHLQFQrZBy3YVk6ghMQ@mail.gmail.com> (sfid-20160601_062402_757228_586F4785)
Subject: Re: [PATCH 8/8] mwifiex: use better message and error code when OF
 node doesn't match
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
> The Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt DT
> binding document lists the possible compatible strings that a SDIO child
> node can have, so the driver checks if the defined in the node matches.
>
> But the error message when that's not the case is misleading, so change
> for one that makes clear what the error really is. Also, returning a -1
> as errno code is not correct since that's -EPERM. A -EINVAL seems to be
> a more appropriate one.
>
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

This looks sensible to me.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

>
> ---
>
>  drivers/net/wireless/marvell/mwifiex/sdio.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
