Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:33859 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750829AbeBTOk5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Feb 2018 09:40:57 -0500
Received: by mail-vk0-f65.google.com with SMTP id z190so5726961vkg.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 Feb 2018 06:40:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <44721384-4057-445D-841B-CA9A21E6A6E1@holtmann.org>
References: <20180220134618.12972-1-carlo@caione.org> <20180220134618.12972-3-carlo@caione.org>
 <44721384-4057-445D-841B-CA9A21E6A6E1@holtmann.org>
From: Carlo Caione <carlo@endlessm.com>
Date: Tue, 20 Feb 2018 14:40:55 +0000
Message-ID: <CAL9uMOFw7TgT00NWcQ9=jW8kGhG-Gbi_+5j-jJYgd6wH4HQeEQ@mail.gmail.com> (sfid-20180220_154100_813787_2352D758)
Subject: Re: [RFC PATCH 2/2] net: rfkill: gpio: Convert driver to SerDev
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Carlo Caione <carlo@caione.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        =?UTF-8?B?RnLDqWTDqXJpYyBEYW5pcw==?= <frederic.danis.oss@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 20, 2018 at 2:04 PM, Marcel Holtmann <marcel@holtmann.org> wrot=
e:
> Hi Carlo,

Hi Marcel,

>> With commit e361d1f85855 ("ACPI / scan: Fix enumeration for special UART
>> devices") UART devices are now expected to be enumerated by
>> SerDev subsystem. This is breaking the enumeration of platform devices
>> connected to the UART without a proper SerDev support, like in the
>> rfkill-gpio case.
>>
>> Fix this moving the driver from a platform driver to a serdev device
>> driver.
>
> I do not like keeping this a RFKILL switch for the two GPS devices and th=
at is really all what is left for this driver.
>
> static const struct acpi_device_id rfkill_acpi_match[] =3D {
>         { "BCM4752", RFKILL_TYPE_GPS },
>         { "LNV4752", RFKILL_TYPE_GPS },
>         { },
> };
>
> Frankly what this needs is a serdev GPS driver. Even if it also exposes t=
he data path via character device or a new TTY. Trying to hook this into RF=
KILL for powering on the GPS chip is not what we should do anymore. What yo=
u really want is that if the GPS daemon or application open the node for th=
e GPS device that it gets powered on and when closed powered back down. Fid=
dling with RFKILL to do that is not what a RFKILL switch is for. If you wan=
t to have an additional RFKILL switch for killing power, then this has to b=
e done the same as WiFi and Bluetooth do it.
>
> So this patch is just a bad hack and we better have a proper serdev GPS d=
river.

Yeah, I know (that's also why I preferred to send this as RFC).
At least this patch could be useful to have things working until we
have something better in place, but I definitely agree that's a bad
hack.

Cheers,

--=20
Carlo Caione  |  +44.7384.69.16.04  |  Endless
