Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:60309 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbbCHVxt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Mar 2015 17:53:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v3 2/2] wl18xx: add basic device-tree support
Date: Sun, 08 Mar 2015 22:53:45 +0100
Message-ID: <2658240.aoSloEbWge@wuerfel> (sfid-20150308_225358_796320_1918E888)
In-Reply-To: <CAB3XZEfc3qV_o+0paM=HNdySKWwiJDfH=kJ8u0tz1ae+3ujxVw@mail.gmail.com>
References: <1424362401-8228-1-git-send-email-eliad@wizery.com> <2194797.iarD5YIxEd@wuerfel> <CAB3XZEfc3qV_o+0paM=HNdySKWwiJDfH=kJ8u0tz1ae+3ujxVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 08 March 2015 13:13:13 Eliad Peller wrote:
> 
> > I've looked up the what boards actually use this data and found that
> > all of them already support booting from DT: some omap2 boards using
> > arch/arm/mach-omap2/pdata-quirks.c to provide the data, and the
> > davinci 850evm. Can you make sure you add the correct data to all
> > of these dts files as part of your series and remove the
> > wl12xx_platform_data references?
> 
> AFAICT, these board files add wl12xx platform data, while the new DT
> support is only for wl18xx.
> 

How can you tell the difference? What I see is that omap3pandora
(and nothing else) calls wl1251_set_platform_data(), while 
da850-evm and all omap3/omap4 boards use wl12xx_set_platform_data().

The latter seems to refer to all wl12xx and wl18xx variants except
for wl1251, based on my (very limited) understanding of that code.

	Arnd
