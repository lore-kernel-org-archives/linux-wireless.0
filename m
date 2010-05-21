Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:35359 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752645Ab0EUVfQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 May 2010 17:35:16 -0400
Message-ID: <4BF6FC91.9060109@dlasys.net>
Date: Fri, 21 May 2010 17:35:13 -0400
From: "David H. Lynch Jr." <dhlii@dlasys.net>
Reply-To: dhlii@dlasys.net
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org
Subject: carl9170 1.0.6 carl9170_tx_superdesc
References: <4BDC001F.9050202@dlasys.net> <4BDD2E05.40203@free.fr> <4BDD5EB3.7020802@dlasys.net> <201005021452.01101.chunkeey@googlemail.com>
In-Reply-To: <201005021452.01101.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	I need to track a new value for each tx frame only in the firmware.
	It appears I should be adding it to carl9170_tx_superdesc. But that 
structure seems to be used on both the Linux and firmware side, and I 
have not been able to successfully add to it without breaking something 
elsewhere either in the firmware or Linux driver or between them.
	Alternately I can create a private array to hold my data, but then I 
need to be able to find items in it using a carl9170_tx_superframe 
pointer. I am gathering that the cookie and queue number constitute a 
unique identifier, but that seems like alot of work to avoid adding a 
u16 to carl9170_tx_superdesc.
	Any other ideas about tracking a u16 value for each tx frame only on 
the firmware side without substantial complexity ?





-- 
Dave Lynch 					  	    DLA Systems
Software Development:  				         Embedded Linux
717.587.7774 	       dhlii@dlasys.net 	  http://www.dlasys.net
Over 25 years' experience in platforms, languages, and technologies 
toonumerous to list.

"Any intelligent fool can make things bigger and more complex... It 
takes a touch of genius - and a lot of courage to move in the opposite 
direction."
Albert Einstein
