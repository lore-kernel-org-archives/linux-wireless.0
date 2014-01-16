Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:34356 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129AbaAPLsZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 06:48:25 -0500
Message-ID: <52D7C62F.2030307@neratec.com> (sfid-20140116_124828_468633_360F2E6C)
Date: Thu, 16 Jan 2014 12:44:47 +0100
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/5] ath9k: Fix TX IQ calibration for SoC chips
References: <1384665016-12022-1-git-send-email-sujith@msujith.org>	<1384665016-12022-5-git-send-email-sujith@msujith.org>	<52CE934D.1020400@neratec.com>	<21198.40916.260973.48444@gargle.gargle.HOWL>	<52CEA5A3.2040308@neratec.com>	<21198.43395.235654.597422@gargle.gargle.HOWL>	<52CEAB24.5090700@neratec.com>	<52D3F962.1010302@neratec.com>	<21204.319.492595.58625@gargle.gargle.HOWL>	<52D402C3.3070606@neratec.com>	<21204.1991.201080.986559@gargle.gargle.HOWL>	<21204.2384.710460.402183@gargle.gargle.HOWL>	<21204.3832.404821.109119@gargle.gargle.HOWL>	<52D63EBB.7020607@neratec.com>	<21206.17284.157496.206327@gargle.gargle.HOWL>	<52D6472B.2060207@neratec.com>	<21207.48441.292580.481850@gargle.gargle.HOWL> <21207.49245.151249.759167@gargle.gargle.HOWL>
In-Reply-To: <21207.49245.151249.759167@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/16/2014 12:19 PM, Sujith Manoharan wrote:
> Sujith Manoharan wrote:
>> We could fix this by checking if we are initializing the history for the operating
>> channel and waiting for NF-cal completion, but I am not sure if this needs
>> to be done. The window is really small and subsequent NF calibrations using
>> the ANI routine work properly.
> Also, this is a bad idea in general since NF calibration has to
> wait for the medium to become idle - problematic when there is heavy
> interference or general WLAN usage.
>
> Sujith
I guess I won't be able to reproduce bad scan results with wireless 
testing since I have
changed scan reporting to pure rssi in my openwrt compat.
In normal case you get a sum of rssi and noise floor and it will be 
correct i.e. when
NF is shifted by 14db so will be rssi.
So it's just my use case.

Anyway I have just solved the issue by applying calibrated noise floor 
values from eeprom
instead of nominal in nf_get functions and nf histogram. Now the rssi 
seems stable in my test
environment. I have just started testing but it looks promising.

I don't know whether it's worth changing it upstream since most of 
available ar9003 cards
I have seen are not noise floor calibrated. A bit bad becasue it could 
be used for spectral
scan as well to improve accuracy.

Wojtek
