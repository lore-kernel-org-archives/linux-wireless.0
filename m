Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:60776 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753460Ab3C2PCN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Mar 2013 11:02:13 -0400
Message-ID: <5155AD13.40607@openwrt.org> (sfid-20130329_160217_434512_130A2E71)
Date: Fri, 29 Mar 2013 16:02:43 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Gertjan van Wingerde <gwingerde@gmail.com>
CC: John Crispin <blogic@openwrt.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH] rt2x00: make the driver build for Ralink SoC
References: <1363808915-14278-1-git-send-email-blogic@openwrt.org> <3D4497AD-8992-47D6-BCF2-5D738B6AC9B4@gmail.com> <514AB846.9090407@openwrt.org> <20130327171713.GD1868@tuxdriver.com> <515339AB.30609@openwrt.org> <AC53EE34-1306-490A-9BB3-290434C08D1C@gmail.com>
In-Reply-To: <AC53EE34-1306-490A-9BB3-290434C08D1C@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013.03.27. 21:38 keltezéssel, Gertjan van Wingerde írta:
> 
> 
> Sent from my iPad
> 
> On 27 mrt. 2013, at 19:25, John Crispin <blogic@openwrt.org> wrote:
> 
>> On 27/03/13 18:17, John W. Linville wrote:
>>> On Thu, Mar 21, 2013 at 08:35:34AM +0100, John Crispin wrote:
>>>>>> Fix up the dependencies to make the driver actually compile on Ralink WiSoC.
>>>>>>
>>>>>> Signed-off-by: John Crispin<blogic@openwrt.org>
>>>>> I don't think this is a proper way to handle this. rt2x00pci.c was only meant to be used for PCI devices; introducing the use of CONFIG_PCI in that file doesn't seem appropriate to me.
>>>>>
>>>>> Unfortunately I am away from my home computer, so I can't look at this properly until the weekend.
>>>>>
>>>> Indeed not the cleanest patch ... after changing the config symbols
>>>> I realized that that is not enough to make the driver actually work
>>>>
>>>> It turns out that inside openwrt the compat-wireless package sets
>>>> CONFIG_RT2800PCI=m to make the driver build and then applies the
>>>> #ifdef'ery to rt2880pci.c
>>>>
>>>> I will try to find the time today or tomorrow to have a closer look at this
>>> Any more word on this?
>> Gabor posted a series as RFC that would fix this properly ->
>>
>> http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2013-March/005837.html
> 
> Yeah, and that series looks good. Unfortunately, it is too intrusive to still apply for 3.9.
> 
> John L., could we get in a scheme where we apply John C.'s patch for 3.9 and then use Gabor's series for 3.10?
> Don't know how that works with making sure that this patch is reverted for 3.10.
> 
> Can you coordinate, or should I help you with this?

Sorry for the late reply. I have sent a less intrusive version of that RFC
patch-set, as an alternative solution.

-Gabor
