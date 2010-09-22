Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56009 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab0IVUqk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 16:46:40 -0400
Received: by bwz11 with SMTP id 11so792125bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 13:46:38 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: pull request: wireless-next-2.6 2010-09-21
Date: Wed, 22 Sep 2010 22:46:30 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <201009221158.13806.chunkeey@googlemail.com> <201009222054.05469.chunkeey@googlemail.com> <20100922.121902.71115228.davem@davemloft.net>
In-Reply-To: <20100922.121902.71115228.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201009222246.31687.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 22 September 2010 21:19:02 David Miller wrote:
> From: Christian Lamparter <chunkeey@googlemail.com>
> Date: Wed, 22 Sep 2010 20:54:05 +0200
> 
> > Only the structs which deal with hardware (hw.h, eeprom.h, wlan.h)
> > or firmware (fwcmd.h, fwdesc.h & wlan.h) interface have the
> > __packed attribute. And there are several good reasons. 
> > (don't kill the reasons)!
> 
> This is because GCC is not allowed to assume the alignment of any
> structure marked with __packed.  Therefore only byte sized loads are
> safe on architectures that require types be aligned to their size.
> 
> This really is a performance issue, otherwise I frankly wouldn't
> care where you put __packed.
Well, if you only care about "performance" then I have good news!
Because the only __packed structs that are important for us in the
tx & rx hot-paths are the two hardware tx/rx descriptors in wlan.h. 

Everything else is boring. e.g.:
 * The firmware descriptor is only important at boot-time
  (parsing the firmware is really fast, compared to the "second"
   we have to wait for the device to boot)

 * Firmware commands are (apart from the first init and channel change)
   very rarely issued during operation.
   In fact the most "critical thing" is switching on/off
   the LEDs (of course this is done by a workqueue item, so
   you probably get the idea)

so almost everything can stay the way it is. The only thing that needs
to be change (according to you concern) is hardwired into the chip....

But the driver can try to minimizes the access to unaligned elements,
by using temporary variables (so the value needs to be accessed only
once). In fact that's already done, the only room for improvement
would be in carl9170_tx_prepare (temporary u16 for mac_control,
u8 super_misc, u8 rate_info).
