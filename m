Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:39354 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751270AbeBTOBT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Feb 2018 09:01:19 -0500
Received: by mail-wr0-f193.google.com with SMTP id w77so14666982wrc.6
        for <linux-wireless@vger.kernel.org>; Tue, 20 Feb 2018 06:01:18 -0800 (PST)
Subject: Re: [RFC PATCH 0/2] net: rfkill: gpio: Fix and support SerDev
To: Carlo Caione <carlo@caione.org>, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, frederic.danis.oss@gmail.com,
        sebastian.reichel@collabora.co.uk, rafael.j.wysocki@intel.com,
        linux@endlessm.com
Cc: Carlo Caione <carlo@endlessm.com>, Jeremy Cline <jcline@redhat.com>
References: <20180220134618.12972-1-carlo@caione.org>
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <31f0157f-4778-2f9c-977f-8bdbba6f52a4@redhat.com> (sfid-20180220_150123_451284_6AFDBCE1)
Date: Tue, 20 Feb 2018 15:01:15 +0100
MIME-Version: 1.0
In-Reply-To: <20180220134618.12972-1-carlo@caione.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Carlo,

Is this for devices with a RTL8723BS chip? If so then they
still will not work after this since there also no longer is
a /dev/ttyS4 created for the UART for the bluetooth, instead
you probably want:

https://github.com/jwrdegoede/linux-sunxi/commit/c383dac5ea00738ac01d704d820aa548494fcd41

Which also puts the /dev/ttyS4 back in place.

Regards,

Hans

p.s.

My college Jeremy Cline in the Cc is looking into getting proper
bluetooth support in place for the rtl8723bs using serdev binding
and having everything in the kernel, as we now already do for bcm
uart bluetooth modules.

On 20-02-18 14:46, Carlo Caione wrote:
> From: Carlo Caione <carlo@endlessm.com>
> 
> Hi,
> this patch came after investigating why the rfkill-gpio driver was failing on
> the latest kernel on a machine I have. Sending this out as RFC because I'm
> still not sure if this is the right way to approach this problem. I was
> honestly expecting not to see the platform devices failing as consequences of
> the latest work on SerDev.
> 
> Carlo Caione (2):
>    net: rfkill: gpio: Fix NULL pointer deference
>    net: rfkill: gpio: Convert driver to SerDev
> 
>   net/rfkill/Kconfig       |  1 +
>   net/rfkill/rfkill-gpio.c | 48 +++++++++++++++++++++++++-----------------------
>   2 files changed, 26 insertions(+), 23 deletions(-)
> 
