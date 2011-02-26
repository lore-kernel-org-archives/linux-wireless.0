Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from jabba.london.02.net ([82.132.130.169]:49911 "EHLO mail.o2.co.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752452Ab1BZSfi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Feb 2011 13:35:38 -0500
Date: Sat, 26 Feb 2011 18:35:42 +0000
From: Tony Houghton <h@realh.co.uk>
To: Tony Houghton <h@realh.co.uk>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Mohammed Shafi <shafi.ath9k@gmail.com>,
	Jonathan Nieder <jrnieder@gmail.com>,
	ath9k-devel@lists.ath9k.org, Jouni Malinen <jmalinen@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Vivek Natarajan <vnatarajan@atheros.com>
Subject: Re: [ath9k-devel] ath9k causes lockups since kernel 2.6.35
Message-ID: <20110226183542.75bc1786@realh.co.uk>
In-Reply-To: <20110225165745.4860afe0@realh.co.uk>
References: <20110224182022.57e32862@toddler>
	<20110224200203.GB17412@elie>
	<AANLkTiksoeKhMaFarSDVCbcDbZx6iWHkYzrg--1NcKKA@mail.gmail.com>
	<20110225144718.63550601@realh.co.uk>
	<AANLkTinu9NgnZZmieh2PU6e-iShOkapV9kcVe8YGtPHG@mail.gmail.com>
	<20110225165745.4860afe0@realh.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 25 Feb 2011 16:57:45 +0000
Tony Houghton <h@realh.co.uk> wrote:

> On Fri, 25 Feb 2011 21:37:25 +0530
> Mohammed Shafi <shafi.ath9k@gmail.com> wrote:
> 
> > On Fri, Feb 25, 2011 at 8:17 PM, Tony Houghton <h@realh.co.uk> wrote:
> > >
> > >> >> I haven't tried looking in logs because the crashes are so severe I
> > >> >> don't think they'd be able to record anything useful.
> > 
> > Can you please get those messages with net console ?

No, I can't get it to work. I found a good guide at
<http://www.novell.com/communities/node/4753/netconsole-howto-send-kernel-boot-messages-over-ethernet>
and adapted it for Debian but absolutely no messages appear. I connected
it via Ethernet to another netbook which runs Ubuntu. On the Debian one
(the one with the problem I want to debug) I added to
/etc/network/interfaces:

auto eth0
iface eth0 inet static
    address 10.0.0.20
    netmask 255.255.255.0

and on Ubuntu:

auto eth0
iface eth0 inet static
    address 10.0.0.10
    netmask 255.255.255.0

On the Debian one I added netconsole to
/etc/modules and created /etc/modprobe.d/netconsole.conf containing:

options netconsole netconsole=4444@10.0.0.20/eth0,6666@10.0.0.10/00:1E:68:DD:DB:40

On the Ubuntu one I ran:

nc -l -u 6666

I've double-checked the addresses etc and verified that the link is up
and the netconsole module is loaded, but no messages appear.

> > > If I enable debugging is there a way to get it to sync to disc after
> > > every message? I think the developers are going to need at least that
> > > information to be able to track this down.
> > 
> > Yes sure, that could narrow down the issue.
> 
> I'll try that first because it should be easier than setting up net
> console.

I tried to reconfigure rsyslog to sync on each message but it didn't log
anything useful :-(.
