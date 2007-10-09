Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2975 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbXJIVmZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 17:42:25 -0400
Date: Tue, 9 Oct 2007 17:18:22 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
	libertas-dev@lists.infradead.org
Subject: Re: [PATCH, take 2] libertas: fixes for slow hardware
Message-ID: <20071009211822.GA3175@tuxdriver.com> (sfid-20071009_224231_969695_64AAEF35)
References: <200710081118.27468.hs4233@mail.mn-solutions.de> <1191849316.2703.26.camel@localhost.localdomain> <200710091041.57159.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200710091041.57159.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 09, 2007 at 10:41:57AM +0200, Holger Schurig wrote:

> @@ -148,11 +148,11 @@ static int if_cs_poll_while_fw_download(
>  {
>  	int i;
>  
> -	for (i = 0; i < 500; i++) {
> +	for (i = 0; i < 1000; i++) {
>  		u8 val = if_cs_read8(card, addr);
>  		if (val == reg)
>  			return i;
> -		udelay(100);
> +		udelay(500);
>  	}
>  	return -ETIME;
>  }

10x the maximum delay?  Is this really necessary?  How did you
determine this was needed?

If it really is necessary, you need to change the "The host polls
the Card Status register for 50 ms..." comment in if_cs_prog_helper
as well.

John
-- 
John W. Linville
linville@tuxdriver.com
