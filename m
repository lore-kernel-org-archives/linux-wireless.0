Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m-04.th.seeweb.it ([217.64.195.227]:32921 "EHLO
	m-04.th.seeweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab0CDKpE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Mar 2010 05:45:04 -0500
Message-ID: <4B8F8F10.5040404@users.sourceforge.net>
Date: Thu, 04 Mar 2010 11:44:32 +0100
From: "Daniele C." <legolas558@users.sourceforge.net>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Hin-Tak Leung <hintak.leung@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: rt2870 (staging kernel driver) crashes fatally
References: <4B8E20CF.50109@users.sourceforge.net> <3ace41891003031814r73d3b615x99d29e9cad1fd9c4@mail.gmail.com> <4B8F1C7F.7050305@lwfinger.net>
In-Reply-To: <4B8F1C7F.7050305@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

- -------- Original Message  --------
Subject: Re: rt2870 (staging kernel driver) crashes fatally
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Daniele C. <legolas558@users.sourceforge.net>
Date: Thu Mar 04 2010 03:35:43 GMT+0100 (CET)

> On 03/03/2010 08:14 PM, Hin-Tak Leung wrote:
>> You appear to have two issues - (1) the driver doesn't
>> hibernate/resume well, (2) there is some bad memory leak which causes
>> your system to run out of memory.
>>
>> You did not mention issue (1) - that you were hibernating and resuming
>> (and expecting it to work, which it does not). For the latter, you
>> probably need to track down where the memory is leaking in the driver,
>> which is probably easier than tracking down the hibernate/resume
>> issue.
>>
>> Good luck with tracking down the memory leak. (you do understand that
>> staging drivers are DIY - i.e. you try it only if you are willing to
>> look into fixing it yourself - I hope )
> 
> By generating your own kernel with MEMLEAK enabled, you should be able to see
> which data blob is being leaked. If you post that info, someone on this list
> should be able to help you find the cause.
> 
I will enable this feature so that next time it happens I will have such information.
However looks like bug is not triggering unless I first do a resume.

Thank you both for reviewing my logs and for the pointers.

Best regards,
- --
  Daniele C.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJLj48QAAoJEON28As9epPAqfIH/AktbatFnxAt6peijPxz64PV
jElSTuDYaieRRjKfoTQCVZoiSsf4f4sPAiqBR4E30zX7u9nWqqbaTIxLJjeC74Nr
fqfoFS2QBg8Ow5pLhs/pXUKR4c7g/x/QIQ7fzCAOUj/enirni2f6n9Gc8Tf8O1Mo
ejKXqqKeKPsnlNoBXtnB3ihE5sVp7O2PJZvxV3GCRy5KEmoIivPkrd3U4Lsc2pZG
86LOolgilto6I73/bdoU0CffiKyTENwpyJTMy1VFjqwOWLLn9ukuFbfyBd00Oo3W
uYX/SSCnouAKeAG0LzzTZMaYKOGkqJQzVLv/B0nhlcrrlk+xzWBNe04fxHamVo8=
=8q9G
-----END PGP SIGNATURE-----
