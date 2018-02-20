Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:41686 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751669AbeBTOg3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Feb 2018 09:36:29 -0500
Received: by mail-ua0-f195.google.com with SMTP id u99so7189498uau.8
        for <linux-wireless@vger.kernel.org>; Tue, 20 Feb 2018 06:36:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <31f0157f-4778-2f9c-977f-8bdbba6f52a4@redhat.com>
References: <20180220134618.12972-1-carlo@caione.org> <31f0157f-4778-2f9c-977f-8bdbba6f52a4@redhat.com>
From: Carlo Caione <carlo@endlessm.com>
Date: Tue, 20 Feb 2018 14:36:27 +0000
Message-ID: <CAL9uMOEFm4apUrDxs6GkZqV2S=mepd2Ytcna+SCaLnCcwtcfeg@mail.gmail.com> (sfid-20180220_153633_109741_99795939)
Subject: Re: [RFC PATCH 0/2] net: rfkill: gpio: Fix and support SerDev
To: Hans de Goede <hdegoede@redhat.com>
Cc: Carlo Caione <carlo@caione.org>, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, frederic.danis.oss@gmail.com,
        sebastian.reichel@collabora.co.uk,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux Upstreaming Team <linux@endlessm.com>,
        Jeremy Cline <jcline@redhat.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 20, 2018 at 2:01 PM, Hans de Goede <hdegoede@redhat.com> wrote:
> Hi Carlo,

Hi Hans,

> Is this for devices with a RTL8723BS chip? If so then they
> still will not work after this since there also no longer is
> a /dev/ttyS4 created for the UART for the bluetooth, instead
> you probably want:
>
> https://github.com/jwrdegoede/linux-sunxi/commit/c383dac5ea00738ac01d704d820aa548494fcd41
>
> Which also puts the /dev/ttyS4 back in place.

Yeah, this problem came up while working on the RTL8723BS chip but the
driver is also broken for the other two GPS devices supported by this
driver.
Thank you for the patch BTW.

> Regards,
>
> Hans
>
> p.s.
>
> My college Jeremy Cline in the Cc is looking into getting proper
> bluetooth support in place for the rtl8723bs using serdev binding
> and having everything in the kernel, as we now already do for bcm
> uart bluetooth modules.

Wasn't also Martin (+CC) working on this? See
https://www.spinics.net/lists/linux-bluetooth/msg73594.html

Cheers,

-- 
Carlo Caione  |  +44.7384.69.16.04  |  Endless
