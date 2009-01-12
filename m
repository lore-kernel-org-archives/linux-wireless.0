Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from a80-127-65-128.adsl.xs4all.nl ([80.127.65.128]:44236 "EHLO
	linux.wilsoft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbZALHrg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 02:47:36 -0500
From: "W. van den Akker" <listsrv@wilsoft.nl>
To: linux-wireless@vger.kernel.org
Subject: Re: Still problems to get ath9k in accessmode. Kernel hangs
Date: Mon, 12 Jan 2009 08:47:27 +0100
References: <200901011444.20333.listsrv@wilsoft.nl> <200901101226.16007.listsrv@wilsoft.nl> <4968FC02.6010708@erley.org>
In-Reply-To: <4968FC02.6010708@erley.org>
Cc: pat-lkml <pat-lkml@erley.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901120847.28201.listsrv@wilsoft.nl> (sfid-20090112_084740_448687_524BB9BD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 10 January 2009, you wrote:
> W. van den Akker wrote:
> > Did some futher testing to exclude problems....
> > The wlan0 and eth1 are both part of a bridge. I have removed the eth1
> > interface so the the eth1-driver cannot interfer with the ath9k driver.
> > Also no result. The server still locks.
> >
> > What is the right way to combine the eth1 and wlan0 into a bridge. Do I
> > even need  a bridge? The hostapd.config says I must define a bridge when
> > I use the nl80211driver interface.
> > The bridge has an IP adress, wlan0 and eth1 are in the same subnet.
> >
> > When hostapd is started I have some error-messages. Dont know if they can
> > hurt...
> > Failed to set CTS protect in kernel driver
> > Failed to set Short Slot Time option in kernel driver
> > Could not set preamble for kernel driver
>
> I use gentoo's init scripts, but my wlan0 and eth0 are both in a bridge
> (br0) and it works fine.  I don't get the CTS, Short Slot Time, or
> preamble kernel driver errors.  Perhaps you need to comment out a few
> lines in hostapd.conf?
>
> # preamble=1
>
> and I have:
>
> rts_threshold=2347
>
> I'll send you a direct e-mail with my .config and hostapd-wep.conf files
> to help with debugging.

I have used your config files for hostapd. Only change I have made is comment 
out the CONFIG_LIBNL20 because I have no lib for the debian lenny distro. But 
I dont think that will hurt much.
The error messages are gone.

However the system hangup still occurs. It looks like a DMA - ath9k related 
problem.

greetings
WIllem

-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

