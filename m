Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:59047 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656AbYHJVMN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Aug 2008 17:12:13 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] b43: Fix for SPROM coding error in Linksys WMP54G (BCM4306/3)
Date: Sun, 10 Aug 2008 23:11:38 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <489f0705.cL5monvdYRxgZaoz%Larry.Finger@lwfinger.net>
In-Reply-To: <489f0705.cL5monvdYRxgZaoz%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808102311.38899.mb@bu3sch.de> (sfid-20080810_231219_223606_FD614303)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 10 August 2008 17:19:33 Larry Finger wrote:
> The Linksys WMP54G (BCM4306/3) card in a PCI format has an SPROM coding
> error and needs the fix found for several other cards.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@kernel.org>		[2.6.25.x, 2.6.26.x]

Signed-off-by: Michael Buesch <mb@bu3sch.de>

> --------
> 
> John,
> 
> This is a fix for 2.6.27.
> 
> Larry
> ---
> 
>  main.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: wireless-testing/drivers/net/wireless/b43/main.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43/main.c
> +++ wireless-testing/drivers/net/wireless/b43/main.c
> @@ -4616,6 +4616,7 @@ static void b43_sprom_fixup(struct ssb_b
>  		pdev = bus->host_pci;
>  		if (IS_PDEV(pdev, BROADCOM, 0x4318, ASUSTEK, 0x100F) ||
>  		    IS_PDEV(pdev, BROADCOM, 0x4320, LINKSYS, 0x0015) ||
> +		    IS_PDEV(pdev, BROADCOM, 0x4320, LINKSYS, 0x0014) ||
>  		    IS_PDEV(pdev, BROADCOM, 0x4320, LINKSYS, 0x0013))
>  			bus->sprom.boardflags_lo &= ~B43_BFL_BTCOEXIST;
>  	}
> 
> 



-- 
Greetings Michael.
