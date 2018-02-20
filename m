Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coyote.holtmann.net ([212.227.132.17]:56315 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752115AbeBTPzq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Feb 2018 10:55:46 -0500
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Subject: Re: [RFC PATCH 0/2] net: rfkill: gpio: Fix and support SerDev
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CAL9uMOEFm4apUrDxs6GkZqV2S=mepd2Ytcna+SCaLnCcwtcfeg@mail.gmail.com>
Date: Tue, 20 Feb 2018 16:55:43 +0100
Cc: Hans de Goede <hdegoede@redhat.com>,
        Carlo Caione <carlo@caione.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        =?utf-8?Q?Fr=C3=A9d=C3=A9ric_Danis?= <frederic.danis.oss@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux Upstreaming Team <linux@endlessm.com>,
        Jeremy Cline <jcline@redhat.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Message-Id: <854DB788-E5A4-49DB-BC85-105F37B2AFB4@holtmann.org> (sfid-20180220_165552_424778_869BF032)
References: <20180220134618.12972-1-carlo@caione.org>
 <31f0157f-4778-2f9c-977f-8bdbba6f52a4@redhat.com>
 <CAL9uMOEFm4apUrDxs6GkZqV2S=mepd2Ytcna+SCaLnCcwtcfeg@mail.gmail.com>
To: Carlo Caione <carlo@endlessm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Carlo,

>> Is this for devices with a RTL8723BS chip? If so then they
>> still will not work after this since there also no longer is
>> a /dev/ttyS4 created for the UART for the bluetooth, instead
>> you probably want:
>> 
>> https://github.com/jwrdegoede/linux-sunxi/commit/c383dac5ea00738ac01d704d820aa548494fcd41
>> 
>> Which also puts the /dev/ttyS4 back in place.
> 
> Yeah, this problem came up while working on the RTL8723BS chip but the
> driver is also broken for the other two GPS devices supported by this
> driver.
> Thank you for the patch BTW.
> 
>> Regards,
>> 
>> Hans
>> 
>> p.s.
>> 
>> My college Jeremy Cline in the Cc is looking into getting proper
>> bluetooth support in place for the rtl8723bs using serdev binding
>> and having everything in the kernel, as we now already do for bcm
>> uart bluetooth modules.
> 
> Wasn't also Martin (+CC) working on this? See
> https://www.spinics.net/lists/linux-bluetooth/msg73594.html

I remember that. I think we need a non-RFC version against latest bluetooth-next tree.

Regards

Marcel
