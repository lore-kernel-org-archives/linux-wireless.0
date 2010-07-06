Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:23290 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab0GFMjl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jul 2010 08:39:41 -0400
Message-ID: <4C3323EA.902@nokia.com>
Date: Tue, 06 Jul 2010 15:39:06 +0300
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
References: <1278376666-3509-1-git-send-email-ohad@wizery.com> 	<1278376666-3509-6-git-send-email-ohad@wizery.com> <alpine.LFD.2.00.1007052134460.6020@xanadu.home> 	<AANLkTim4E4LlFERmfYA1M0HLBOoRAsQuvdW6QBNu6pC0@mail.gmail.com> <AANLkTinE5LygUWJsJSEE2miZF1GK58LTr8zErkuu_7yM@mail.gmail.com>
In-Reply-To: <AANLkTinE5LygUWJsJSEE2miZF1GK58LTr8zErkuu_7yM@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 07/06/2010 02:48 PM, ext Ohad Ben-Cohen wrote:
> On Tue, Jul 6, 2010 at 1:22 PM, Ohad Ben-Cohen<ohad@wizery.com>  wrote:
>> Note: the wl1271 device does support standard card detection, but
>> AFAIK there's a limitation to use that with the specific omap
>> controller the device is hardwired to. I will try to get more info
>> about that, but probably Madhu can comment on that better.
>
>
> Some correction and additional info:
>
> The wl1271 device has an issue which makes the standard card detect
> mechanism irrelevant: it is always up, even if the power enable gpio
> input of the device is down (the power enable input does not supply
> the power to the chip, it's just logical digital high/low input upon
> which the device reacts).  That's why we must use software control for
> emulating card detect with that device.

Just to clarify, is the wl1271 device always powered on the board?

And this GPIO power enable (OMAP_ZOOM_WLAN_PMENA_GPIO) is used to gate this 
supply internally?

and what do these do ?

set_bit(WL1271_FLAG_GPIO_POWER, &wl->flags);

clear_bit(WL1271_FLAG_GPIO_POWER, &wl->flags);

regards,
-roger
