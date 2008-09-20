Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:38866 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbYITVYD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Sep 2008 17:24:03 -0400
Received: by gxk9 with SMTP id 9so1866025gxk.13
        for <linux-wireless@vger.kernel.org>; Sat, 20 Sep 2008 14:24:00 -0700 (PDT)
Message-ID: <43e72e890809201424k370756d1mffc9efa7a1d7fe34@mail.gmail.com> (sfid-20080920_232408_593618_1588DE6A)
Date: Sat, 20 Sep 2008 14:24:00 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Steven Noonan" <steven@uplinklabs.net>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5, rc6, probably others)
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Senthilkumar Balasubramanian"
	<Senthilkumar.Balasubramanian@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	"Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <f488382f0809201418j66a813a0m4c0a5843f0dfc87a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <f488382f0809181604l105535bkceecd44c590bc88b@mail.gmail.com>
	 <20080919182322.GB7027@tesla>
	 <alpine.LNX.2.00.0809191630090.14961@alcarin.uplinklabs.net>
	 <20080919235305.GD11665@tesla>
	 <f488382f0809191701u2dbf8d22n6015c9f1f23c73be@mail.gmail.com>
	 <43e72e890809191813n95579f5h83e92b0ba1f95a44@mail.gmail.com>
	 <f488382f0809192029w601e0e72x5c3affc3dbe65118@mail.gmail.com>
	 <f488382f0809200821m6fe355feu2d9fb99ac3c7f712@mail.gmail.com>
	 <43e72e890809201357y1413a151r85aad7cc16440cf4@mail.gmail.com>
	 <f488382f0809201418j66a813a0m4c0a5843f0dfc87a@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 20, 2008 at 2:18 PM, Steven Noonan <steven@uplinklabs.net> wrote:
> On Sat, Sep 20, 2008 at 1:57 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> So here's what we need to do -- try to zero on in what causes this IRQ
>> storm.
>
> How is the best way to approach this? I assume ATH_DBG_INTERRUPT and
> pray like hell my /var partition doesn't fill up first? Maybe I'll
> just symlink /var/log/messages to a file on a substantially larger
> pattition...

Yeah see the other e-mail I sent.

>> Most likely its some strange event that triggers it, perhaps
>> some sort of noise which makes the device try to adapt and hits a path
>> we are not handling correctly yet. Can you provide the initial log of
>> when ath9k gets loaded? This tells us what card it is, like AR5416 or
>> AR9280, etc.
>
> [10238.347956] ath9k: 0.1
> [10238.348028] vendor=8086 device=27d2
> [10238.348033] ath9k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [10238.348050] ath9k 0000:03:00.0: setting latency timer to 64
> [10238.480781] phy1: Selected rate control algorithm 'ath9k_rate_control'
> [10238.483320] phy1: Atheros 5416: mem=0xffffc20000060000, irq=17
>
> It claims to be a 5416, but I was under the impression that it was the
> 5418 that came with the MacBook Pro.

lspci output is outdated, we have submitted some new updates to it.
The output of the driver should be the one you can rely on for chipset
information for now. The problem is besides the PCI device ID there is
also EEPROM information which further identifies the chipset like
devices can be dual band (2 GHz and 5 GHz capable) and some other
single band -- using the same PCI device:vendor ID. So for now we've
tried to update the PCI id stuff (not sure when it'll be merged) to
tell your "family chipset" and in parens the MAC or known model. It
can still use some cleanup but yeah, hope this helps understand this a
little better. You can see more info on this here:

http://wireless.kernel.org/en/users/Drivers/ath9k#supportedchips

  Luis
