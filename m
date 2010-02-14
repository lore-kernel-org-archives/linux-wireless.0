Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44720 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab0BNBAm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Feb 2010 20:00:42 -0500
Date: Sat, 13 Feb 2010 19:40:10 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Frederic Leroy <fredo@starox.org>
Cc: Hin-Tak Leung <hintak.leung@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Chris Mayo <aklhfex@googlemail.com>,
	linux-wireless@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: staging: No option to select rtl8192su in linux-2.6.33-rc2
Message-ID: <20100214004010.GB18815@tuxdriver.com>
References: <4B38A298.7070103@googlemail.com> <1262037590.16627.99.camel@localhost.localdomain> <3ace41890912310638x4387f73bvc7ba5e00d096ead7@mail.gmail.com> <20100213234456.5ae49b67@houba>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20100213234456.5ae49b67@houba>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 13, 2010 at 11:44:56PM +0100, Frederic Leroy wrote:
> Le Thu, 31 Dec 2009 14:38:35 +0000,
> Hin-Tak Leung <hintak.leung@gmail.com> a écrit :
> 
> > "nobody cares" is not entirely true - AFAIK, code in the staging area
> > is unreliable/unsuitable/"poor" code which serves the sole purpose of
> > being there for scavenging and references for re-write (because there
> > is no equivalent functionality, even alleged, in mainline); so people
> > looking at the staging code for ideas or references is welcomed. It is
> > just that there is no hints of any support or vague guarantee that any
> > of it works for any fitness of purpose. i.e. patches which fix
> > problems, or migrate functionality out of the staging area to
> > main-line, are welcomed, but questions and request for help on
> > understanding or making any of it work, are not.
> 
> I just bought an wireless usb key based on realtek 8192. If nobody is
> working on making a driver for it, I'd like to try.
> 
> But I am wondering where/how to start.
> 
> Should I follow the TODO file from Greg in staging :
> ( which seems to merge : rtl8192e  rtl8192su  rtl8192u )
> 
> TODO:
> - prepare private ieee80211 stack for merge with rtl8187se's version:
>   - remove rtl8192su's specific dead code
>   - cleanup ieee80211.h
>   - move rtl8192su's specific code out from ieee80211.h
>   - abstract rtl819su's specific code
>   - use list_for_each_safe() in ieee80211_crypto_deinit
> - switch to use shared "librtl" instead of private ieee80211 stack
> - switch to use LIB80211
> - switch to use MAC80211
> - switch to use EEPROM_93CX6
> - use kernel coding style
> - checkpatch.pl fixes
> - sparse fixes
> - integrate with drivers/net/wireless/rtl818x

This is a reasonable plan overall, although I might quibble with
the order.

> Or use rtl818x tree to start a new device ?

YMMV, but given the code I've seen for the Realtek drivers in staging I
might be inclined to start by forking rtl8180 and making the necessary
hardware changes from there.

Hth!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
