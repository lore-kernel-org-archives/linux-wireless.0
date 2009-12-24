Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:50240 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbZLXNOY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2009 08:14:24 -0500
Received: by iwn1 with SMTP id 1so5757780iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 24 Dec 2009 05:14:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <BLU113-W510F730A634F5AC6F406DBE7F0@phx.gbl>
References: <BLU113-W7635FBD7855C5257B07E4BE820@phx.gbl> <69e28c910912210614v31edf6cej9abeddb17ab130d@mail.gmail.com>
	<BLU113-W10113EE534A08128E43979BE820@phx.gbl> <4B2F9534.8020908@lwfinger.net>
	<BLU113-W211E9D9EFD5458887F8CFFBE820@phx.gbl> <646765f40912240348s64747772la4f80a945ab935d7@mail.gmail.com>
	<BLU113-W510F730A634F5AC6F406DBE7F0@phx.gbl>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 25 Dec 2009 00:14:02 +1100
Message-ID: <646765f40912240514o13f9b5e2ge594ff05a2cecded@mail.gmail.com>
Subject: Re: I need a card that works reasonably easily with Debain- reccs?
To: Mike Marchywka <marchywka@hotmail.com>
Cc: larry.finger@lwfinger.net, netrolller.3d@gmail.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 24, 2009 at 23:29, Mike Marchywka <marchywka@hotmail.com> wrote:
>> If you're interested, I can dig up the other bits and pieces I have
>> and send them to you. (None of these actually work, and the mrv8k
>> driver is the most complete.)
>
> Thanks but please don't go to any effort quite yet as this would be a learning
> curve for me - I can handle UART's on a Z80 and embedded systems but this may take a bit :)
> I would consider learning in background but it will take a while to create useful result.

I've got it all saved in a directory from my stalled driver effort, so
it isn't really that difficult.

As for the actual programming, this is worlds away from z80s and
embedded systems. (amusingly, I'm currently in the process of scoping
my skills in that direction, but I digress)





Before I get too far along, this is getting seriously off topic, this
list is for the development of wireless (802.11*) drivers for Linux,
some hardware queries, the occasional user issue, and not much more,
I'll give you what info I have, but most of your queries are best
suited to other lists.

>>> but now that you have me going I would like to find a driver for this too,
>>>
>>> 04:07.0 Communication controller [0780]: Conexant Systems, Inc. HSF 56k Data/Fax Modem [14f1:2f20]
>>
>> You'll have to ask elsewhere for info on that, it doesn't seem to be a
>> wireless card =)
>>
>> However, it does seem to be a PCI 56k Modem, which causes the big red
>> warning lights to flash: it's likely to be a "winmodem" which means
>> that it's a very *very* dumb card containing a trumped up DAC and ADC
>> and the absolute minimum hardware to talk on a POTS line. In terms of
>> drivers, this means that almost all the meat of a modem is implemented
>> in software, so the driver needs to handle most of the conversion from
>> data to be sent to the tones to send out on the POTS line *in
>> software*. There are a couple of winmodem drivers floating around out
>> there, but, as I understand it, there is no standard for these
>> devices, so every brand (and possibly model) works differently.
>
> Yeah, I've heard about the winmodems but I thought this was not one.
> It may in fact be easier to just use an old windoze machine to run junk like
> this- cygwin ssh on these things should make them useful...

If a 56k modem is useful to you.... =)

> Any idea how hard it would be to write a bluetooth driver to use my blackerry storm
> as a mouse? I could probably handle the BB code. LOL.

This is something you should ask on one of the bluetooth lists /
forums. I don't know where you could find these, but you might want to
start at http://www.bluez.org/

If I were doing it, I'd try to figure out some way of making the
blackberry emulate a serial mouse, and use RFCOMM to handle the
bluetooth side of things, and write a small app at the computer end to
make it all work together.

> As far as that goes, for a tethered or even bluetooth device, are there modem drivers for
> phones or if I want to use a cellular connection go usb modem? After all of this, I'm tempted
> to try to get back my amateur radio license and see if I can connect through a VHF repeater
> somewhere LOL.

For cellular phones, the usual method of connection involves AT style
commands over some type of serial port. E.g. most Nokia phones have
two modified serial ports under the battery. One talks a standardised
(but proprietary) protocol that's used for things like SMSs, contacts
and ringtones, the other works like any other serial modem, however
with an expanded command set to do useful cellular things. Check out
Gnokii and Gammu / Wammu for more information.

As for Bluetooth, there's the DUN and BNEP for encapsulating Ethernet
over Bluetooth. If your Linux distro is recent enough, you most likely
have everything you need already. (Network Manager handles most of
this for you.) But check out bluez at the address above, and I'm sure
they can point you in the right direction.

Good Luck!

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
