Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:36854 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751117AbeB0LPN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 06:15:13 -0500
Received: by mail-wm0-f50.google.com with SMTP id 188so22421151wme.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Feb 2018 03:15:12 -0800 (PST)
Subject: Re: Support on vendor id and device id
To: Harsha Rao <harshrao464@gmail.com>, linux-wireless@vger.kernel.org
References: <CAPcv9S3wyPd5jD1PZWtDf-mRicmzRmz00qh5Jbov_N_egBAEZg@mail.gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A953DBE.9070805@broadcom.com> (sfid-20180227_121517_058086_C8B9E990)
Date: Tue, 27 Feb 2018 12:15:10 +0100
MIME-Version: 1.0
In-Reply-To: <CAPcv9S3wyPd5jD1PZWtDf-mRicmzRmz00qh5Jbov_N_egBAEZg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/27/2018 11:16 AM, Harsha Rao wrote:
> Hi folks,
> I am developing a new wifi driver for our sdio based wifi device.
>
> I see that SDIO_VENDOR_ID and SDIO_DEVICE_ID for our device (We had
> bought the SDIO IP from 3rd party)  is already  been used by some
> other vendor and its already into staging .
>
> Please suggest me how can I move forward to submit the driver for staging.

Can you be more specific about the conflicting vendor id and device id?

> Is there a way to reconfigure the values in the SDIO host for
> different value or does Linux allow two drivers with same values to
> survive mutual exclusively

First come first serve. When a device is detected, the driver core looks 
for drivers supporting it based on device table and the first that 
successfully returns from the .probe() callback is bound to the device.

Regards,
Arend
