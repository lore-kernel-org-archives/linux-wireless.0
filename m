Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:16668 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab0GFLDH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jul 2010 07:03:07 -0400
Message-ID: <4C330D37.4090104@nokia.com>
Date: Tue, 06 Jul 2010 14:02:15 +0300
From: Roger Quadros <roger.quadros@nokia.com>
MIME-Version: 1.0
To: ext Ohad Ben-Cohen <ohad@wizery.com>
CC: Nicolas Pitre <nico@fluxnic.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	"Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	San Mehat <san@google.com>,
	"Pandita, Vikram" <vikram.pandita@ti.com>
Subject: Re: [PATCH 05/15] omap: hsmmc: add virtual card detect support
References: <1278376666-3509-1-git-send-email-ohad@wizery.com> 	<1278376666-3509-6-git-send-email-ohad@wizery.com> <alpine.LFD.2.00.1007052134460.6020@xanadu.home> <AANLkTim4E4LlFERmfYA1M0HLBOoRAsQuvdW6QBNu6pC0@mail.gmail.com>
In-Reply-To: <AANLkTim4E4LlFERmfYA1M0HLBOoRAsQuvdW6QBNu6pC0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/06/2010 01:22 PM, ext Ohad Ben-Cohen wrote:
> Hi Nicolas,
>
> On Tue, Jul 6, 2010 at 4:45 AM, Nicolas Pitre<nico@fluxnic.net>  wrote:
>> On Tue, 6 Jul 2010, Ohad Ben-Cohen wrote:
>>
>>> From: Ohad Ben-Cohen<ohadb@ti.com>
>>>
>>> Add support for software emulation of card detect
>>> events.
>>>
>>> This is required for specific controllers
>>> that are hard wired with embedded SDIO devices
>>> (such as TI's wl1271 WLAN device).
>>
>> Why?
>>
>> Many instances of hardwired SDIO based WLAN devices do exist already,
>> and they don't need extra card detect events to be generated.  The core
>> MMC code already triggers a probe for cards whenever a new host
>> controller is registered.
>
> We prefer not to power up the chip as early as boot time; instead, we
Why? if the card is hard wired with no card detect then it should be powered up. 
The function driver should power it down later if required. no?

> would like to have it powered off until the wlan interface is brought
> up, power it on when the interface is brought up,

If it was powered OFF then how did the wlan interface come into picture?

> and power it off again as soon as the interface is brought down again
> (to minimize power consumption when the wlan is not in use).
I agree, we some how need to power down the card when not in use in the right way.
