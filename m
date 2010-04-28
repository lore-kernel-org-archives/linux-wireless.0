Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753621Ab0D1Aop (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Apr 2010 20:44:45 -0400
Subject: Re: libertas sdio broken on XO-1.5s
From: Dan Williams <dcbw@redhat.com>
To: Steve deRosier <steve@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <i2y446ae9281004271235sf6f04323j2faa28108481d81b@mail.gmail.com>
References: <i2y446ae9281004271235sf6f04323j2faa28108481d81b@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Apr 2010 17:14:50 -0700
Message-ID: <1272413690.32717.10.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-04-27 at 12:35 -0700, Steve deRosier wrote:
> Dan,
> 
> A change made by you on April 15th breaks firmware downloading to an
> sdio connected 8686 on the OLPC's XO-1.5s.  I reverted it and was able
> to get firmware to load just fine, with it in, the firmware fails to
> load.

Ok, so we get to find out what fails with XO 1.5, and what works with
both the Wi2Wi and the Marvell 8686 dev board that I have that I tested
it with...  I'll retest again I suppose.

> commit 96021f096e5178582af296a2fbb6df7dbd6b695c
> Author: Dan Williams <dcbw@redhat.com>
> Date:   Thu Apr 15 13:27:44 2010 -0700
> 
>     libertas: consolidate SDIO firmware wait code
> 
>     Consolidate a bunch of C&P code that waits for the firmware to be ready.
> 
>     Signed-off-by: Dan Williams <dcbw@redhat.com>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> dmesg:
> [   15.391242] libertas_sdio: Libertas SDIO driver
> [   15.391255] libertas_sdio: Copyright Pierre Ossman
> [   15.539475] libertas_sdio mmc0:0001:1: firmware: requesting sd8686_helper.bin
> [   17.540214] libertas: failed to load helper firmware
> [   17.541054] libertas_sdio: probe of mmc0:0001:1 failed with error -110
> 
> dmesg with it reverted:
> [   15.141728] libertas_sdio: Libertas SDIO driver
> [   15.141741] libertas_sdio: Copyright Pierre Ossman
> [   15.275322] libertas_sdio mmc0:0001:1: firmware: requesting sd8686_helper.bin
> [   16.430223] libertas_sdio mmc0:0001:1: firmware: requesting sd8686.bin
> [   17.172443] libertas: 00:50:43:28:26:40, fw 9.70.7p0, cap 0x00000303
> [   17.179552] libertas: wlan0: Marvell WLAN 802.11 adapter
> 
> I don't know if there's something unique with this device where
> libertas_sdio works everywhere else and not with the XO-1.5, but I
> suspect we'll encounter this issue with other libertas devices.

The XO is all kinds of unique, but the 1.5 less so than the 1.0.

Dan

> I apologize for not sending a patch, but I don't have time right now
> to get to it.  Perhaps you can get to it quicker, if so, I'll be happy
> to test anything you come up with.
> 
> - Steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


