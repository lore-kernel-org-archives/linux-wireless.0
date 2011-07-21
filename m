Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:39202 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891Ab1GUXEH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 19:04:07 -0400
Received: by pzk37 with SMTP id 37so2603222pzk.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jul 2011 16:04:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACna6ryPABAx87b2+-gsTY5a5_qHTo61Otre-Pm+vYH8ad9hNg@mail.gmail.com>
References: <1310835342-18877-1-git-send-email-hauke@hauke-m.de>
	<1310835342-18877-4-git-send-email-hauke@hauke-m.de>
	<CACna6ryPABAx87b2+-gsTY5a5_qHTo61Otre-Pm+vYH8ad9hNg@mail.gmail.com>
Date: Fri, 22 Jul 2011 01:04:06 +0200
Message-ID: <CACna6rxRjxEoh+nrkk_3w5p18DkOb8G2qFGsKkK3tmLCCM1ivQ@mail.gmail.com> (sfid-20110722_010413_946274_AA3453BB)
Subject: Re: [PATCH v2 03/11] bcma: add functions to scan cores needed on SoCs
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: ralf@linux-mips.org, linux-wireless@vger.kernel.org,
	linux-mips@linux-mips.org, jonas.gorski@gmail.com, mb@bu3sch.de,
	george@znau.edu.ua, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com,
	arnd@arndb.de, julian.calaby@gmail.com, sshtylyov@mvista.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 22 lipca 2011 00:35 użytkownik Rafał Miłecki <zajec5@gmail.com> napisał:
> 2011/7/16 Hauke Mehrtens <hauke@hauke-m.de>:
>> @@ -159,5 +159,8 @@ static void bcma_pcicore_serdes_workaround(struct bcma_drv_pci *pc)
>>
>>  void bcma_core_pci_init(struct bcma_drv_pci *pc)
>>  {
>> +       if (pc->setup_done)
>> +               return;
>>        bcma_pcicore_serdes_workaround(pc);
>> +       pc->setup_done = true;
>>  }
>
> This won't apply to the upstream driver_pci.c. Fix is obvious for me
> and you, but could be nice to don't bother John/Ralf.

Acked-by: Rafał Miłecki <zajec5@gmail.com>
After you rebase patch.

Please, be careful about this place. "git am" takes it as fuzzy and
applied in the incorrect place!

-- 
Rafał
