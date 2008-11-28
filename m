Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mxm.seznam.cz ([77.75.72.45]:43169 "EHLO mxm.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164AbYK1ALp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2008 19:11:45 -0500
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1227827947.7559.38.camel@johannes.berg>
Date: Fri, 28 Nov 2008 01:11:33 +0100 (CET)
To: linville@tuxdriver.com
From: =?iso-8859-2?Q?Carlos=20Lau=E9?= <CarlosL@seznam.cz>
Subject: =?us-ascii?Q?=5BPATCH=5D=20wireless=2Dregdb=3A=20Update=20regulatory=20rules=20for=20Czech=20Republic=20=28CZ=29=20on=205GHz?=
Mime-Version: 1.0
Message-Id: <856.1518-15019-1010599801-1227831093@seznam.cz> (sfid-20081128_011149_075177_C977D6E2)
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Hi,
> 
> > There seems to be outdated information in the regulatory database for
> > CZ. According to the new regulatory laws, which can be found at
> > http://www.ctu.cz/1/download/Opatreni obecne
> > povahy/VO_R_12_08_2005_34.pdf (page 2) and
> > http://www.ctu.cz/1/download/OOP/Rok_2007/VO_R_10_03_2007_4.pdf (page
> > 3), for 5GHz the table should look like this:
> > 
> > 5150.000 - 5250.000 ; 40.000 ; NO-OUTDOOR ; N/A ; 23.00 (200.00 mW)
> > 5250.000 - 5350.000 ; 40.000 ; NO-OUTDOOR,DFS ; N/A ; 23.00 (200.00 mW)
> > 5470.000 - 5725.000 ; 40.000 ; DFS ; N/A ; 30.00 (1000.00 mW)
> > 5725.000 - 5875.000 ; 40.000 ;  ; N/A ; 14.00(25.00 mW)
> 
> Care to send a patch? Download
> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-regdb.git;a=blob_plain;f=db.txt;hb=HEAD
> and edit as appropriate.
> 
> > if there are any difference between values in dBm and in mW, please
> > consider the value in mW as the right value. 
> 
> As you can see in the rules for DE, you can give the values in mW too:
> 
>         (2400 - 2483.5 @ 40), (N/A, 100 mW)
> 
> I encourage you to add a comment, so that the CZ entry looks like this:
> 
> # Data from
> #
> http://www.ctu.cz/1/download/Opatreni%20obecne%20povahy/VO_R_12_08_2005_34.pdf
> # and http://www.ctu.cz/1/download/OOP/Rok_2007/VO_R_10_03_2007_4.pdf
> country CZ:
> 	(2402 - 2482 @ 40), (N/A, 20)
> ...
> 	(5250 - 5350 @ 40), (N/A, 200 mW), NO-OUTDOOR, DFS
> etc.
> 
> > * The values for 5250-5350MHz and 5470-5875MHz are valid only if the
> > device is capable of automatic output power regulation (ie.iwconfig
> > wlan0 power auto). If there isn't a way to assure this, then the
> > maximum power output limit must be set to a value 3dB lower for ranges
> > 5250-5350MHz (20dBm) and 5470-5875MHz.(27dBm).
> 
> Hmm. I don't think we have a way to capture this right now, should
> probably use the lower values then.
> 
> johannes
> 
OK, I thought we cannot guarantee the automatic power regulation, using lower values for now, it would be nice to implement the required mechanism to assure tx power regulation, but then how to define the two values? two tables, or a flag like "NO-APC -3" indicating that, without tx power regulation, there is a lower limit for tx power? 
And the patch:

 
