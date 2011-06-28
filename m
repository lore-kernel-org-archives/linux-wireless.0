Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38622 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab1F1XQu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 19:16:50 -0400
Received: by pwj7 with SMTP id 7so463673pwj.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jun 2011 16:16:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E07B2B2.4060204@hauke-m.de>
References: <4E07B2B2.4060204@hauke-m.de>
Date: Wed, 29 Jun 2011 01:16:49 +0200
Message-ID: <BANLkTik_HdOn6Cw8VBROrKwo7csL9mTGAQ@mail.gmail.com> (sfid-20110629_011653_025516_AC137F66)
Subject: Re: Regression in ssb pcicore with SoC
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for reporting this and sorry for the problem.

W dniu 27 czerwca 2011 00:29 użytkownik Hauke Mehrtens
<hauke@hauke-m.de> napisał:
> I tried linux-3.0-rc4 on my Asus WL-500GP and got a kernel panic because
> of a data bus error. This was caused by this commit you made:
>
> commit af335a6cbc3dfcba64ad31561c0da563d1c43a2d
> Author: Rafał Miłecki <zajec5@gmail.com>
> Date:   Wed Apr 27 18:21:34 2011 +0200
>
>    ssb: pci: early fix for SPROM core index
>
>    Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>    Signed-off-by: John W. Linville <linville@tuxdriver.com>
>
> My device has an PCI controller, in host mode and this device does not
> have a sprom in its address space, so ssb_pcicore_fix_sprom_core_index()
> should be be called. I tried to find the same function in Broadcom
> source, but did not had success.
>
> In the Broadcom open source code the pci init is done in
> ./driver/nicpci.c and all calls to sporm are done through
> pcie_war_pci_setup() which is our ssb_pcicore_pcie_setup_workarounds()
> in ssb. I think ssb_pcicore_fix_sprom_core_index() should be called from
> somewhere in ssb_pcicore_pcie_setup_workarounds().
>
> Could you please explain what you want to fix in
> ssb_pcicore_fix_sprom_core_index() ?.
>
> I will have a closer look at it tomorrow evening.

I don't think we will find the same workaround in brcm80211 code.
Broadcom stripped a lot from their driver and we can not use it as
reference for old (especially SSB) devices.

When I was looking for fix for DMA errors I've noticed closed source
driver performing a read than could be translated to the following ssb
code:
pcicore_read16(pc, SSB_PCICORE_SPROM(0));

So I've found documentation of such a operation in Larry's e-mail
Message-ID: <4BB81CAD.10602@lwfinger.net> [0] and implemented it in
ssb.

Larry documented this single workaround without really telling when it
should be called. I've analyzed MMIO dumps of closed wl driver and put
proper call in the same place wl does it. That's it.


Unfortunately it appears that hostmode PCI(e) cores does not have
SPROM shadowed in PCI(e) core. This results in the problem you've
experienced.

I believe all we need to do is to stop executing various workarounds
for hostmode PCI(e) core. I'll offer a patch later today.


[0] http://www.mail-archive.com/b43-dev@lists.infradead.org/msg00049.html

-- 
Rafał
