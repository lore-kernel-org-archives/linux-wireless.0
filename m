Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49816 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067Ab3CUHjO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Mar 2013 03:39:14 -0400
Message-ID: <514AB846.9090407@openwrt.org> (sfid-20130321_083919_749944_3303FAA1)
Date: Thu, 21 Mar 2013 08:35:34 +0100
From: John Crispin <blogic@openwrt.org>
MIME-Version: 1.0
To: Gertjan van Wingerde <gwingerde@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH] rt2x00: make the driver build for Ralink SoC
References: <1363808915-14278-1-git-send-email-blogic@openwrt.org> <3D4497AD-8992-47D6-BCF2-5D738B6AC9B4@gmail.com>
In-Reply-To: <3D4497AD-8992-47D6-BCF2-5D738B6AC9B4@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>> Fix up the dependencies to make the driver actually compile on Ralink WiSoC.
>>
>> Signed-off-by: John Crispin<blogic@openwrt.org>
> I don't think this is a proper way to handle this. rt2x00pci.c was only meant to be used for PCI devices; introducing the use of CONFIG_PCI in that file doesn't seem appropriate to me.
>
> Unfortunately I am away from my home computer, so I can't look at this properly until the weekend.
>

Indeed not the cleanest patch ... after changing the config symbols I 
realized that that is not enough to make the driver actually work

It turns out that inside openwrt the compat-wireless package sets 
CONFIG_RT2800PCI=m to make the driver build and then applies the 
#ifdef'ery to rt2880pci.c

I will try to find the time today or tomorrow to have a closer look at this

     John
