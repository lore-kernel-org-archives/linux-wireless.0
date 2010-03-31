Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:45523 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755213Ab0CaWaM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Mar 2010 18:30:12 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Nx6QK-0005HZ-RQ
	for linux-wireless@vger.kernel.org; Thu, 01 Apr 2010 00:30:08 +0200
Received: from 94-192-45-120.zone6.bethere.co.uk ([94.192.45.120])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 01 Apr 2010 00:30:08 +0200
Received: from linux by 94-192-45-120.zone6.bethere.co.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 01 Apr 2010 00:30:08 +0200
To: linux-wireless@vger.kernel.org
From: Adam Baker <linux@baker-net.org.uk>
Subject: Re: [PATCH 2/4] rt2x00: Enable powersaving by default again on rt2500usb.
Date: Wed, 31 Mar 2010 22:29:58 +0000 (UTC)
Message-ID: <loom.20100401T002825-964@post.gmane.org>
References: <1269985826-17438-1-git-send-email-gwingerde@gmail.com> <1269985826-17438-3-git-send-email-gwingerde@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gertjan van Wingerde <gwingerde@...> writes:

> 
> Now that the powersave issues on rt2500usb have been tackled, powersave
> can be enabled by default again.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@...>
> ---
>  drivers/net/wireless/rt2x00/rt2500usb.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c
b/drivers/net/wireless/rt2x00/rt2500usb.c
> index 54d2716..c1eec17 100644
> --- a/drivers/net/wireless/rt2x00/rt2500usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2500usb.c
> @@ -1647,11 +1647,6 @@ static int rt2500usb_probe_hw_mode(struct rt2x00_dev
*rt2x00dev)
>  	unsigned int i;
> 
>  	/*
> -	 * Disable powersaving as default.
> -	 */
> -	rt2x00dev->hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
> 
This looks like it deletes one line too few leaving a nested open comment
block in the code.

Adam



