Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coyote.holtmann.net ([212.227.132.17]:34097 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750866AbeBTOKQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Feb 2018 09:10:16 -0500
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Subject: Re: [RFC PATCH 0/2] net: rfkill: gpio: Fix and support SerDev
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <31f0157f-4778-2f9c-977f-8bdbba6f52a4@redhat.com>
Date: Tue, 20 Feb 2018 15:10:13 +0100
Cc: Carlo Caione <carlo@caione.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, frederic.danis.oss@gmail.com,
        sebastian.reichel@collabora.co.uk, rafael.j.wysocki@intel.com,
        linux@endlessm.com, Carlo Caione <carlo@endlessm.com>,
        Jeremy Cline <jcline@redhat.com>
Message-Id: <660C7ECE-213D-4547-BF47-239669EB707D@holtmann.org> (sfid-20180220_151019_781509_3526F275)
References: <20180220134618.12972-1-carlo@caione.org>
 <31f0157f-4778-2f9c-977f-8bdbba6f52a4@redhat.com>
To: Hans de Goede <hdegoede@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Hans,

> Is this for devices with a RTL8723BS chip? If so then they
> still will not work after this since there also no longer is
> a /dev/ttyS4 created for the UART for the bluetooth, instead
> you probably want:
> 

it is not for that hardware, it is for some GPS devices.

static const struct acpi_device_id rfkill_acpi_match[] = {
        { "BCM4752", RFKILL_TYPE_GPS },
        { "LNV4752", RFKILL_TYPE_GPS },
        { },
};

> https://github.com/jwrdegoede/linux-sunxi/commit/c383dac5ea00738ac01d704d820aa548494fcd41
> 
> Which also puts the /dev/ttyS4 back in place.
> 
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

Actually this should be done quickly since the Realtek hciattach / btattach hacks are not even upstream either since that is unmergable code. Even a basic hci_rtl.c driver would be better than nothing.

Regards

Marcel
