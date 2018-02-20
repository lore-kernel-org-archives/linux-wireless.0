Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coyote.holtmann.net ([212.227.132.17]:34302 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750799AbeBTOEq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Feb 2018 09:04:46 -0500
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Subject: Re: [RFC PATCH 2/2] net: rfkill: gpio: Convert driver to SerDev
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20180220134618.12972-3-carlo@caione.org>
Date: Tue, 20 Feb 2018 15:04:42 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        =?utf-8?Q?Fr=C3=A9d=C3=A9ric_Danis?= <frederic.danis.oss@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        rafael.j.wysocki@intel.com, Hans de Goede <hdegoede@redhat.com>,
        linux@endlessm.com, Carlo Caione <carlo@endlessm.com>
Message-Id: <44721384-4057-445D-841B-CA9A21E6A6E1@holtmann.org> (sfid-20180220_150449_406763_33076F5F)
References: <20180220134618.12972-1-carlo@caione.org>
 <20180220134618.12972-3-carlo@caione.org>
To: Carlo Caione <carlo@caione.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Carlo,

> With commit e361d1f85855 ("ACPI / scan: Fix enumeration for special UART
> devices") UART devices are now expected to be enumerated by
> SerDev subsystem. This is breaking the enumeration of platform devices
> connected to the UART without a proper SerDev support, like in the
> rfkill-gpio case.
> 
> Fix this moving the driver from a platform driver to a serdev device
> driver.

I do not like keeping this a RFKILL switch for the two GPS devices and that is really all what is left for this driver.

static const struct acpi_device_id rfkill_acpi_match[] = {
        { "BCM4752", RFKILL_TYPE_GPS },
        { "LNV4752", RFKILL_TYPE_GPS },
        { },
};

Frankly what this needs is a serdev GPS driver. Even if it also exposes the data path via character device or a new TTY. Trying to hook this into RFKILL for powering on the GPS chip is not what we should do anymore. What you really want is that if the GPS daemon or application open the node for the GPS device that it gets powered on and when closed powered back down. Fiddling with RFKILL to do that is not what a RFKILL switch is for. If you want to have an additional RFKILL switch for killing power, then this has to be done the same as WiFi and Bluetooth do it.

So this patch is just a bad hack and we better have a proper serdev GPS driver.

Regards

Marcel
