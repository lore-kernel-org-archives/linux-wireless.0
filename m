Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:44211 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab1GUXU2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 19:20:28 -0400
Received: by pzk37 with SMTP id 37so2619673pzk.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jul 2011 16:20:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1310835342-18877-5-git-send-email-hauke@hauke-m.de>
References: <1310835342-18877-1-git-send-email-hauke@hauke-m.de>
	<1310835342-18877-5-git-send-email-hauke@hauke-m.de>
Date: Fri, 22 Jul 2011 01:20:28 +0200
Message-ID: <CACna6rzf8=FpWn-=agGi4GESiw0-XG1QDS81fGTkV2J6dgtiOw@mail.gmail.com> (sfid-20110722_012031_778732_366C6EBB)
Subject: Re: [PATCH v2 04/11] bcma: add SOC bus
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
> This patch adds support for using bcma on a Broadcom SoC as the system
> bus. An SoC like the bcm4716 could register this bus and use it to
> searches for the bcma cores and register the devices on this bus.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Acked-by: Rafał Miłecki <zajec5@gmail.com>

Cleaning enum bcma_hosttype would be nice (see below), but we cal
always easily do this later.


> diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
> index 6bd7b7f..73fda1c 100644
> --- a/include/linux/bcma/bcma.h
> +++ b/include/linux/bcma/bcma.h
> @@ -16,6 +16,7 @@ enum bcma_hosttype {
>        BCMA_HOSTTYPE_NONE,
>        BCMA_HOSTTYPE_PCI,
>        BCMA_HOSTTYPE_SDIO,
> +       BCMA_HOSTTYPE_SOC,
>  };

I wanted to use BCMA_HOSTTYPE_NONE for SoCs (embedded systems), when I
decided to add it. As we decided SOC is better name than NONE, you
could drop it (NONE one).

-- 
Rafał
