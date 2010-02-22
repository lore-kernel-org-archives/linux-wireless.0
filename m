Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m-04.th.seeweb.it ([217.64.195.227]:44188 "EHLO
	m-04.th.seeweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab0BVVXs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2010 16:23:48 -0500
Message-ID: <4B82F45A.3020100@users.sourceforge.net>
Date: Mon, 22 Feb 2010 22:17:14 +0100
From: "Daniele C." <legolas558@users.sourceforge.net>
Reply-To: legolas558 <legolas558@users.sourceforge.net>
MIME-Version: 1.0
To: Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org
Subject: Re: RF killswitch (or worse) is enabled after resume from suspend
References: <4B72F3D2.1050309@users.sourceforge.net> <1266730789.16986.21.camel@debian>
In-Reply-To: <1266730789.16986.21.camel@debian>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

- -------- Original Message  --------
Subject: Re: RF killswitch (or worse) is enabled after resume from suspend
From: Zhu Yi <yi.zhu@intel.com>
To: Daniele C. <legolas558@users.sourceforge.net>
Date: Sun Feb 21 2010 06:39:49 GMT+0100 (CET)

> On Thu, 2010-02-11 at 01:58 +0800, Daniele C. wrote:
>> I am using kernel 2.6.33-rc7-00064-gac73fdd (latest git of linus'
>> tree) and I have been experiencing an issue for more than a month now.
>>
>> When the computer resumes from suspend (not hibernation), the RF
>> killswitch seems ON (although dmesg does not say this, so it is just a
>> deduction of mine). If I unload ipw2100 and reload it, the killswitch
>> is disabled and wifi can work regularly.
> 
> Can you read the ipw2100 sysfs entry "rf_kill" to confirm the rf kill
> state when this happens? Please also attach your dmesg.
> 
It's always zero.

A recent dmesg is here:
http://bugzilla.kernel.org/attachment.cgi?id=25047
sudo lspci -v:
http://bugzilla.kernel.org/attachment.cgi?id=25021

>> Now I am experiencing a worse issue: the 2nd time I do this, reloading
>> the module doesn't work anymore, and neither using my modified version
>> of fsam7400 which did the trick in the past.
>>
>> It appears to be an issue of 2.6.33 kernels. Shall I contact some
>> kernel list? 
> 
> You can include linux-wireless@vger.kernel.org if you want. If you can
> do some git bisect, that would be very helpful to identify the
> regression.
> 
OK, I will go along the git bisect path if possible, but problem is really strange, since only reboots seem to fix it.
Nobody else experiencing issues with ipw2100?

Best regards.
- --
  Daniele C.

> Thanks,
> -yi  	
> 
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJLgvRaAAoJEON28As9epPA/TgH/Ru50uzYZyTJxg/74OySxAJy
8T2uNFKyUit+sGpXLdCJMAstgnKyjMHuYX7xOPr4q+RrOPxJUfnY9mFcEL09DH5Z
GLxGeh4FWwaQl8gpsFFYxGQ5l1QpoCclYgRdzx5/SdqtXnwryLIEeP8ejUY+54Zp
BdcGLmIjhV9MMCrVRFn6Erf/5UBnJ1JkR2NJf30cwRymvhjcCWFK72tAzNZ7rSrm
q0+WxbSWIyDUT2It+8+a6UTqhvUI6DwuJfDmH6OGMfZV+DlskSoV9Zst5xAqgltt
O+0uXa4p20b87Ed3N303B7Zxc/Vx1nfm6WOBWuYoln+DgBrBzqQAMP8HJe2cSlk=
=Dx9Q
-----END PGP SIGNATURE-----
