Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46283 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab2AYMmy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jan 2012 07:42:54 -0500
Received: by ghrr11 with SMTP id r11so1328937ghr.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jan 2012 04:42:53 -0800 (PST)
Message-ID: <4F1FF8C9.4050803@lwfinger.net> (sfid-20120125_134303_840397_4F6E8883)
Date: Wed, 25 Jan 2012 06:42:49 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: zajec5@gmail.com, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org
Subject: Re: b43: N-PHY: implement RSSI calibration for rev3+
References: <20120125081815.GA19911@elgon.mountain>
In-Reply-To: <20120125081815.GA19911@elgon.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/25/2012 02:18 AM, Dan Carpenter wrote:
> Hello Rafał Miłecki,
>
> The patch e0c9a0219a8f: "b43: N-PHY: implement RSSI calibration for
> rev3+" from Jan 5, 2012, leads to the following Smatch warning:
> drivers/net/wireless/b43/phy_n.c +1381 b43_nphy_rev3_rssi_cal()
> 	 error: buffer overflow 'results[j]' 4<= 4
>
>
> +               for (i = 0; i<  4; i++) {
> +                       s32 curr;
> +                       s32 mind = 40;
> +                       s32 minpoll = 249;
> +                       u8 minvcm = 0;
> +                       if (2 * core != i)
> +                               continue;
> +                       for (j = 0; j<  8; j++) {
> +                               curr = results[j][i] * results[j][i] +
> +                                       results[j][i + 1] * results[j][i];
>                                                     ^^^^^
> On the last iteration through the loop "i + 1" = 4.
>
> +                               if (curr<  mind) {
> +                                       mind = curr;
> +                                       minvcm = j;
> +                               }
> +                               if (results[j][i]<  minpoll)
> +                                       minpoll = results[j][i];
> +                       }
> +                       vcm_final = minvcm;
> +                       results_min[i] = minpoll;
> +               }
>
> I don't know the code well enough to say if this can happen or not.
> Perhaps on the last iteration we always hit the "if (2 * core != i)
> continue" condition.  Anyway, since this is the first time this has hit
> linux-next, I thought I would let you know.

The condition you point out will occur for i equals 3. As 2 * anything will 
never be equal to 3, the continue will definitely be executed for that case.

This idea would need further investigation, but it certainly appears the the for 
loop could be changed to "for (i = 0; i < 4; i += 2)", which would accomplish 
the same end and should have the side effect of silencing the Smatch warning.

Larry

