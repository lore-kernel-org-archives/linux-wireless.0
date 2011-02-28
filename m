Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61317 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab1B1V2W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 16:28:22 -0500
Message-ID: <4D6C1350.6050903@lwfinger.net>
Date: Mon, 28 Feb 2011 15:27:44 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	George <george0505@realtek.com>, linux-next@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: usb parts should depend on CONFIG_USB
References: <alpine.DEB.2.00.1102171354200.16788@ayla.of.borg>	 <1298922500-21632-1-git-send-email-linville@tuxdriver.com>	 <1298923731.10109.0.camel@jlt3.sipsolutions.net>	 <20110228201357.GF2515@tuxdriver.com>  <4D6C10B0.2090402@lwfinger.net> <1298928111.12230.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1298928111.12230.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/28/2011 03:21 PM, Johannes Berg wrote:
> On Mon, 2011-02-28 at 15:16 -0600, Larry Finger wrote:
>> On 02/28/2011 02:13 PM, John W. Linville wrote:
>>> On Mon, Feb 28, 2011 at 09:08:51PM +0100, Johannes Berg wrote:
>>>> On Mon, 2011-02-28 at 14:48 -0500, John W. Linville wrote:
>>>>>
>>>>> +ifeq ($(CONFIG_USB),y)
>>>>> +rtlwifi-objs	+= usb.o
>>>>> +endif
>>>>
>>>> That reads weird, shouldn't
>>>>
>>>> rtlwifi-$(CONFIG_USB) += usb.o
>>>>
>>>> do? Or more likely actually use CONFIG_RTL8192CU?
>>>
>>> Maybe...really just following what Larry already had there for pci...?
>>
>> Yes, and that was wrong too.
>>
>> It could be either as Johannes wrote it, or
>
> No, what I said won't work for m either, since you'd get
>
> rtlwifi-m += usb.o
>
> Though you can make that work by adding $(rtlwifi-m) manually to the
> list of objects later.

I just tested it. As you say, your solution only works for y, not m.

I think this is what is needed:

-ifeq ($(CONFIG_PCI),y)
+ifneq ($(CONFIG_PCI),)
  rtlwifi-objs   += pci.o
  endif

+ifneq ($(CONFIG_USB),)
+rtlwifi-objs   += usb.o
+endif
+

At least it works wit PCI=y and USB=m.

Larry
