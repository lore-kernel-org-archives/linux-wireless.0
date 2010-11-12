Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35452 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752310Ab0KLThV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 14:37:21 -0500
Message-ID: <4CDD9753.80909@openwrt.org>
Date: Fri, 12 Nov 2010 20:36:51 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: Wojciech Dubowik <dubowoj@neratec.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 8/9] ath5k: AHB port. Add AHB bus support.
References: <22942120.791289486697022.JavaMail.wlan@CHBU500181>	<13896234.1151289487498939.JavaMail.wlan@CHBU500181> <AANLkTinoANxSOiBJpa2hDk7V=ScSa66rcj-f1HfQGV1u@mail.gmail.com>
In-Reply-To: <AANLkTinoANxSOiBJpa2hDk7V=ScSa66rcj-f1HfQGV1u@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-12 8:26 PM, Bob Copeland wrote:
> On Thu, Nov 11, 2010 at 9:58 AM, Wojciech Dubowik <dubowoj@neratec.com> wrote:
>>
>> AHB specific functions are now in ahb.c file. There is no common
>> init functions which tries first pci and then ahb becasue on some
> 
> 'because'
> 
>> --- a/drivers/net/wireless/ath/ath5k/Makefile
>> +++ b/drivers/net/wireless/ath/ath5k/Makefile
>> @@ -15,5 +15,5 @@ ath5k-y                               += rfkill.o
>>  ath5k-y                                += ani.o
>>  ath5k-y                                += sysfs.o
>>  ath5k-$(CONFIG_ATH5K_DEBUG)    += debug.o
>> -ath5k-y                                += pci.o
>> +ath5k-y                                += $(if $(CONFIG_ATHEROS_AR231X),ahb,pci).o
>>  obj-$(CONFIG_ATH5K)            += ath5k.o
> 
> This is not the right way.. what if someone wants both in one kernel?
Having both in the kernel is completely pointless. There are no devices
that can support both, nor will there ever be.

- Felix
