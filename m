Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:42481 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751765AbZBQVKO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2009 16:10:14 -0500
Message-ID: <499B27A4.30708@lwfinger.net> (sfid-20090217_221018_967921_3F7CA2F5)
Date: Tue, 17 Feb 2009 15:09:56 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8187 cannot fix rate
References: <35879.82.152.175.172.1234904444.squirrel@www.phantomjinx.co.uk>
In-Reply-To: <35879.82.152.175.172.1234904444.squirrel@www.phantomjinx.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

P.G. Richardson wrote:
> Hi guys,
> 
> More experimentation with my rtl8187. With some playing around with the
> access point location, I think I may have stumbled on a good position.
> 
> Anyway ...
> 
> I noticed that the rate reported by iwconfig only ever gets to 11Mb/s
> despite the fact that I now have a signal level of 90/100 - 100/100. I
> found that I can do
> 
> iwconfig wlan0 rate 54M
> 
> but it seems that although the card is still associated networking doesnt
> work (pings fail). If I change it back to auto
> 
> iwconfig wlan0 rate auto
> 
> then iwconfig reports 11Mb/s again and pinging resumes fine.
> 
> Is there any chance that the driver is incorrectly reporting its mode or
> something in that the rates it displays bear the hallmarks of a b card
> rather than g?
> 
> Using the compat-wireless snapshot from 9/2/2009
> Mandriva 2.6.27.10-desktop586-1mnb

What rate-adjustment method are you using? The output of dmesg will tell. If you
are using minstrel, then you should post the contents from the following commands:

STATS=$(find /sys -name rc_stats)
echo $STATS
sudo cat $STATS

Larry
