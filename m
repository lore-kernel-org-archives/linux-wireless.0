Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:50783 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755713Ab0CDCOk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Mar 2010 21:14:40 -0500
Received: by wwa36 with SMTP id 36so1159126wwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Mar 2010 18:14:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B8E20CF.50109@users.sourceforge.net>
References: <4B8E20CF.50109@users.sourceforge.net>
Date: Thu, 4 Mar 2010 02:14:38 +0000
Message-ID: <3ace41891003031814r73d3b615x99d29e9cad1fd9c4@mail.gmail.com>
Subject: Re: rt2870 (staging kernel driver) crashes fatally
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "Daniele C." <legolas558@users.sourceforge.net>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You appear to have two issues - (1) the driver doesn't
hibernate/resume well, (2) there is some bad memory leak which causes
your system to run out of memory.

You did not mention issue (1) - that you were hibernating and resuming
(and expecting it to work, which it does not). For the latter, you
probably need to track down where the memory is leaking in the driver,
which is probably easier than tracking down the hibernate/resume
issue.

Good luck with tracking down the memory leak. (you do understand that
staging drivers are DIY - i.e. you try it only if you are willing to
look into fixing it yourself - I hope )

On Wed, Mar 3, 2010 at 8:41 AM, Daniele C.
<legolas558@users.sourceforge.net> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Hello,
>
> I am experiencing the documented crash after intense usage of the wi-fi device.
>
> Best regards,
> - --
>  Daniele C.
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.10 (GNU/Linux)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
>
> iQEcBAEBAgAGBQJLjiDOAAoJEON28As9epPAacQH/igJUCDKGDLzTnZhllzpR6yn
> jl7BusfXbpxwBUT6SYB4UQ8RobapmJCGpmcYMlbFTOnXRTK2WmiPrcbORqSBgZJV
> MZM8kvNoF9fJOg4Yr7mvwaMAaDBhYTPJFaCDcbHeLL06Sg1XLkiCaWnAQNk7IyVp
> cbVa031vh3lDrRJi7Xbcb2FLU7gxaKU9jc3dQcLWuBzu+Yte+Wn0ymbsVFDKFxQi
> 3ZObIaIVS3AQDS1seSielPfW3igP9blB05+S6XagGMsrolEE+yXG1SmAmk8+v7dl
> XHIOQCE51yPwjFQ5ExcM3slCPBUEczEupEj/Urngck8FXnJ8jIHD/AA8z6rIhEI=
> =Kees
> -----END PGP SIGNATURE-----
>
