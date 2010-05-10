Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:40818 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781Ab0EJN7p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 09:59:45 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] ssb: Handle alternate SSPROM location
Date: Mon, 10 May 2010 15:59:35 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
References: <4be77726.2Sqkr0ilm/WZUNRg%Larry.Finger@lwfinger.net> (sfid-20100510_030206_444334_609A555A)
In-Reply-To: <4be77726.2Sqkr0ilm/WZUNRg%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201005101559.35829.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 10 May 2010 05:01:58 Larry Finger wrote:
> Index: wireless-testing/drivers/ssb/driver_chipcommon.c
> ===================================================================
> --- wireless-testing.orig/drivers/ssb/driver_chipcommon.c
> +++ wireless-testing/drivers/ssb/driver_chipcommon.c
> @@ -252,15 +252,17 @@ void ssb_chipcommon_init(struct ssb_chip
>  {
>  	u16 delay;
>  
> +	cc->status = 0;

Not needed. All data structures are zero'd by default.

-- 
Greetings, Michael.
