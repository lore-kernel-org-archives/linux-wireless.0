Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:59540 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760698AbXGFRpU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2007 13:45:20 -0400
Date: Fri, 6 Jul 2007 10:32:30 -0700
To: Joerg Pommnitz <pommnitz@yahoo.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Forwarded: 32 character ESSID broken with WE-21
Message-ID: <20070706173230.GA19327@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <25290.17794.qm@web51406.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <25290.17794.qm@web51406.mail.re2.yahoo.com>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 05, 2007 at 11:17:47PM -0700, Joerg Pommnitz wrote:
> Jean,
> I'd like to make you aware of the following problem I encountered with WE-21. I'm not sure whether this is a driver issue or an issue of the generic WE code. Do you have any idea on how to proceed? This is a real problem for me, because my ESSIDs are MD5 hashes which just happen to be 32 characters long. I can't upgrade to a newer kernel with this problem unresolved.
>  
> --  
> Thanks and kind regards
>  
>        Joerg

	Yep, something like this was reported to me not long ago.
	The bug I'm talking about is only about *reading* a 32 char
ESSID, you can set it fine, it uses it, it's just that it's not
read. I know what causes it, I have a fix for it that will go in
2.6.23, and if people are happy with it we will backport it to earlier
kernels.
	Now, I've also seen various drivers doing some funky stuff
with ESSID, and trying to be too clever. So, there might be other bug
lurking around.
	Regards,

	Jean

> ----- Weitergeleitete Mail ----
> Von: Joerg Pommnitz <pommnitz@yahoo.com>
> An: linux-wireless@vger.kernel.org
> Gesendet: Donnerstag, den 5. Juli 2007, 12:36:16 Uhr
> Betreff: 32 character ESSID broken with WE-21
> 
> Hello all,
> for some time there was an open bug in Madwifi related to 32 charater ESSIDs.
> Doing some investigations I found that the same bug is present with an ipw2200bg
> WLAN interface and Linux 2.6.20 (I tried the Ubuntu-7.0.4 CD).
> 
> Please try
> iwconfig wlan0 essid 12345678901234567890123456789012
> vs
> iwconfig wlan0 essid 1234567890123456789012345678901
> 
> Using 32 character ESSIDs was fine with 2.6.18 (the last version I tested).
>  
> --  
> Regards
>  
>        Joerg
>  
> See http://news.gmane.org/gmane.linux.drivers.madwifi.devel for the Madwifi bug report
> See http://madwifi.org/ticket/930 for the Madwifi bug ticket
> 
> 
> 
> 
> 
> 
> 
>       __________________________________  Alles was der Gesundheit und Entspannung dient. BE A BETTER MEDIZINMANN! www.yahoo.de/clever
> 
> 
> 
> 
> 
> 
>       __________________________________  BE A BETTER INTERNET-GURU: Jetzt Frage stellen und einen von 44 iPods gewinnen! www.yahoo.de/clever
