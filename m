Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tebo.cs.washington.edu ([128.208.6.74]:44168 "EHLO
	tebo.cs.washington.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbYGIRlo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 13:41:44 -0400
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	=?ISO-8859-1?Q?Stefanik_G=E1bo@sc8-sf-spam2-b.sourceforge.net?=,
	ipw3945-devel@lists.sourceforge.net
Message-Id: <62912CC9-C856-4FD1-8642-8A80DB657468@cs.washington.edu> (sfid-20080709_194146_902955_489F51E0)
From: Dan Halperin <dhalperi@cs.washington.edu>
To: Maxim Levitsky <maximlevitsky@gmail.com>
In-Reply-To: <4874E68F.7090106@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed	delsp=yes
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [ipw3945-devel] [BUG] Two bugs in monitor mode, iwl3945
Date: Wed, 9 Jul 2008 10:04:53 -0700
References: <485F687C.1050407@gmail.com> <4874E68F.7090106@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I've observed that (often?) if you ifconfig wlan0 down before enabling =
=20
monitor/promisc mode, then it seems to not hang the system.

- -Dan

On Jul 9, 2008, at 9:25 AM, Maxim Levitsky wrote:

> Maxim Levitsky wrote:
>> I noticed two bugs:
>>
>> 1) Monitor mode hangs the system randomly, and what is interesting =20
>> that
>> this
>> bug disappears if I patch the driver with packet injection patch fro=
m
>> G=E1bor Stefanik.
>> I noticed this bug, after I removed his patch to see if it caused =20
>> some
>> problems.
>> Always reproducible, usually hangs just after airodump launch.
>>
>> 2) If I enable monitor mode regardless of injection patch, the =20
>> scanning
>> results got garbaged,
>> iwlist scan reports > 100 quality on most APs, or 0% quality on my
>> router, shows extremely low and hi power levels, like
>> -127dBm or 160 dBm, and those levels change rapidly.
>> This why I removed the injection patch, I suspected it, but this bug
>> appears to be not related to it.
> I noticed that exactly same bug happens if I enable promisc mode on =20
> the
> wlan0. Does this give any additional clue why this bug happens?
>
> Best regards,
> 	Maxim levitsky
>
> ---------------------------------------------------------------------=
----
> Sponsored by: SourceForge.net Community Choice Awards: VOTE NOW!
> Studies have shown that voting for your favorite open source project,
> along with a healthy diet, reduces your potential for chronic lamenes=
s
> and boredom. Vote Now at http://www.sourceforge.net/community/cca08
> _______________________________________________
> Ipw3945-devel mailing list
> Ipw3945-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/ipw3945-devel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (Darwin)

iEYEARECAAYFAkh077UACgkQy9GYuuMoUJ4dHwCfUMQxWYvXEHTtna7YYZoAHLYw
m4MAoMMjySqqdA8K5UmiwqE83Sr5K+L9
=3Dkx/b
-----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
