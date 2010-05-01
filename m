Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:33314 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641Ab0EARHL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 May 2010 13:07:11 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?iso-8859-2?q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [PATCH] ssb: Implement fast powerup delay calculation
Date: Sat, 1 May 2010 19:07:05 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	"b43-dev" <b43-dev@lists.infradead.org>,
	Larry Finger <larry.finger@lwfinger.net>
References: <4BDC56D2.5060605@gmail.com> (sfid-20100501_162911_047976_71201E1E)
In-Reply-To: <4BDC56D2.5060605@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Message-Id: <201005011907.05603.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 01 May 2010 18:29:06 Gábor Stefanik wrote:
> +	ssb_write16(cc->dev, SSB_MMIO_POWERUP_DELAY, delay);
>   }
> 
>   void ssb_chipco_suspend(struct ssb_chipcommon *cc)
> Index: wireless-testing/include/linux/ssb/ssb_regs.h
> ===================================================================
> --- wireless-testing.orig/include/linux/ssb/ssb_regs.h
> +++ wireless-testing/include/linux/ssb/ssb_regs.h
> @@ -26,6 +26,7 @@
>   #define	SSB_EUART		(SSB_EXTIF_BASE + 0x00800000)
>   #define	SSB_LED			(SSB_EXTIF_BASE + 0x00900000)
> 
> +#define SSB_MMIO_POWERUP_DELAY	0x06A8

I think you are really confusing something here.
That register is a wireless core register and we already write it in b43.

-- 
Greetings, Michael.
