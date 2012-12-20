Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:60453 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041Ab2LTOew (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 09:34:52 -0500
Message-ID: <50D32208.10701@openwrt.org> (sfid-20121220_153455_312994_E9BF628D)
Date: Thu, 20 Dec 2012 15:34:48 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Stanislaw Gruszka <stf_xl@wp.pl>
CC: Kalle Valo <kvalo@adurom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Daniel Golle <dgolle@allnet.de>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [rt2x00-users] [PATCH 2/2] rt2x00: rt2800pci: allow to load EEPROM
 data via firmware API
References: <1355847743-16659-1-git-send-email-juhosg@openwrt.org> <1355847743-16659-2-git-send-email-juhosg@openwrt.org> <20121218222226.GB4825@localhost.localdomain> <50D18A5A.2020505@openwrt.org> <87d2y5umko.fsf@purkki.adurom.net> <20121220110602.GA13055@localhost.localdomain>
In-Reply-To: <20121220110602.GA13055@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012.12.20. 12:06 keltezéssel, Stanislaw Gruszka írta:
> On Thu, Dec 20, 2012 at 10:58:31AM +0200, Kalle Valo wrote:
>> Gabor Juhos <juhosg@openwrt.org> writes:
>>
>>>> Since we use completion here, why we can not just use normal synchronous
>>>> version of request_firmware? I heard of request_firmware drawbacks, so
>>>> this approach can be correct. Just want to know if we do not complicate
>>>> things not necessarily here.
>>>
>>> If the driver is built into the kernel, then the synchronous version
>>> would fail because user-space is not up during probe time.
>>
>> Didn't udev/systemd guys finally fix their software? At least I recall
>> seeing such claims on g+.
> 
> Udev broke and later fixed request_firmware when driver is compiled as
> module. Here we avoid problem when driver is compiled into kernel
> (problem which was there from very beginning) - no userspace available
> so request_firmware fail. But since everyone are using modules, nobody
> cares.
> 
> Openwrt must use modules too, since it use compat-wireless, right? 

Yes, we are using modules.

> So I'm not sure if it worth to use request_firmware_nowait. Especially like
> that with completion, which block ->probe. As long kernel does not probes
> devices in parallel, we block whole boot, and deadlock since probe wait for
> userspace.
>
> Gabor, did you test your patches ?

I have tested the patches, but only agains compat-wireless. I did not try the
rt2x00 driver built into the kernel. Although we are using 3.6.11 currently, but
the deadlock should happen on that as well. I will try it.

-Gabor
