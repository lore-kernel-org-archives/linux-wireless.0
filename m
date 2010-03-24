Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:45120 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab0CXWNu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 18:13:50 -0400
Received: by mail-ew0-f216.google.com with SMTP id 8so127383ewy.28
        for <linux-wireless@vger.kernel.org>; Wed, 24 Mar 2010 15:13:49 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 2/2] rt2x00: Disable powersaving by default in rt2500usb.
Date: Wed, 24 Mar 2010 23:13:47 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <1269463357-32563-1-git-send-email-gwingerde@gmail.com> <1269463357-32563-3-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1269463357-32563-3-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <201003242313.47959.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 24 March 2010, Gertjan van Wingerde wrote:
> Recent bug reports have shown that rt2500usb also suffers from the
> powersave problems that the PCI rt2x00 drivers suffer from.
> So disable powersaving by default for rt2500usb as well.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2500usb.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
> index ee34c13..dbaa781 100644
> --- a/drivers/net/wireless/rt2x00/rt2500usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2500usb.c
> @@ -1643,6 +1643,11 @@ static int rt2500usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  	unsigned int i;
>  
>  	/*
> +	 * Disable powersaving as default.
> +	 */
> +	rt2x00dev->hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
> +
> +	/*
>  	 * Initialize all hw fields.
>  	 */
>  	rt2x00dev->hw->flags =


