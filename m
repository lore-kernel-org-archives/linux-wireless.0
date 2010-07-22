Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43166 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab0GVX43 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 19:56:29 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1007230052320.12562@xanadu.home>
References: <1279733634-21974-1-git-send-email-ohad@wizery.com>
	<alpine.LFD.2.00.1007230052320.12562@xanadu.home>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 23 Jul 2010 02:56:07 +0300
Message-ID: <AANLkTinQa8-SePaCmqmMMOcTtJOVfKHq0yH4YCRMuqPg@mail.gmail.com>
Subject: Re: [PATCH v2 00/20] native support for wl1271 on ZOOM
To: Nicolas Pitre <nico@fluxnic.net>
Cc: linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux@arm.linux.org.uk,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	akpm@linux-foundation.org, San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Tony Lindgren <tony@atomide.com>,
	Pandita Vikram <vikram.pandita@ti.com>,
	Kalle Valo <kalle.valo@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 23, 2010 at 1:56 AM, Nicolas Pitre <nico@fluxnic.net> wrote:
> On Wed, 21 Jul 2010, Ohad Ben-Cohen wrote:
>
>> This patch series adds native support for wl1271 on ZOOM.
>>
>> Changes since v1:
>>
>> - introduce a fixed regulator device to control the power of wl1271
>> - allow to propagate private board-specific data to SDIO function drivers
>> - allow SDIO function driver to control the card's power via new API
>> - make it possible to keep the card's power down (without depending
>>   on an explicit SDIO function driver power-down request)
>>
>> Thanks to these changes, we no longer need a separate platform
>> device (carrying e.g. the external irq information of the device),
>> and no longer need to emulate virtual card detect events.
>>
>> The two "board muxing" pathces were already taken by Tony, and
>> are resent here just to make it easier for people to use/test these pathces.
>>
>> The changes to the MMC core really needs careful review; there still
>> might be some pitfalls that haven't been covered. E.g., one thing
>> we plan to look at next is their bahvior together with SDIO Suspend/Resume.
>>
>> Special thanks to Roger Quadros and Nicolas Pitre for their extensive
>> review and helpful suggestions.
>
> FYI, I do intend to review those patches, but I'll be flying home in a
> couple hours, and once there I'll be gone on vacation for 2 weeks.  So
> this review won't happen right away.

Thanks, Nicolas.


>
>
> Nicolas
>
