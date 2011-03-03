Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34935 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab1CCHFu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 02:05:50 -0500
Received: by wyg36 with SMTP id 36so769186wyg.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 Mar 2011 23:05:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110226183542.75bc1786@realh.co.uk>
References: <20110224182022.57e32862@toddler>
	<20110224200203.GB17412@elie>
	<AANLkTiksoeKhMaFarSDVCbcDbZx6iWHkYzrg--1NcKKA@mail.gmail.com>
	<20110225144718.63550601@realh.co.uk>
	<AANLkTinu9NgnZZmieh2PU6e-iShOkapV9kcVe8YGtPHG@mail.gmail.com>
	<20110225165745.4860afe0@realh.co.uk>
	<20110226183542.75bc1786@realh.co.uk>
Date: Thu, 3 Mar 2011 12:35:49 +0530
Message-ID: <AANLkTin_pH4DLOW=7hahM-buwQyE7w4VcUr-fV1S7Jf=@mail.gmail.com>
Subject: Re: [ath9k-devel] ath9k causes lockups since kernel 2.6.35
From: Vivek Natarajan <vivek.natraj@gmail.com>
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

I used to give
 dmesg -n 8
along  with the above command and I get all the messages in the remote laptop.

>
> On the Ubuntu one I ran:
>
> nc -l -u 6666
>
> I've double-checked the addresses etc and verified that the link is up
> and the netconsole module is loaded, but no messages appear.
>

Can you please try this once again with the above debug level and see
if you get the crash log?

Vivek.
