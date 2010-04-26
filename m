Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33889 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab0DZSPE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 14:15:04 -0400
Received: by pvg2 with SMTP id 2so525652pvg.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Apr 2010 11:15:04 -0700 (PDT)
Message-ID: <4BD5D821.5030208@lwfinger.net>
Date: Mon, 26 Apr 2010 13:14:57 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH V4] ssb: Implement virtual SPROM
References: <4bac487c.j3EXBzCzHYNAd+Ky%Larry.Finger@lwfinger.net> <20100426175850.GD2387@tuxdriver.com>
In-Reply-To: <20100426175850.GD2387@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/26/2010 12:58 PM, John W. Linville wrote:
> On Fri, Mar 26, 2010 at 12:39:08AM -0500, Larry Finger wrote:
>> Some recent BCM43XX devices lack an on-board SPROM. The pertinent data
>> from the SPROM could be included in the kernel; however, this presents
>> a problem in the generation of a unique, reproducible MAC address. The
>> solution is to initialize the address to a known, workable value. Thus,
>> the device will work without any further code. For an address that is
>> preserved across reloads or reboots, a set of udev routines has been
>> prepared that detect the special address and assign a random value that
>> is preserved in a second udev rule file. The random address should be
>> unique except for the case where a given box has more than one of these
>> cards. This case is handles by adding the DEVPATH to the recognition rules.
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> 
> Do we still want this patch?  Or do we think all the cases of a
> "missing" SPROM were actually a "relocated" SPROM?

I would say to drop it for now. We may never even have found a relocated
SPROM, just some bug that keeps it from being read. I'll keep the patch
for the time when we actually find a device in the wild without an
SPROM. To help us find such a device, you should reinstate commit
fcb54b0bf7d3fe730c2. It didn't fix the problems that we have currently,
but the Broadcom driver does indicate that these tests are needed.
Perhaps the message at

+       if (!ssb_is_sprom_available(bus)) {
+               ssb_printk(KERN_ERR PFX "No SPROM available!\n");
+               return -ENODEV;
+       }

should be enhanced to tell the user to contact us on the ML so that we
know that it is time for the virtual SPROM patch.

Larry
