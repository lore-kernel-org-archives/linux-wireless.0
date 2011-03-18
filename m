Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:37289 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177Ab1CRXct convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 19:32:49 -0400
Received: by qyg14 with SMTP id 14so3799220qyg.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 16:32:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300490544.16395.50.camel@dev.znau.edu.ua>
References: <1300449773-11255-1-git-send-email-zajec5@gmail.com>
	<1300453433.13499.18.camel@dev.znau.edu.ua>
	<AANLkTimG8G_BsqoAUYWfRETfU1ndu_i87WjkXx+v_sNE@mail.gmail.com>
	<AANLkTi=EeMKNsi9bxNg4RJre-pP=jqcGpbLPNtggSK0N@mail.gmail.com>
	<1300463392.13499.110.camel@dev.znau.edu.ua>
	<AANLkTi=GggwyGkDB+cBG-G3O2c5WdfjCpb5pk8=3yDKz@mail.gmail.com>
	<1300471917.14872.28.camel@dev.znau.edu.ua>
	<AANLkTikQ7W4GdY=USphz3FphyS-yEwN+X+jUPwq9x_6z@mail.gmail.com>
	<1300478510.15393.45.camel@dev.znau.edu.ua>
	<AANLkTi=1XOxwS4tMc6eMcNGeHf_ZGaAH5MC97JsP7oWP@mail.gmail.com>
	<1300488010.16395.37.camel@dev.znau.edu.ua>
	<AANLkTimtS9dFMgxzBR0HrXxKs6uRghKi_zaGEP-i5paB@mail.gmail.com>
	<1300490544.16395.50.camel@dev.znau.edu.ua>
Date: Sat, 19 Mar 2011 00:32:48 +0100
Message-ID: <AANLkTi=4tUVtXFZ4xYs5v+mgYKTPiBXDxxtgGMHf+868@mail.gmail.com>
Subject: Re: [RFC][PATCH] ssb: separate common scanning functions
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: George Kashperko <george@znau.edu.ua>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
	b43-dev@lists.infradead.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/3/19 George Kashperko <george@znau.edu.ua>:
>
>> 2011/3/18 George Kashperko <george@znau.edu.ua>:
>> > Well, here you are:
>> > 1. PCI hosts with PCI buscores prior rev. 13 (8Kb window)
>> > offset  size    type    description
>> > 0x0000  0x1000  sliding controlled with BAR0_WIN1 register
>> > 0x1000  0x0800  fixed   SPROM
>> > 0x1800  0x0400  fixed   PCI core (core registers 0x0000 to 0x03FF range)
>> > 0x1C00  0x0400  fixed   PCI core (agent registers, 0x0C00 to 0x0FFF range)
>> >
>> > 2. PCI hosts with PCI buscores rev. 13 and above and PCIE with
>> > Chipcommon rev. up to 31 (16Kb window)
>> > offset  size    type    description
>> > 0x0000  0x1000  sliding controlled with BAR0_WIN1 register
>> > 0x1000  0x1000  fixed   SPROM
>> > 0x2000  0x1000  fixed   PCI core
>> > 0x3000  0x1000  fixed   Chipcommon core
>> >
>> > 3. PCIE hosts with Chipcommon rev. 32 and above
>> > offset  size    type    description
>> > 0x0000  0x1000  sliding controlled with BAR0_WIN1 register
>> > 0x1000  0x1000  sliding controlled with BAR0_WIN2 register
>> > 0x2000  0x1000  fixed   PCI core
>> > 0x3000  0x1000  fixed   Chipcommon core
>> >
>> > As you can see even if PCI_REVISION can't feed us with guaranteed choice
>> > of either of these 3 layouts we can distingiush between them easily like
>> > following:
>> >
>> > if (pci_is_pcie(dev)) {
>> >        u32 chipid = ioread32(bar0_base + 0x3000);
>> >        if (chipid & 0x10000000)
>> >                /* AXI, Chipcommon rev. is 32+ */
>> >                goto win_3_setup;
>> >        else
>> >                /* SB, Chipcommon rev. is <= 31 */
>> >                goto win_2_setup;
>> > } else {
>> >        u32 idhi = ioread32(bar0_base + 0x1C00 + 0x03FC);
>> >        if (((idhi & 0x00008FF0) >> 4) == 0x804)
>> >                /* PCI core id */
>> >                goto win_1_setup;
>> >        else
>> >                /* Some crap from SPROM area */
>> >                goto win_2_setup;
>> > }
>> >
>> > Therefore we can setup PCI(e) host windows for backplane access prior to
>> > scanning.
>> >
>> > As for BAR0_WIN[12] registers, they point to physical base address on
>> > backplane that will be mapped into corresponding 0x1000-size window. And
>> > here again registers don't care what exactly you want to see there. Both
>> > the windows can be controlled independently.
>> >
>> > Finally, you might noticed we don't have SPROM in last 3rd layout. Thats
>> > because it is in Chipcommon registers' space. For layouts #1 & #2 BAR0
>> > range 0x1000 to 0x2000 is either mapped to actual SPROM or to SPROM
>> > shadow in PCI core.
>>
>> Wohoo, and this is second part of info I really needed, thanks a lot!
>> I think there are mistakes in it, but I just wanted to get the idea of
>> windows. So thanks a lot.
>>
>> As for mistakes:
>> 1) The split is not 1-31 vs. 32-... I believe it is 1-30 vs. 31-...
>> 2) On chipco >= 31 SSB SPROM seems to be 0x800
>> Maybe sth more...
>>
> Watch bcmsrom.c for #define SROM_OFFSET
>
> For Chipcommons rev. >31 (the same as >=32) SPROM is in Chipcommon at
> 0x0800 offset - 0x3800 offset of BAR0 (if CAP_SPROM capability bit is
> set), otherwise SPROM is unavailable.
> For Chipcommons rev. <=31 (the same as <32) SPROM is mapped to 0x1000
> offset of BAR0.

I guess we may have errors in:
http://bcm-v4.sipsolutions.net/SPROM
http://bcm-v4.sipsolutions.net/802.11/IsSpromAvailable
then.

-- 
Rafał
