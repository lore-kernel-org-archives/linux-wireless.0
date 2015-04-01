Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.10]:19212 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbbDAQFt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2015 12:05:49 -0400
Date: Wed, 1 Apr 2015 18:05:43 +0200
From: Jakub =?UTF-8?B?S2ljacWEc2tp?= <moorray3@wp.pl>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	George Moutsopoulos <gmoutso@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: mediatek mt7630e and ksoftirqd CPU load
Message-ID: <20150401180543.2b33184d@north> (sfid-20150401_180553_288133_A076DCD9)
In-Reply-To: <5514377C.1070906@lwfinger.net>
References: <CABU1Ay8sVdLuHURHhmhsOf_aCVgvYnR_fw6_HyqLXziGmp3_fA@mail.gmail.com>
	<5514377C.1070906@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 26 Mar 2015 11:44:44 -0500, Larry Finger wrote:
> On 03/26/2015 11:12 AM, George Moutsopoulos wrote:
> > Dear developers,
> >
> > if this is not the right place to post this, sorry for the spam. I
> > haven't filed a bug report yet. Tell me if I should. I am not sure if
> > the problem is something kernel developers can solve.
> >
> > On a laptop ASUS TP500LN, I have a wireless pcie card mt7630e from
> > mediatek. It is a wifi/bluetooth combo.
> >
> > The driver is not in the kernel, but mediatek provides it for linux
> > from the download site
> > http://www.mediatek.com/en/downloads/
> >
> > The driver does not support kernel 3.16 and above. I followed the
> > instructions at
> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1220146
> >
> > The module compiles and loads succesfully. I followed the post by
> > tobias bora from the ubuntu bug. It compiles on kernel version 3.16
> > and above (tried up to 3.19).
> >
> > Like the rest on the ubuntu bug list, the wifi works and I connect
> > succesfully, but ksoftirqd gets 100% cpu on one of the cores.
> >
> > Shall I open a bug report? I have contacted mediatek twice but they
> > haven't replied. I hope it is something you can look at.  
> 
> Due to the fact that the driver is not in the kernel, it is not possible to file 
> a bug with anyone but the vendor.

Larry, did you notice that rt2x00/mt_linux.c does not have a GPL
header?  Do you think this can cause some legal problems if this code
or anything based on it is merged upstream?

> It is possible that someone on this list with Mediatek experience may be able to 
> help you, but there is no certainty. That is the downside of using a vendor driver.

I can try to help, sorry for a late response.

George, can you try https://github.com/kuba-moo/mt7630e ?  This is a
slightly cleaned up version of the vendor driver V3.14_20140625_v2.

I run it for a few hours and I cannot reproduce the issue you describe.
