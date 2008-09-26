Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:32951 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755432AbYIZJBT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 05:01:19 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] b43: Fix Bluetooth Coexistence SPROM programming error for HP 12f8 version of BCM4306
Date: Fri, 26 Sep 2008 11:00:46 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <48dc6ecd.LsMPm/7J/Wp9iyzP%Larry.Finger@lwfinger.net>
In-Reply-To: <48dc6ecd.LsMPm/7J/Wp9iyzP%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809261100.47234.mb@bu3sch.de> (sfid-20080926_110132_296381_2EE29DDB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 26 September 2008 07:10:37 Larry Finger wrote:
> Yet another BCM4306 card with the Bluetooth Coexistence SPROM programming
> error has been found.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> John,
> 
> Owners of these cards keep crawling out of the woodwork. This is
> 2.6.28 material.

ACK.

> Larry
> ---
> 
> Index: wireless-testing/drivers/net/wireless/b43/main.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43/main.c
> +++ wireless-testing/drivers/net/wireless/b43/main.c
> @@ -4543,6 +4543,7 @@ static void b43_sprom_fixup(struct ssb_b
>  		pdev = bus->host_pci;
>  		if (IS_PDEV(pdev, BROADCOM, 0x4318, ASUSTEK, 0x100F) ||
>  		    IS_PDEV(pdev, BROADCOM, 0x4320,    DELL, 0x0003) ||
> +		    IS_PDEV(pdev, BROADCOM, 0x4320,      HP, 0x12f8) ||
>  		    IS_PDEV(pdev, BROADCOM, 0x4320, LINKSYS, 0x0015) ||
>  		    IS_PDEV(pdev, BROADCOM, 0x4320, LINKSYS, 0x0014) ||
>  		    IS_PDEV(pdev, BROADCOM, 0x4320, LINKSYS, 0x0013))
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 



-- 
Greetings Michael.
