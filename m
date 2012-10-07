Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:55784 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab2JGHsi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Oct 2012 03:48:38 -0400
Received: by mail-we0-f174.google.com with SMTP id t9so1933721wey.19
        for <linux-wireless@vger.kernel.org>; Sun, 07 Oct 2012 00:48:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1349043174-5371-1-git-send-email-hauke@hauke-m.de>
References: <1349043174-5371-1-git-send-email-hauke@hauke-m.de>
Date: Sun, 7 Oct 2012 09:48:36 +0200
Message-ID: <CACna6rw73feYKY7=5MyNjBeYjaC=Q+JmTeR7nfkmh9XxfKeJjw@mail.gmail.com> (sfid-20121007_094841_434295_5B7B5697)
Subject: Re: [PATCH] bcma: do not initialize deactivated PCIe cores
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/10/1 Hauke Mehrtens <hauke@hauke-m.de>:
> @@ -396,6 +391,11 @@ void __devinit bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc)
>
>         bcma_info(bus, "PCIEcore in host mode found\n");
>
> +       if (bus->sprom.boardflags_lo & BCMA_CORE_PCI_BFL_NOPCI) {
> +               bcma_info(bus, "This PCIE core is disabled and not working\n");
> +               return;
> +       }
> +

I wonder if this bit is also valid for client mode PCIe core. Maybe
this check should be put directly in bcma_core_pci_init?

-- 
Rafał
