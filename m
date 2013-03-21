Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:37593 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034Ab3CUSDF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Mar 2013 14:03:05 -0400
Message-ID: <514B4B72.1000607@openwrt.org> (sfid-20130321_190319_736031_BB4462B8)
Date: Thu, 21 Mar 2013 19:03:30 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Gertjan van Wingerde <gwingerde@gmail.com>
CC: John Crispin <blogic@openwrt.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH] rt2x00: make the driver build for Ralink SoC
References: <1363808915-14278-1-git-send-email-blogic@openwrt.org> <3D4497AD-8992-47D6-BCF2-5D738B6AC9B4@gmail.com>
In-Reply-To: <3D4497AD-8992-47D6-BCF2-5D738B6AC9B4@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013.03.20. 22:29 keltezéssel, Gertjan van Wingerde írta:
> 
> 
> Sent from my iPad
> 
> On 20 mrt. 2013, at 20:48, John Crispin <blogic@openwrt.org> wrote:
> 
>> Fix up the dependencies to make the driver actually compile on Ralink WiSoC.
>>
>> Signed-off-by: John Crispin <blogic@openwrt.org>
> 
> I don't think this is a proper way to handle this. rt2x00pci.c was only
> meant to be used for PCI devices; introducing the use of CONFIG_PCI in that file
> doesn't seem appropriate to me.

Well, CONFIG_PCI is also used in rt2800pci.c. The root cause of the problem is
that rt2800pci (despite its name) is used to drive the built-in wireless MAC of
various SoCs. This is because handling of the PCI and of the SoC built-in
devices is quite similar. However regardless of the underlying bus type,
rt2800pci uses several functions exported from rt2x00pci so it should always
select RT2X00_LIB_PCI.

The rt2x00pci_{probe,remove,suspend,resume} handlers from rt2x00pci are not used
by rt2800pci if PCI disabled. However the presence of that functions in rt2x00
causes build error if the driver is compiled with disabled PCI support.

If we properly want to fix the issue, lots of functions should be renamed and
should be moved into separate modules. The name of these new modules could be
rt2x00mmio and rt2800mmio for example.

Adding CONFIG_PCI to rt2x00pci could be a temporary solution until that is not done.

-Gabor
