Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34408 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab1B1Fg5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 00:36:57 -0500
Received: by wwb22 with SMTP id 22so2639928wwb.1
        for <linux-wireless@vger.kernel.org>; Sun, 27 Feb 2011 21:36:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110226183542.75bc1786@realh.co.uk>
References: <20110224182022.57e32862@toddler>
	<20110224200203.GB17412@elie>
	<AANLkTiksoeKhMaFarSDVCbcDbZx6iWHkYzrg--1NcKKA@mail.gmail.com>
	<20110225144718.63550601@realh.co.uk>
	<AANLkTinu9NgnZZmieh2PU6e-iShOkapV9kcVe8YGtPHG@mail.gmail.com>
	<20110225165745.4860afe0@realh.co.uk>
	<20110226183542.75bc1786@realh.co.uk>
Date: Mon, 28 Feb 2011 11:06:54 +0530
Message-ID: <AANLkTi=ZWmWZWMBSdGX8S9EfiRyv3eKEU9P3n0bfDAuJ@mail.gmail.com>
Subject: Re: [ath9k-devel] ath9k causes lockups since kernel 2.6.35
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Tony Houghton <h@realh.co.uk>
Cc: Balasubramanian <senthilkumar@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jmalinen@atheros.com>,
	Jonathan Nieder <jrnieder@gmail.com>,
	ath9k-devel@lists.ath9k.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil@venema.h4ckr.net, Vivek Natarajan <vnatarajan@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 27, 2011 at 12:05 AM, Tony Houghton <h@realh.co.uk> wrote:
> On Fri, 25 Feb 2011 16:57:45 +0000
> Tony Houghton <h@realh.co.uk> wrote:
>
>> On Fri, 25 Feb 2011 21:37:25 +0530
>> Mohammed Shafi <shafi.ath9k@gmail.com> wrote:
>>
>> > On Fri, Feb 25, 2011 at 8:17 PM, Tony Houghton <h@realh.co.uk> wrote:
>> > >
>> > >> >> I haven't tried looking in logs because the crashes are so severe I
>> > >> >> don't think they'd be able to record anything useful.
>> >
>> > Can you please get those messages with net console ?
>
> No, I can't get it to work. I found a good guide at
> <http://www.novell.com/communities/node/4753/netconsole-howto-send-kernel-boot-messages-over-ethernet>
> and adapted it for Debian but absolutely no messages appear. I connected
> it via Ethernet to another netbook which runs Ubuntu. On the Debian one
> (the one with the problem I want to debug) I added to
> /etc/network/interfaces:
>
> auto eth0
> iface eth0 inet static
>    address 10.0.0.20
>    netmask 255.255.255.0
>
> and on Ubuntu:
>
> auto eth0
> iface eth0 inet static
>    address 10.0.0.10
>    netmask 255.255.255.0
>
> On the Debian one I added netconsole to
> /etc/modules and created /etc/modprobe.d/netconsole.conf containing:
>
> options netconsole netconsole=4444@10.0.0.20/eth0,6666@10.0.0.10/00:1E:68:DD:DB:40
>
> On the Ubuntu one I ran:
>
> nc -l -u 6666
>
> I've double-checked the addresses etc and verified that the link is up
> and the netconsole module is loaded, but no messages appear.
>
>> > > If I enable debugging is there a way to get it to sync to disc after
>> > > every message? I think the developers are going to need at least that
>> > > information to be able to track this down.
>> >
>> > Yes sure, that could narrow down the issue.
>>
>> I'll try that first because it should be easier than setting up net
>> console.
>
> I tried to reconfigure rsyslog to sync on each message but it didn't log
> anything useful :-(.

I will try to reproduce here with my platform.

> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>
