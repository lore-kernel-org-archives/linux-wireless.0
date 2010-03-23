Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f179.google.com ([209.85.221.179]:38658 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab0CWOZw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Mar 2010 10:25:52 -0400
Received: by qyk9 with SMTP id 9so821654qyk.1
        for <linux-wireless@vger.kernel.org>; Tue, 23 Mar 2010 07:25:51 -0700 (PDT)
Message-ID: <4BA8CF6C.2050701@lwfinger.net>
Date: Tue, 23 Mar 2010 09:25:48 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de,
	Calvin Walton <calvin.walton@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] ssb: Implement virtual SPROM on disk
References: <4ba6aa45.z5Wso1NMth9eMeFG%Larry.Finger@lwfinger.net> <201003222325.35994.mb@bu3sch.de> <4BA80118.1070801@lwfinger.net> <201003230952.56207.mb@bu3sch.de>
In-Reply-To: <201003230952.56207.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/23/2010 03:52 AM, Michael Buesch wrote:
> On Tuesday 23 March 2010 00:45:28 Larry Finger wrote:
>> (2) In drivers/ssb/pci.c, the firmware loading process reads the file, then
>> modifies it using the bus address.
> 
> No. You don't need firmware loading at all.
> udev can just set the mac address through the standard ioctl calls.
> Just like how ifconfig and ip can do.

Will someone please write me udev rule(s) that do the following:

1. Detect a MAC address of FF:FF:FF:FF:FF:FF
2. If this is the first time for this bus address, then generate a random MAC
address with the bus address encoded in it.
3. Preserve the address for future reloads
4. Load the saved address into the device.
5. Do the above with only standard external commands - no new programs

My skills with udev are not up to the task.

I now have code running that uses the firmware load facility to read a
file created by /bin/dbus-uuidgen to create a MAC address that will satisfy the
requirements. If the file is needed but not available, then the user is prompted
with the commands needed to create it.

Larry
