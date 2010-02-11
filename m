Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:61012 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547Ab0BKDDT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Feb 2010 22:03:19 -0500
Received: from de01smr02.am.mot.com (de01smr02.freescale.net [10.208.0.151])
	by az33egw02.freescale.net (8.14.3/az33egw02) with ESMTP id o1B336h0013525
	for <linux-wireless@vger.kernel.org>; Wed, 10 Feb 2010 20:03:06 -0700 (MST)
Received: from zmy16exm21.fsl.freescale.net (zmy16exm21.ap.freescale.net [10.211.3.25])
	by de01smr02.am.mot.com (8.13.1/8.13.0) with ESMTP id o1B3AQkv024658
	for <linux-wireless@vger.kernel.org>; Wed, 10 Feb 2010 21:10:27 -0600 (CST)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Subject: RE: [ath9k-devel] can ath9k run on linux 2.6.25
Date: Thu, 11 Feb 2010 11:03:23 +0800
Message-ID: <25E8B46727291E4EB5A1CB88CBC4284E0100A872@zmy16exm21.fsl.freescale.net>
In-Reply-To: <20100209171005.GB16748@tux>
References: <1265467103-11474-1-git-send-email-tom.leiming@gmail.com> <25E8B46727291E4EB5A1CB88CBC4284E0100A711@zmy16exm21.fsl.freescale.net> <43e72e891002081001td19c48cjf193ab8503255ee3@mail.gmail.com> <02a001caa94e$87b9bb80$972d3280$@kaist.ac.kr> <25E8B46727291E4EB5A1CB88CBC4284E0100A779@zmy16exm21.fsl.freescale.net> <20100209171005.GB16748@tux>
From: "Zhang Yanfei-B21500" <B21500@freescale.com>
To: "Luis R. Rodriguez" <lrodriguez@Atheros.com>
Cc: "Jinsung Lee" <ljs@netsys.kaist.ac.kr>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	<ath9k-devel@venema.h4ckr.net>, <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis
 
    I am porting the compat-wireless-2.6.32-3 to my powerpc platform
with 2.6.25 kernel.  After disable the LED marco in config.mk i have
compile it sucess. but when i load it , it show below error messages,
anyone can help on this?
the kernel modules manually load order is below: am i right ?
    1. rfkill_backport
     2. cfg_802.11
     3. mac80211
         4. ath
         5. ath9k
#insmod rfkill_backport.ko 
rfkill_backport: Unknown symbol dev_set_name
insmod: cannot insert 'rfkill_backport.ko': unknown symbol in module
(-1): No such file or directory
 
 i found that the compat-2.6.26 have the dev_set_name function, but
compat-2.6.25 don't have this. 
  In new kernel(2.6.29)  it's is device/base/core.c, then i try to copy
the function into my 2.6.25 kernel.
but it loss the 'kobject_set_name_vargs', here is the compile
information.
$drivers/base/core.c: In function 'dev_set_name':
$drivers/base/core.c:880: error: implicit declaration of function
'kobject_set_name_vargs'
 
Regards
Yanfei
 
> -----Original Message-----
> From: Luis R. Rodriguez [mailto:lrodriguez@Atheros.com] 
> Sent: Wednesday, February 10, 2010 1:10 AM
> To: Zhang Yanfei-B21500
> Cc: Jinsung Lee; Luis R. Rodriguez; 
> ath9k-devel@venema.h4ckr.net; linux-wireless@vger.kernel.org
> Subject: Re: [ath9k-devel] can ath9k run on linux 2.6.25
> 
> On Mon, Feb 08, 2010 at 10:36:09PM -0800, Zhang Yanfei-B21500 wrote:
> > Hi Guys
> > 
> >         Thanks a lot... Good news. Do you have porting to 2.6.25 
> > successfully with good performace also ?
> 
> It should be OK for the release without the multiqueue backported.
> Multiqueue was added back on the 2.6.32.4 release so 2.6.32.3 
> should be the last release without it. That I believe was 
> tested to work well with ath9k.
> 
> After that I have not received any feedback with respect to 
> the multiqueue backport. Feedback on that is appreciated.
> 
> > I am going to porting it to a powerpc board base on 2.6.25 kernel.
> 
> You should not need to do much but just test. Can you please 
> let me know.
> 
> This one should just work:
> 
> http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.
> 6.32/compat-wireless-2.6.32.3.tar.bz2
> 
> Newer stable kernels after this required multiqueue 
> backported which I gave a try but haven't gotten reports from 
> users on:
> 
> http://bombadil.infradead.org/~mcgrof/tmp/compat-wireless-2.6.
> 32.5-rc3.tar.bz2
> 
>   Luis
> 
> 
