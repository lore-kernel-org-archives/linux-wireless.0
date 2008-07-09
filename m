Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56468 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757119AbYGIHAu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 03:00:50 -0400
Message-ID: <48746220.8010703@gmx.de> (sfid-20080709_090103_831545_199ECE56)
Date: Wed, 09 Jul 2008 09:00:48 +0200
From: Helge Deller <deller@gmx.de>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] [PATCH] ath5k: convert LED code to use mac80211
 triggers
References: <20080622181134.GA26571@hash.localnet>	 <20080626023528.GA16068@hash.localnet> <g50s14$8n1$1@ger.gmane.org> <b6c5339f0807081922q2941a597m6e135fc7fb907fb@mail.gmail.com>
In-Reply-To: <b6c5339f0807081922q2941a597m6e135fc7fb907fb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland wrote:
> On Tue, Jul 8, 2008 at 7:08 PM, Helge Deller <deller@gmx.de> wrote:
>> I tested it against Linus' head version (it applied with minor
>> modifications) on my HP NC6000 laptop with this built-in Atheros card:
> [...]
>> Basically it works, but I think the sc->led_on in:
>>> +     sc->led_on = 0;  /* active low */
>> needs to be:
>>> +     sc->led_on = 1;  /* active high */
>> for the AR5212 in the HP laptop.
> 
> Thanks for the test!
> 
>> See also the changes to if_ath_pci.c in:
>>  http://madwifi.org/attachment/ticket/1018/led.patch
>> and
>>  http://madwifi.org/ticket/1018
>> for an old discussion about madwifi for LEDs in the HP box.
> 
> So current madwifi doesn't have this change unless I missed something?

Yes, the patch has not been applied yet.

>  It appears to use active-low leds in the current version regardless
> of the vendor.

Yes.

Helge
