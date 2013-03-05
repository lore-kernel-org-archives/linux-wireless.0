Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55722 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886Ab3CEXJo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Mar 2013 18:09:44 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1UD0zk-00036U-An
	for linux-wireless@vger.kernel.org; Wed, 06 Mar 2013 00:10:04 +0100
Received: from 37x112x132x11.dynamic.omsk.ertelecom.ru ([37x112x132x11.dynamic.omsk.ertelecom.ru])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 06 Mar 2013 00:10:04 +0100
Received: from mezin.alexander by 37x112x132x11.dynamic.omsk.ertelecom.ru with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 06 Mar 2013 00:10:04 +0100
To: linux-wireless@vger.kernel.org
From: Alexander Mezin <mezin.alexander@gmail.com>
Subject: Re: BCM4313 problems connecting to AP since 3.8
Date: Tue, 5 Mar 2013 23:06:47 +0000 (UTC)
Message-ID: <loom.20130306T000201-626@post.gmane.org> (sfid-20130306_000947_819795_D928A21E)
References: <CA+K+NcR9tExM9y-yjH_MB=ZpjeeakMW2GozECg4Pejp54nkCjA@mail.gmail.com> <513624B7.8010109@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@...> writes:

> 
> On 03/04/13 22:47, Ján Veselý wrote:
> > Hi,
> >
> > after upgrading to 3.8 I started running into a timeout problem on
> > BCM4313 wifi using brcmsmac driver (compiled as module, x86_64).
> > the card is unable to connect to ap after startup of resume.
> > Although it eventually connects it takes a long time (several minutes)
> > and dmesg log is spammed with:
> >
> > [  144.725431] wlan0: authenticate with 00:23:f8:8f:29:14
> > [  144.727786] wlan0: capabilities/regulatory prevented using AP
> > HT/VHT configuration, downgraded
> > [  144.727820] wlan0: direct probe to 00:23:f8:8f:29:14 (try 1/3)
> > [  144.930780] wlan0: direct probe to 00:23:f8:8f:29:14 (try 2/3)
> > [  145.133855] wlan0: direct probe to 00:23:f8:8f:29:14 (try 3/3)
> > [  145.336931] wlan0: authentication with 00:23:f8:8f:29:14 timed out
> > [  151.217245] wlan0: authenticate with 00:23:f8:8f:29:14
> >
> > (30+ times in some cases)

Had the same problem.
It seems that this commit introduces the bug: 
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?
id=b6fc28a158076ca2764edc9a6d1e1402f56e1c0c
I reverted it and now I have successful connection on first attempt. Linux 
3.8.2, BCM4313 802.11b/g/n Wireless LAN Controller.

