Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:63780 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158AbXIQQy7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2007 12:54:59 -0400
Date: Mon, 17 Sep 2007 09:54:35 -0700
To: "YOSHIFUJI Hideaki / ?$B5HF#1QL@" <yoshfuji@linux-ipv6.org>
Cc: davem@davemloft.net, jeff@garzik.org,
	Michael Buesch <mb@bu3sch.df>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: 2.6.23-rc regression: bcm43xx does not work after commit 4cf92a3c
Message-ID: <20070917165435.GA26926@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <20070917.042418.19962472.yoshfuji@linux-ipv6.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070917.042418.19962472.yoshfuji@linux-ipv6.org>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 17, 2007 at 04:24:18AM +0900, YOSHIFUJI Hideaki / ?$B5HF#1QL@ wrote:
> Hello.
> 
> With latest git tree, bcm43xx driver does not work.
> By bisect, I've found the commit 4cf92a3c is the first "bad" commit.
> 
>     [PATCH] softmac: Fix ESSID problem
> 
>     Victor Porton reported that the SoftMAC layer had random problem when setting the ESSID :
>     http://bugzilla.kernel.org/show_bug.cgi?id=8686 After investigation, it turned out to be
>     worse, the SoftMAC layer is left in an inconsistent state. The fix is pretty trivial.
>     
>     Signed-off-by: Jean Tourrilhes <jt@hpl.hp.com>
>     Acked-by: Michael Buesch <mb@bu3sch.df>
>     Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> After reverting this commit, the driver starts working again.
> 
> Regards,
> 
> -- 
> YOSHIFUJI Hideaki @ USAGI Project  <yoshfuji@linux-ipv6.org>
> GPG-FP  : 9022 65EB 1ECF 3AD1 0BDF  80D8 4807 F894 E062 0EEA

	Hi,

	Thanks for taking the time to track down this problem and
narrow it so well. This helps a lot to have such good bug reports.
	I'm surprised by your report, it does not make sense that it
would behave this way. This means that I don't understand the driver
as well I was believing. Or maybe your initialisation sequence is
peculiar. I will defer to the driver maintainers.
	Thanks again...

	Jean

