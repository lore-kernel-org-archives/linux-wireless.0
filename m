Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f10.google.com ([209.85.219.10]:41980 "EHLO
	mail-ew0-f10.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbZAYLhx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2009 06:37:53 -0500
Received: by ewy3 with SMTP id 3so425844ewy.13
        for <linux-wireless@vger.kernel.org>; Sun, 25 Jan 2009 03:37:51 -0800 (PST)
Message-ID: <497C4F0C.3060908@tuffmail.co.uk> (sfid-20090125_123811_959925_8904D108)
Date: Sun, 25 Jan 2009 11:37:48 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Tobias Doerffel <tobias.doerffel@gmail.com>
CC: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] ath5k: initial RFKILL support for Atheros 5xxx
 cards
References: <1232812567-11014-1-git-send-email-tobias.doerffel@gmail.com>
In-Reply-To: <1232812567-11014-1-git-send-email-tobias.doerffel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tobias Doerffel wrote:
> Hi,
>
> as announced here's a reworked patch for RFKILL support. It now features
> actually reading RFKILL state from according GPIO. Furthermore it's not
> a polled input device anymore (and thus does not depend on polled input device
> support in kernel anymore) and handles interrupts instead. Everything for this
> is in place, however it probably still needs some tweaking by someone else as
> I don't have a physical rfkill switch with my netbook.
>
> The same applies for GPIO configuration (pin/polarity) which is read from
> EEPROM. It at least works for me reliably but might not work on other machines.
>
> The LED patches are not included anymore as the radio LED seems to be controlled
> automatically when changing RFKILL state in hardware.
>
> One note on behaviour: rfkill is enabled (i.e. radio disabled) in 3 cases
> - interface is not up
> - "0" is written to /sys/class/rfkill/rfkillX/state
> - physical rf-switch switched off 
>
> As mentioned above, I can't guarantee the third case to actually work.
>
> When rfkill is enabled my netbook consumes about 0.8 watts less compared to
> being up, associated and idle.
>   

How can I check if the ath5k device on my netbook will be able to
support this?  I worry that if this works on my netbook, it is going to
interact badly with the eeepc-laptop platform driver, which also has
rfkill support. 


eeepc-laptop uses a somewhat unique mechanism.  It's a sort of
platform-specific pci hotplug.  Here is my concern:

- When an rfkill device is created, the rfkill core forces it into the
default state (for that type of rfkill switch, e.g. WLAN).

- eeepc-laptop calls rfkill_set_default() on startup.  This effectively
allows the global rfkill state to be preserved while the system is
turned off, and restored on startup.

Consider the case where the system starts up with rkfill enabled (i.e.
radio disabled).  The ath5k PCI device will not exist.  The default
rfkill state will be set to "radio disabled".

As a user of rfkill-input, I press the wireless toggle hotkey.  The
global rfkill state changes to disabled (radio enabled).  All *existing*
rfkill devices are switched to disabled (radio enabled).  The only
rfkill device is eeepc-laptop; so this is disabled, and the PCI device
appears...

When ath5k binds to the PCI device and creates it's rfkill device, it
will inherit the *default* rfkill state, which was set on startup - to
enabled (radio disabled).

Thanks
Alan
