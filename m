Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:58825 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755557AbdDMCoa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Apr 2017 22:44:30 -0400
Date: Thu, 13 Apr 2017 08:14:23 +0530
From: Aditya Shankar <aditya.shankar@microchip.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: <arend.vanspriel@broadcom.com>, <linux-wireless@vger.kernel.org>,
        <devel@driverdev.osuosl.org>, <ganesh.krishna@microchip.com>
Subject: Re: [PATCH v3] staging: wilc1000: New cfg packet format in
 handle_set_wfi_drv_handler
Message-ID: <20170413081423.333c25fa@aditya-ubuntu> (sfid-20170413_044434_508170_C8A390B8)
In-Reply-To: <20170411173546.GA29399@kroah.com>
References: <1491928903-2866-1-git-send-email-aditya.shankar@microchip.com>
        <20170411173546.GA29399@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 11 Apr 2017 19:35:46 +0200
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Tue, Apr 11, 2017 at 10:11:43PM +0530, Aditya Shankar wrote:
> > Change the config packet format used in handle_set_wfi_drv_handler()
> > to align the host driver with the new format used in the wilc firmware.  
> 
> So does this break devices with "old" firmware?
> 
> Where is the "new" firmware?  What is enforcing the usage only of new
> firmware?
> 
> thanks,
> 
> greg k-h

Yes, this new change would break devices with firmware older than ver 14.2(released on our vendor tree in March 2016). The older firmware in the linux-firmware repository is close to 2 years old and not being used with the staging driver even before this change  was submitted. Developers picked up the firmware mostly from one of our vendor trees on github.

To resolve this confusion about firmware location, I submitted a patch to linux-firmware to make the latest firmware available through this channel. Below are the details. The driver currently does not enforce usage of new firmware but would fail to properly configure the older firmware.

---

From: Aditya Shankar <aditya.shankar@microchip.com>
To: <linux-firmware@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <ganesh.krishna@microchip.com>, "Aditya Shankar" <aditya.shankar@microchip.com>
Subject: [PATCH] linux-firmware: wilc1000: Update firmware for wilc1000
Date: Wed, 5 Apr 2017 13:57:19 +0530


This commit updates the wilc1000 firmware
to the latest version and replaces the three older
firmware binaries as we no longer need seperate binaries
for all the wlan modes.

---

Thanks,
Aditya
