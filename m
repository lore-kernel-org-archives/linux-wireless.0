Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:62385 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758223Ab3HIOe0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Aug 2013 10:34:26 -0400
Received: from [192.168.2.102] ([93.218.76.213]) by mail.gmx.com (mrgmx003)
 with ESMTPSA (Nemesis) id 0MVdfD-1VeOND3IYJ-00YvY4 for
 <linux-wireless@vger.kernel.org>; Fri, 09 Aug 2013 16:34:24 +0200
Message-ID: <5204FDEF.5010108@rempel-privat.de> (sfid-20130809_163431_046078_AE32F03D)
Date: Fri, 09 Aug 2013 16:34:23 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	ath9k_htc_fw <ath9k_htc_fw@lists.infradead.org>,
	USB list <linux-usb@vger.kernel.org>,
	linux-wireless@vger.kernel.org
Subject: Re: FUSB200 xhci issue
References: <Pine.LNX.4.44L0.1308091011130.1405-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1308091011130.1405-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 09.08.2013 16:13, schrieb Alan Stern:
> On Fri, 9 Aug 2013, Christian Lamparter wrote:
>
>>> After loading firmware, a reset generally is necessary.  Some devices
>>> will do it themselves; others require you to call usb_reset_device().
>>
>> This makes things complicated. Because, as far as I remember,
>> usb_reset_device() will cause the current driver to be unbound
>> unless its called during .probe, right?
>
> If the driver defines pre_reset and post_reset methods, it won't get
> unbound during a reset.
>
>> You see, ath9k_htc loads its firmware asynchronously in ".probe"
>> (ath9k_htc's .probe routine finishes before the firmware is
>> retrieved via the firmware loader helper... so part of the
>> firmware download is done in a firmware_complete callback
>> on a workqueue).
>>
>> So, if we call usb_reset_device there and the driver is unbound
>> and later rebound. the next ath9k_htc .probe will start again and
>> again and again not knowing that it is already initialized
>> (and we have a loop).
>>
>>
>> This could be solved, if the devices changes the usb-id again
>> when a proper "wifi" ath9k_htc firmware was downloaded. So, the
>> driver would know that it doesn't have to download and reset
>> the device... But we need a "free" USB-ID for that.
>
> What about a "get firmware version" sort of thing?  There really should
> be a way for the driver to tell whether the firmware has already been
> updated.

I was not able to find good direct way to check firmware version. If i 
would add some new command then i will get option like: if responding FW 
is updated; if not, then dead or old.
How about overwriting iProduct field? Let say, if iProduct == ath9k_htc, 
then firmware is updated? Is it more or less acceptable method? I need 
to ask this because it is really new for me.
-- 
Regards,
Oleksij
