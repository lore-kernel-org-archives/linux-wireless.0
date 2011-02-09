Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58961 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab1BIQXD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 11:23:03 -0500
Received: by wyb28 with SMTP id 28so351082wyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Feb 2011 08:23:01 -0800 (PST)
Message-ID: <4D52BF9F.3010900@lwfinger.net>
Date: Wed, 09 Feb 2011 10:23:59 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: George Kashperko <george@znau.edu.ua>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: SSB AI support code ([RFC9/11] SSB modify irqflag treatment)
References: <1297258590.17400.37.camel@dev.znau.edu.ua> <1297262500.18053.36.camel@dev.znau.edu.ua>
In-Reply-To: <1297262500.18053.36.camel@dev.znau.edu.ua>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/09/2011 08:41 AM, George Kashperko wrote:
> From: George Kashperko <george@znau.edu.ua>
> 
> Modify irqflag routine to reuse tpsflag value rather than
> reading TPSFLAG register once again. Change default "not
> supported" value from 0x3F to -1.
> Signed-off-by: George Kashperko <george@znau.edu.ua>
> ---
>  drivers/ssb/driver_mipscore.c |    2 +-
>  drivers/ssb/ssb_sb.c          |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> --- linux-next-20110203.orig/drivers/ssb/driver_mipscore.c	2011-02-08 16:14:57.000000000 +0200
> +++ linux-next-20110203/drivers/ssb/driver_mipscore.c	2011-02-08 16:15:24.000000000 +0200
> @@ -75,7 +75,7 @@ unsigned int ssb_mips_irq(struct ssb_dev
>  	unsigned int irq;
>  
>  	irqflag = ssb_irqflag(dev);
> -	if (irqflag == 0x3f)
> +	if (irqflag == -1)
>  		return 6;
>  	ipsflag = ssb_read32(bus->mipscore.dev, SSB_IPSFLAG);
>  	for (irq = 1; irq <= 4; irq++) {
> --- linux-next-20110203.orig/drivers/ssb/ssb_sb.c	2011-02-08 16:14:57.000000000 +0200
> +++ linux-next-20110203/drivers/ssb/ssb_sb.c	2011-02-08 16:15:24.000000000 +0200
> @@ -175,10 +175,10 @@ static u32 ssb_irqflag_sb(struct ssb_dev
>  {
>  	u32 tpsflag = ssb_read32(dev, SSB_TPSFLAG);
>  	if (tpsflag)
> -		return ssb_read32(dev, SSB_TPSFLAG) & SSB_TPSFLAG_BPFLAG;
> +		return tpsflag & SSB_TPSFLAG_BPFLAG;
>  	else
>  		/* not irq supported */
> -		return 0x3f;
> +		return -1;
>  }
>  
>  static void ssb_core_ctl_flags_sb(struct ssb_device *dev, u32 mask,

This one does not apply with the following:

finger@larrylap:~/wireless-testing> quilt push
Applying patch patches/ssb_AI_9
patching file drivers/ssb/driver_mipscore.c
Hunk #1 succeeded at 85 (offset 10 lines).
can't find file to patch at input line 35
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|--- linux-next-20110203.orig/drivers/ssb/ssb_sb.c      2011-02-08
16:14:57.000000000 +0200
|+++ linux-next-20110203/drivers/ssb/ssb_sb.c   2011-02-08 16:15:24.000000000 +0200
--------------------------
No file to patch.  Skipping patch.
1 out of 1 hunk ignored
Patch patches/ssb_AI_9 does not apply (enforce with -f)

Larry
