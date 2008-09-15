Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352AbYIOO1O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 10:27:14 -0400
Subject: Re: Problem with Libertas USB8388 WLAN card firmware
From: Dan Williams <dcbw@redhat.com>
To: Anadi Mishra <reachanadi@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <e001a6370809150258t10873497jcf04e68005db566b@mail.gmail.com>
References: <e001a6370809150258t10873497jcf04e68005db566b@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 15 Sep 2008 10:27:51 -0400
Message-Id: <1221488871.10177.44.camel@localhost.localdomain> (sfid-20080915_162718_182514_C41120C7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-09-15 at 15:28 +0530, Anadi Mishra wrote:
> Hi all,
>         I am using Libertas USB8388 WLAN card with Ubuntu 8.04 but am
> not able to get it working.
> 
>         The error(dmesg) says "unable to load firmware" even if the
> usb8388.bin file is there in the /lib/firmware.
> 
>         dmesg also says "probe of 3-1:1.1 failed with error -12"
> 
> Any help would be gr8.

What exact kernel version are you using?

Also, please remove and re-insert insert the libertas.ko module like so:

/sbin/modprobe libertas libertas_debug=0x1a43a7

then plug the adapter in and post the output from 'dmesg' in a reply to
this message.  We need a bit more information to find out what might be
going wrong.

Also, where did you get the firmware from?  It might be the wrong
firmware file format.  There are two formats, the first being the
driver-loadable format, the second is meant for flashing directly to the
EEPROM if the dongle has any.  The second format is not used by the
driver because it does not have any verification method like blocks or
embedded CRCs.

Dan


