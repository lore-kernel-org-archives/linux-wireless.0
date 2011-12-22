Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38822 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750914Ab1LVHoa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Dec 2011 02:44:30 -0500
Received: by lahd3 with SMTP id d3so809540lah.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 23:44:29 -0800 (PST)
Message-ID: <4EF2DFDB.3070501@gmail.com> (sfid-20111222_084445_627618_F8E75395)
Date: Thu, 22 Dec 2011 08:44:27 +0100
From: Pontus Fuchs <pontus.fuchs@gmail.com>
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: ido@wizery.com, coelho@ti.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wl12xx: Fix power control for CONFIG_RUNTIME_PM off configurations
References: <1324467662-10065-1-git-send-email-pontus.fuchs@gmail.com> <CAK=WgbacGjAzXPSWd1sF0RwyJ3tbMYTrZM0v2sO-pd5heSawVQ@mail.gmail.com>
In-Reply-To: <CAK=WgbacGjAzXPSWd1sF0RwyJ3tbMYTrZM0v2sO-pd5heSawVQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 2011-12-22 07:39, Ohad Ben-Cohen wrote:
>> -       /* Tell PM core that we don't need the card to be powered now */
>> -       pm_runtime_put_noidle(&func->dev);
>> +       /* Power off as we don't need the card to be powered now */
>> +       wl12xx_sdio_power_off(func);
>
> This in particular looks wrong.
>
> You bypass runtime PM by manipulating the power state of the card
> directly, and as a result you leave the runtime PM state out of sync
> with the real power state of the device.

Even without my changes we will call wl12xx_sdio_power_on/off for every 
ifconfig up/down. Is that also a problem or is that case different?

//Pontus
