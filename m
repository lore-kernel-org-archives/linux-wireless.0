Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:58733 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbaIIT1u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2014 15:27:50 -0400
Received: by mail-oa0-f54.google.com with SMTP id g18so12415460oah.27
        for <linux-wireless@vger.kernel.org>; Tue, 09 Sep 2014 12:27:49 -0700 (PDT)
Message-ID: <540F54B1.8040409@lwfinger.net> (sfid-20140909_212754_885821_0E60B1FC)
Date: Tue, 09 Sep 2014 14:27:45 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Bastien Nocera <hadess@hadess.net>, linux-wireless@vger.kernel.org
Subject: Re: Realtek GPIO chipset, for Baytrail?
References: <1410256608.4077.7.camel@hadess.net>
In-Reply-To: <1410256608.4077.7.camel@hadess.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/09/2014 04:56 AM, Bastien Nocera wrote:
> Hey,
>
> I have a tablet that seems to be using Realtek chips to do wireless
> communications (hopefully, this time I won't be wrong[1]).
>
> The device, under the gpio class in /sys, shows with a modalias of
> "acpi:OBDA8723:" (that's on "O", not "0"). This seems to correspond to a
> Realtek chipset (Larry tells me it matches the PCI ID of 0bda:8723 for
> the RTL8723AE chipset).
>
> It shows up under:
> /sys/devices/platform/80860F0A:00/subsystem/devices
>
> Does anyone have details on how this chipset is actually hooked up? Can
> a portion of the existing RTL8723AE driver code be reused?

Bastien,

 From the previous response, it seems unlikely that GPIO is used to control the 
device. That is what I expected. Working at that primitive level would be 
extremely difficult timing.

I assume that you have checked both 'lspci' and 'lsusb' for any mention of the 
wireless device. I am not aware of a similar utility to scan an SDIO bus, but 
perhaps someone on this list will know. In addition, a full listing of 'lspci 
-nnv' will give a clue regarding what adapters are on the device.

If the device were used with SDIO, then it would be known as the RTL8723AS. I 
could not find that chip, but there is an RTL8723BS with a 32-bit driver for 
Windows 8.1.

What specific Baytrail tablet do you have?

Larry

