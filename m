Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:55514 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751058Ab1HJTjq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 15:39:46 -0400
Received: by mail-bw0-f47.google.com with SMTP id zu17so574578bkb.20
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 12:39:44 -0700 (PDT)
Subject: Re: [PATCH 22/40] wl12xx: use dynamic hlids for AP-mode
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1312881233-9366-23-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
	 <1312881233-9366-23-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 22:39:41 +0300
Message-ID: <1313005181.2407.717.camel@cumari> (sfid-20110810_213949_611621_FF35A0E2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 12:13 +0300, Eliad Peller wrote: 
> @@ -300,23 +300,18 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
>  		   basic rates */
>  		if (control->control.sta)
>  			rate_idx = ACX_TX_AP_FULL_RATE;
>  		else
>  			rate_idx = ACX_TX_BASIC_RATE;
>  	} else {
> -		switch (hlid) {
> -		case WL1271_AP_GLOBAL_HLID:
> +		if (hlid == wl->ap_global_hlid)
>  			rate_idx = ACX_TX_AP_MODE_MGMT_RATE;
> -			break;
> -		case WL1271_AP_BROADCAST_HLID:
> +		else if (hlid ==  wl->ap_bcast_hlid)

Extra whitespace after ==.


-- 
Cheers,
Luca.

