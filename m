Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:50439 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752004AbXHEGnL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2007 02:43:11 -0400
Message-ID: <46B5717A.6090302@warmcat.com>
Date: Sun, 05 Aug 2007 07:43:06 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] bcm43xx-mac80211: Rescale link quality output
References: <46b56ce8.MTc7K0Zquczk+/6h%Larry.Finger@lwfinger.net>
In-Reply-To: <46b56ce8.MTc7K0Zquczk+/6h%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:
> BCM43xx_RX_MAX_SSI (60)

> +	status.signal = jssi * 100 / BCM43xx_RX_MAX_SSI;

That can't be doing what you intended... (int)100/60 == 1, it just
multiplies jssi by 1.  Maybe some brackets around the multiply?

-Andy
