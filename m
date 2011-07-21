Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:40931 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1GUWfC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 18:35:02 -0400
Received: by pzk37 with SMTP id 37so2571796pzk.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jul 2011 15:35:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1310835342-18877-4-git-send-email-hauke@hauke-m.de>
References: <1310835342-18877-1-git-send-email-hauke@hauke-m.de>
	<1310835342-18877-4-git-send-email-hauke@hauke-m.de>
Date: Fri, 22 Jul 2011 00:35:01 +0200
Message-ID: <CACna6ryPABAx87b2+-gsTY5a5_qHTo61Otre-Pm+vYH8ad9hNg@mail.gmail.com> (sfid-20110722_003507_084706_9E44F9F4)
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

2011/7/16 Hauke Mehrtens <hauke@hauke-m.de>:
> @@ -159,5 +159,8 @@ static void bcma_pcicore_serdes_workaround(struct bcma_drv_pci *pc)
>
>  void bcma_core_pci_init(struct bcma_drv_pci *pc)
>  {
> +       if (pc->setup_done)
> +               return;
>        bcma_pcicore_serdes_workaround(pc);
> +       pc->setup_done = true;
>  }

This won't apply to the upstream driver_pci.c. Fix is obvious for me
and you, but could be nice to don't bother John/Ralf.


> +       /* Scan for devices (cores) */
> +       err = bcma_bus_scan_early(bus, &match, core_cc);

Could you update the comment by the way?

-- 
Rafał
