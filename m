Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:38414 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932344AbZHUVzq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 17:55:46 -0400
Received: by fxm17 with SMTP id 17so674269fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2009 14:55:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250867479.4600.11.camel@johannes.local>
References: <4A8EAFA6.9010608@gmail.com> <1250865255.4600.6.camel@johannes.local>
	<69e28c910908210741wd3bc391x311523f5b55fd4f1@mail.gmail.com>
	<1250865918.4600.9.camel@johannes.local> <69e28c910908210804h6181aab1w4a864392239aa1ac@mail.gmail.com>
	<1250867479.4600.11.camel@johannes.local>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 21 Aug 2009 23:55:27 +0200
Message-ID: <69e28c910908211455u5dcd70f0u94eab510ab91a69a@mail.gmail.com>
Subject: Re: Plans for an online meeting regarding Radiotap
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Richard Farina <sidhayn@gmail.com>,
	Mike Kershaw <dragorn@kismetwireless.net>,
	Sam Leffler <sam@freebsd.org>,
	Rafael Laufer <rlaufer@cs.ucla.edu>,
	Damien Bergamini <damien.bergamini@free.fr>,
	Sepherosa Ziehau <sepherosa@gmail.com>,
	"Thomas d'Otreppe" <tdotreppe@aircrack-ng.org>,
	Dave Young <hidave.darkstar@gmail.com>,
	radiotap <radiotap@radiotap.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	freebsd-mobile <freebsd-mobile@freebsd.org>,
	misc-openbsd <misc@openbsd.org>, tech-openbsd <tech@openbsd.org>,
	netbsd-net <tech-net@netbsd.org>,
	wireshark-dev <wireshark-dev@wireshark.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/8/21 Johannes Berg <johannes@sipsolutions.net>:
> On Fri, 2009-08-21 at 17:04 +0200, Gábor Stefanik wrote:
>
>> I've reworked RTS/CTS since then, just haven't got to sending a new
>> proposal yet. The current plan is as follows:
>>
>> TX_FLAGS & 0x0002: Use CTS
>> TX_FLAGS & 0x0004: Use RTS
>> TX_FLAGS & 0x0020: Disable RTS/CTS usage
>
> Seems a bit strange, wouldn't setting neither RTS nor CTS have the
> effect? Seems like 0x20 should rather be "use automatic and ignore the
> other bits". Anyway, not appropriate here, you should just bring a new
> proposal.

The point is that if all bits are 0, auto-setup is used. The problem
with my original proposal (using two bits) was that an all-zero value
had different effect than not including the TX flags field (and simply
swapping "none" and "auto" would result in an illogicality where what
would logically be "use both" would become "use neither" - just the
opposite of its logical meaning). Making 0x20 mean "Auto-select
RTS/CTS", interpreting all-zeros as "Use neither", would have the same
problem as my proposal - all-zeros is different from a missing field.
(An empty, zeroed field 15 should have no effect on the process,
behaving as if field 15 was not present in the header.)

>
>> If I remember correctly, I made an implementation for the Linux kernel
>> (a generator-side implementation) and one for Wireshark (a parser-side
>> implementation). Or should I make two generator-side implementations
>> according to the requirement (e.g. one for Linux, another for
>> OpenBSD)?
>
> No, that was ok, I just meant that therefore by definition it can't be a
> problem of lack of implementations.
>
> johannes
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
