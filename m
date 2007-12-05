Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:46752 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbXLEKT2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2007 05:19:28 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] wireless: make drivers include the TSF RX flag where appropriate
Date: Wed, 5 Dec 2007 11:17:42 +0100
Cc: John Linville <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1196796820.12472.1.camel@johannes.berg>
In-Reply-To: <1196796820.12472.1.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200712051117.43276.mb@bu3sch.de> (sfid-20071205_101932_824680_52CB91EB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 04 December 2007 20:33:40 Johannes Berg wrote:
> These drivers pass full mactime information to the stack, make them
> indicate this via the new RX_FLAG_TSFT to get mac80211 to show this
> information in monitor mode.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> iwlwifi does own radiotap headers (well, tries, it's broken) so is not
> modified.
> 
>  drivers/net/wireless/b43/xmit.c       |    1 +
>  drivers/net/wireless/b43legacy/xmit.c |    1 +
>  drivers/net/wireless/p54common.c      |    1 +
>  drivers/net/wireless/rtl8180_dev.c    |    1 +
>  drivers/net/wireless/rtl8187_dev.c    |    1 +
>  5 files changed, 5 insertions(+)

> --- everything.orig/drivers/net/wireless/b43/xmit.c	2007-12-04 20:32:32.096962565 +0100
> +++ everything/drivers/net/wireless/b43/xmit.c	2007-12-04 20:33:11.046949707 +0100
> @@ -541,6 +541,7 @@ void b43_rx(struct b43_wldev *dev, struc
>  		status.mactime += mactime;
>  		if (low_mactime_now <= mactime)
>  			status.mactime -= 0x10000;
> +		status.flag |= RX_FLAG_TSFT;
>  	}
>  
>  	chanid = (chanstat & B43_RX_CHAN_ID) >> B43_RX_CHAN_ID_SHIFT;

Acked-by: Michael Buesch <mb@bu3sch.de>


-- 
Greetings Michael.
