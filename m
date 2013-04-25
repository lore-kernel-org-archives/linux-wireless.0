Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postler.einfach.org ([86.59.21.13]:52500 "EHLO
	postler.einfach.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758003Ab3DYSjo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Apr 2013 14:39:44 -0400
Message-ID: <51797866.9030403@einfach.org> (sfid-20130425_203949_394504_4513D238)
Date: Thu, 25 Apr 2013 19:39:34 +0100
From: Bruno Randolf <br1@einfach.org>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linux-wireless@vger.kernel.org, frankyl@broadcom.com,
	meuleman@broadcom.com, brudley@broadcom.com,
	brcm80211-dev-list@broadcom.com,
	=?UTF-8?B?5rW36Je75pWs5LmL?= <tkaiso@thinktube.com>
Subject: Re: Broadcom brcmfmac vs bcmdhd on Android
References: <5176ABB1.2070506@einfach.org> <5176F8C2.7050502@broadcom.com> <5177F7D6.2020800@einfach.org>
In-Reply-To: <5177F7D6.2020800@einfach.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/24/2013 04:18 PM, Bruno Randolf wrote:
>>> I succeeded to compile brcmfmac from recent compat-drivers against the
>>> "tuna" (Galaxy Nexus) kernel, the modules load, but no device is
>>> recognized. Has anyone succeeded doing this? Is there any chance it can
>>> work?
>>
>> That is how we did it and with success. What do you mean by 'no device
>> is recognized'? Do you have any traces to look at?
>
> Good to know. What I did is I compiled the "tuna" kernel (3.0.31)
> without bcmdhd, then brcmfmac from compat-drivers, loaded the brcmfmac
> module (+ dependencies), but then nothing happens. It looks like the
> device is not recognized on SDIO. Is there anything special I need to do
> to activate the chip?

I spent some more time tracing the problem, without much success. Still 
it simply looks like no SDIO device is detected. Please see below for 
what I found, maybe something rings a bell for you?

Enabling tracing in the brcmfmac driver shows me
"brcmfmac: brcmf_sdio_init: Enter", nothing more.

Then, I enabled function tracing, here are the relevant parts:

sdio_register_driver <-brcmf_sdio_init
driver_register <-sdio_register_driver
driver_find <-driver_register
bus_add_driver <-driver_register
driver_attach <-bus_add_driver
bus_for_each_dev <-driver_attach
module_add_driver <-bus_add_driver

The rest is sysfs file registration, nothing more interesting, but I can 
send you the full dump if you want... No driver probe functions are called.

I see a strange problem with the brcmf_sdmmc_ids:

{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_43241)},
{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4329)},
{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4330)},
{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4334)},

On the Galaxy Nexus modinfo just shows:

alias:          sdio:c*v02D0d4334*
alias:          sdio:c*v02D0d4329*

I.e. every second device, while on my host the modinfo list looks OK.

I manually changed the list to only include 4330 and that way modinfo 
shows it correctly also on the device, but maybe this is part of the 
problem?

How did you get it to work? Which device did you use (Galaxy Nexus?)?
Do I need to activate CONFIG_BRCMFMAC_SDIO_OOB (I tried with no difference)?

Thank you for any hints,
bruno




