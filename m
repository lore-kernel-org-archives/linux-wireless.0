Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58380 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754094Ab2GJWTv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 18:19:51 -0400
Message-ID: <4FFCAA7F.502@hauke-m.de> (sfid-20120711_001954_602243_581CE86B)
Date: Wed, 11 Jul 2012 00:19:43 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC][PATCH] bcma: add trivial GBIT MAC COMMON driver
References: <1341751888-12679-1-git-send-email-zajec5@gmail.com> <4FFB62DA.9000706@hauke-m.de> <CACna6ry-Hxt56DCn8amKUxnqF+X8juZK26j5bJaRk-ubh7didA@mail.gmail.com> <CACna6rzx8Jt215zJ3WD49XypBShC8yxfQfOwnqgFc0xYsx_6JQ@mail.gmail.com>
In-Reply-To: <CACna6rzx8Jt215zJ3WD49XypBShC8yxfQfOwnqgFc0xYsx_6JQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/10/2012 11:56 PM, Rafał Miłecki wrote:
> 2012/7/10 Rafał Miłecki <zajec5@gmail.com>:
>> 2012/7/10 Hauke Mehrtens <hauke@hauke-m.de>:
>>> On 07/08/2012 02:51 PM, Rafał Miłecki wrote:
>>>> GMAC COMMON core is present on BCM4706 and is used for example to access
>>>> board PHYs (PHYs can not be accessed directly using GBIT MAC core).
>>>
>>> I think this is the cleanest way of doing this. I thought about handling
>>> this in the Ethernet driver, but as we need locking, an extra driver
>>> would be needed, just for this stupid locking.
>>>
>>> You should not register an external device for this core in
>>> bcma_register_cores().
>>
>> I've just noticed my BCM4706 doesn't have GBIT MAC CMN... but AFAIK
>> BCM4706 GMAC (0x52d) can not operate without GMAC CMN (0x5dc)...
>>
>> Hauke: does it make any sense to you?
> 
> OK, I found out that quickly.
> 
> First of all, there is some bridge on my bus. bcma_erom_is_bridge
> returns true at some point of scanning.
> 
> Secondly I've printed cia for
> if (wrappers[0] + wrappers[1] == 0)
> case:
> [    2.360000] bcma: bus0: cia 0x43B36701 (0x367)
> [    2.368000] bcma: bus0: cia 0x43B36601 (0x366)
> [    2.372000] bcma: bus0: cia 0x43B01A01 (0x01A)
> [    2.376000] bcma: bus0: cia 0x43B01B01 (0x01B)
> [    2.380000] bcma: bus0: cia 0x43B01C01 (0x01C)
> [    2.388000] bcma: bus0: cia 0x43B5DC01 (0x5DC)
> [    2.392000] bcma: bus0: cia 0x43B5DD01 (0x5DD)
> 
Nice, there is the gmac common core. Will you write a patch extending
the scan function to find this core?

Hauke
