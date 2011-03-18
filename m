Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:30660 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932764Ab1CRWlE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 18:41:04 -0400
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000028939.msg
	for <linux-wireless@vger.kernel.org>; Sat, 19 Mar 2011 00:39:59 +0200
Subject: Re: [RFC][PATCH] ssb: separate common scanning functions
From: George Kashperko <george@znau.edu.ua>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
	b43-dev@lists.infradead.org,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <AANLkTi=1XOxwS4tMc6eMcNGeHf_ZGaAH5MC97JsP7oWP@mail.gmail.com>
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
Content-Type: text/plain
Date: Sat, 19 Mar 2011 00:40:10 +0200
Message-Id: <1300488010.16395.37.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 2011/3/18 George Kashperko <george@znau.edu.ua>:
> >  - read pci revision id/vendor id (pci_read_config_word), if required
> > to decide if second window is sliding or sprom (actually rev_id should
> > be sufficient for that) read offset 0x0000 from bar0 offset to get
> > chipid register value
> 
> Could you say something about WIN1 and WIN2? What are they for, can we
> use them somehow separately? What do you mean by second window being
> SPROM? We read sprom without any special window magic:
> sprom[i] = ioread16(bus->mmio + bus->sprom_offset + (i * 2));
> 
> My understanding is limited to that:
> If we want to use device with CORE_ADDR and WRAP_ADDR we have to write
> CORE_ADDR to BAR0_WIN and WRAP_ADDR to BAR0_WIN2. Then we can use
> readl/writel.
> 

Historically layout of BAR0 for Broadcom pci(e) hosts differs depending
on pci(e) and chipcommon cores revisions. Unfortunately there are no
info from Broadcom on the host dev id, pci/chipco core revisions
correspondance but unlikely that we could have different hosts with same
PCI_REVISION but different sets of pci/chipco cores. Here I with my poor
english mean that pci host identification obtainable with
pci_read_config_dword PCI_REVISION should be sufficient to distinguish
between these BAR0 layouts.

Well, here you are:
1. PCI hosts with PCI buscores prior rev. 13 (8Kb window)
offset	size	type	description
0x0000	0x1000	sliding	controlled with BAR0_WIN1 register
0x1000	0x0800	fixed	SPROM
0x1800	0x0400	fixed	PCI core (core registers 0x0000 to 0x03FF range)
0x1C00	0x0400	fixed	PCI core (agent registers, 0x0C00 to 0x0FFF range)

2. PCI hosts with PCI buscores rev. 13 and above and PCIE with
Chipcommon rev. up to 31 (16Kb window)
offset	size	type	description
0x0000	0x1000	sliding	controlled with BAR0_WIN1 register
0x1000	0x1000	fixed	SPROM
0x2000	0x1000	fixed	PCI core
0x3000	0x1000	fixed	Chipcommon core

3. PCIE hosts with Chipcommon rev. 32 and above
offset	size	type	description
0x0000	0x1000	sliding	controlled with BAR0_WIN1 register
0x1000	0x1000	sliding	controlled with BAR0_WIN2 register
0x2000	0x1000	fixed	PCI core
0x3000	0x1000	fixed	Chipcommon core

As you can see even if PCI_REVISION can't feed us with guaranteed choice
of either of these 3 layouts we can distingiush between them easily like
following:

if (pci_is_pcie(dev)) {
	u32 chipid = ioread32(bar0_base + 0x3000);
	if (chipid & 0x10000000)
		/* AXI, Chipcommon rev. is 32+ */
		goto win_3_setup;
	else
		/* SB, Chipcommon rev. is <= 31 */
		goto win_2_setup;
} else {
	u32 idhi = ioread32(bar0_base + 0x1C00 + 0x03FC);
	if (((idhi & 0x00008FF0) >> 4) == 0x804)
		/* PCI core id */
		goto win_1_setup;
	else
		/* Some crap from SPROM area */
		goto win_2_setup;
}

Therefore we can setup PCI(e) host windows for backplane access prior to
scanning.

As for BAR0_WIN[12] registers, they point to physical base address on
backplane that will be mapped into corresponding 0x1000-size window. And
here again registers don't care what exactly you want to see there. Both
the windows can be controlled independently.

Finally, you might noticed we don't have SPROM in last 3rd layout. Thats
because it is in Chipcommon registers' space. For layouts #1 & #2 BAR0
range 0x1000 to 0x2000 is either mapped to actual SPROM or to SPROM
shadow in PCI core.

Have nice day,
George


