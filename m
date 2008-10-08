Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54877 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbYJHSeF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2008 14:34:05 -0400
Received: from sapphire.tuxdriver.com ([70.61.120.61] helo=localhost)
	by smtp.tuxdriver.com with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1KndrH-0005jA-2q
	for linux-wireless@vger.kernel.org; Wed, 08 Oct 2008 14:34:03 -0400
Date: Wed, 8 Oct 2008 14:33:23 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8180: normalize quality measurment for 100-point
	scale
Message-ID: <20081008183323.GA32472@tuxdriver.com> (sfid-20081008_203410_538619_67208622)
References: <1223407914-23971-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1223407914-23971-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 07, 2008 at 03:31:54PM -0400, John W. Linville wrote:
> Otherwise, we get values like "133/100" for quality output from
> iwconfig. :-(
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> This is currently untested, but it seems reasonable to me...any takers?  :-)

This doesn't seem quite right either...only now all the numbers I
get are ultra-low, nothing bigger than 7 so far.  Also I'm not sure,
but it seemed like the quality value was moving inversely to how it
should be moving...

I noticed that the rtl8187 guys did some work on the quality value
for rtl8187b -- maybe I should persuade them to look at this one as
well... :-)

John

>  drivers/net/wireless/rtl8180_dev.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/rtl8180_dev.c b/drivers/net/wireless/rtl8180_dev.c
> index b7172a1..e9edcaa 100644
> --- a/drivers/net/wireless/rtl8180_dev.c
> +++ b/drivers/net/wireless/rtl8180_dev.c
> @@ -132,7 +132,7 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
>  
>  			rx_status.antenna = (flags2 >> 15) & 1;
>  			/* TODO: improve signal/rssi reporting */
> -			rx_status.qual = flags2 & 0xFF;
> +			rx_status.qual = ((flags2 & 0xFF) * 100) / 256;
>  			rx_status.signal = (flags2 >> 8) & 0x7F;
>  			/* XXX: is this correct? */
>  			rx_status.rate_idx = (flags >> 20) & 0xF;
> -- 
> 1.5.4.3
> 
> 

-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
