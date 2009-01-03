Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from a80-127-65-128.adsl.xs4all.nl ([80.127.65.128]:55506 "EHLO
	linux.wilsoft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758824AbZACN4T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Jan 2009 08:56:19 -0500
Received: from hp4000.wilsoft.nl ([192.168.4.5])
	by linux.wilsoft.nl with esmtp (Exim 4.69)
	(envelope-from <listsrv@wilsoft.nl>)
	id 1LJ6z3-0001hn-T2
	for linux-wireless@vger.kernel.org; Sat, 03 Jan 2009 14:56:09 +0100
From: "W. van den Akker" <listsrv@wilsoft.nl>
To: linux-wireless@vger.kernel.org
Subject: Re: Still problems to get ath9k in accessmode. Kernel hangs
Date: Sat, 3 Jan 2009 14:56:07 +0100
References: <200901011444.20333.listsrv@wilsoft.nl>
In-Reply-To: <200901011444.20333.listsrv@wilsoft.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901031456.07988.listsrv@wilsoft.nl> (sfid-20090103_145623_103257_B4B762DC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 01 January 2009, you wrote:
> Jouni Malinen <j <at> w1.fi> writes:
> > I've never tested this with compat-wireless, but the wireless-testing
> > version seems to be working fine in my tests.
> >
> > > I have build the kernel, compiled the compat-wireless and did a make
>
> install.
>
> > > Make unload didnt work because some drivers were in use (mac80211).
> > > First problem arises, a rmmod ath9k hangs the kernel. No message of
> > > what
>
> so
>
> > > ever in the log or to stdout.
> >
> > Would you happen to have another host available for storing the logs? I
> > have been able to receive debug messages from most crashes with
> > netconsole (see Documentation/networking/netconsole.txt).
>
> I have tested on the server  with the latest wireless-testing the past days
> (2.6.28-rc9-wl). The wireless-testing looks somewhat more stable then the
> compat-wireless.
>
> I have also installed the netconsole module to watch any kernel prints.
> After running hostapd (v0.6.6) from command line the AP is up-and-running.
> Then if I connect with the laptop (tested it with kernel .26 and .28 on the
> laptop) I get a connection and can start a browser en explore the internet.
> If I start a second session (Kmail or second browser) the
> server hangs within a minute. Leaving again no trace on the console,
> hostapd-log or netconsole.
> Only way to reset the server is switch off the power.
> Its very frustrating because no information or what so ever can be found.
>
> If I connect an internet radio (Musicpal) to the server there is no
> problem. It stays stable for hours. If I also connect the laptop and start
> a browser the server hangs again within minuts.
>
> Its looks like if there is a second connection been set up the server
> hangs.
>

I have narrowed the problem down to the number of connections setted up in a 
short time.
If a system (notebook, internetradio or what so ever) setup a number of 
connections is a very short time (couple of seconds) the server crashes.

If I start Kmail on the notebook (with 5 mailboxes) the server crashes within 
seconds. Its always reproduceble. If I change the broadcast on the 
internetradio fast (for example 3 time with seconds between them) server 
hangs.

All the server hang ups dont leave a trace in log or console what so ever.

Hope this gives any additional information.

gr,
Willem

-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

