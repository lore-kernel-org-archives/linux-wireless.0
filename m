Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38399 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544Ab1B1VQo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 16:16:44 -0500
Message-ID: <4D6C10B0.2090402@lwfinger.net>
Date: Mon, 28 Feb 2011 15:16:32 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	George <george0505@realtek.com>, linux-next@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: usb parts should depend on CONFIG_USB
References: <alpine.DEB.2.00.1102171354200.16788@ayla.of.borg> <1298922500-21632-1-git-send-email-linville@tuxdriver.com> <1298923731.10109.0.camel@jlt3.sipsolutions.net> <20110228201357.GF2515@tuxdriver.com>
In-Reply-To: <20110228201357.GF2515@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/28/2011 02:13 PM, John W. Linville wrote:
> On Mon, Feb 28, 2011 at 09:08:51PM +0100, Johannes Berg wrote:
>> On Mon, 2011-02-28 at 14:48 -0500, John W. Linville wrote:
>>>
>>> +ifeq ($(CONFIG_USB),y)
>>> +rtlwifi-objs	+= usb.o
>>> +endif
>>
>> That reads weird, shouldn't
>>
>> rtlwifi-$(CONFIG_USB) += usb.o
>>
>> do? Or more likely actually use CONFIG_RTL8192CU?
>
> Maybe...really just following what Larry already had there for pci...?

Yes, and that was wrong too.

It could be either as Johannes wrote it, or

ifneq ($(CONFIG_USB),)
rtlwifi-objs    += usb.o
endif

Yhe PCI entry will also fail if CONFIG_PCI=m.

Larry
