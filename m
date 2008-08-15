Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:39094 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbYHOAHT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2008 20:07:19 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] b43: Fix for another Bluetooth Coexistence SPROM Programming error for BCM4306
Date: Fri, 15 Aug 2008 02:06:42 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	tim.gardner@canonical.com, linux-wireless@vger.kernel.org
References: <48a4c657.3Vw2yJT7Y4Gu6f4D%Larry.Finger@lwfinger.net>
In-Reply-To: <48a4c657.3Vw2yJT7Y4Gu6f4D%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808150206.43088.mb@bu3sch.de> (sfid-20080815_020723_596298_F7ACC8C5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 15 August 2008 01:57:11 Larry Finger wrote:
> In trying to help users on the Ubuntu Bugzilla, I discovered another
> BCM4306 with the Bluetooth Coexistence programming error in the SPROM.
> 
> This patch is contingent on the one that added the Linksys device with
> subdevice code of 0x0014.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@kernel.org>
> ---
> 
> John,
> 
> This is more 2.6.27 material.

ACK

> Larry
> ---
> 
> Index: wireless-testing/drivers/net/wireless/b43/main.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43/main.c
> +++ wireless-testing/drivers/net/wireless/b43/main.c
> @@ -4615,6 +4615,7 @@ static void b43_sprom_fixup(struct ssb_b
>  	if (bus->bustype == SSB_BUSTYPE_PCI) {
>  		pdev = bus->host_pci;
>  		if (IS_PDEV(pdev, BROADCOM, 0x4318, ASUSTEK, 0x100F) ||
> +		    IS_PDEV(pdev, BROADCOM, 0x4320,    DELL, 0x0003) ||
>  		    IS_PDEV(pdev, BROADCOM, 0x4320, LINKSYS, 0x0015) ||
>  		    IS_PDEV(pdev, BROADCOM, 0x4320, LINKSYS, 0x0014) ||
>  		    IS_PDEV(pdev, BROADCOM, 0x4320, LINKSYS, 0x0013))
> 
> 
> 
> 



-- 
Greetings Michael.
