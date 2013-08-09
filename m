Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:50368 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964966Ab3HIPvr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Aug 2013 11:51:47 -0400
Received: from [192.168.2.102] ([93.218.76.213]) by mail.gmx.com (mrgmx002)
 with ESMTPSA (Nemesis) id 0Me8RK-1VVXKO14UI-00Ptxq for
 <linux-wireless@vger.kernel.org>; Fri, 09 Aug 2013 17:51:46 +0200
Message-ID: <52051009.9010001@rempel-privat.de> (sfid-20130809_175153_002294_BA33B6B2)
Date: Fri, 09 Aug 2013 17:51:37 +0200
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
References: <Pine.LNX.4.44L0.1308091043220.1405-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1308091043220.1405-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 09.08.2013 16:52, schrieb Alan Stern:
> On Fri, 9 Aug 2013, Oleksij Rempel wrote:
>
>>> What about a "get firmware version" sort of thing?  There really should
>>> be a way for the driver to tell whether the firmware has already been
>>> updated.
>>
>> I was not able to find good direct way to check firmware version. If i
>> would add some new command then i will get option like: if responding FW
>> is updated; if not, then dead or old.
>> How about overwriting iProduct field? Let say, if iProduct == ath9k_htc,
>> then firmware is updated? Is it more or less acceptable method? I need
>> to ask this because it is really new for me.
>
> Changing the iProduct string descriptor would work, because the
> descriptors_changed() routine doesn't compare the old value of that
> string with the new value.  (On the other hand, it does compare the
> iSerialNumber strings.)

Just to make sure. You mean, i should avoid changing iSerialNumber 
because host will initiate usb reset and this device will probably not 
survive it?

> Is there any way to read the firmware back from the device?  Then you
> could check directly.

No, this device is a SoC with usb client interface based on FUSB200 core 
(If i'm correct, same core as on carl9170 devices). We can't read memory 
unless FW provide this service.
At power on, this device will boot from external or internal ROM and 
load minimal FW. Without it, USB wont work.
If i read FW code correctly, it should be responsible for suspend and reset.
I do not have documentation, so created doc[1] based on code. From what 
is see, i assume that we can reset usb from FW. There is at least two 
methods:
- reset complete USB core. It looks for me like brute force, since we 
will need completely reconfigure usb core.
- use TEST registers? ZM_TEST_OFFSET or ZM_PHY_TEST_SELECT_OFFSET - i 
didn't played with it. So it is just assumption.
- other regs?


[1] https://github.com/qca/open-ath9k-htc-firmware/wiki/usb-regs
-- 
Regards,
Oleksij
