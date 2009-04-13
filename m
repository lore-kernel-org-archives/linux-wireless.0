Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f160.google.com ([209.85.217.160]:39037 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbZDMTA1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 15:00:27 -0400
Received: by gxk4 with SMTP id 4so4770695gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2009 12:00:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <69e28c910904130957o68d24c90pf49f44f8db60ece4@mail.gmail.com>
References: <20090410213958.GA12571@hell.pl> <20090411171955.76c48709@vroon.org>
	<20090413162439.GA30220@hell.pl> <69e28c910904130957o68d24c90pf49f44f8db60ece4@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 13 Apr 2009 12:00:11 -0700
Message-ID: <43e72e890904131200y16ab2b6q386682c977d97e08@mail.gmail.com> (sfid-20090413_210032_426717_602B8631)
Subject: Re: ath5k blind to nearby network
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: Grzegorz Nowakowski <krecik@hell.pl>, Tony Vroon <tony@vroon.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/4/13 G=C3=A1bor Stefanik <netrolller.3d@gmail.com>:
> On Mon, Apr 13, 2009 at 6:24 PM, Grzegorz Nowakowski <krecik@hell.pl>=
 wrote:
>> On Sat, Apr 11, 2009 at 05:19:55PM +0100, Tony Vroon wrote:
>>> -----BEGIN PGP SIGNED MESSAGE-----
>>> Hash: SHA1
>>>
>>> On Fri, 10 Apr 2009 23:39:58 +0200
>>> Grzegorz Nowakowski <krecik@hell.pl> wrote:
>>> > The symptom is that with both NetworkManager and WICD (and "iwlis=
t
>>> > <if> scanning") I don't see my home network on the list. =C2=A0I =
see all
>>> > other neighbouring networks around and I'm even able to connect i=
f
>>> > any is open.
>>>
>>> Please doublecheck your wireless regulatory setting. On the default
>>> "world" domain, it is unlikely you will be able to see networks on
>>> channel 13. You may well have chosen that specific channel because =
it
>>> was so quiet.
>>
>> Gee, that was so stoopid! =C2=A0You have guessed correctly, the chan=
nel in
>> use was indeed thirteenth and 13 was its number. =C2=A0After reconfi=
guring
>> the AP to use another one everything seems to be working fine.
>>
>> But that leaves me with the question: why Windows XP on Atheros and =
Linux
>> on Intel didn't have such trouble?
>
> Windows XP auto-configures the regulatory domain based on your
> regional settings.

Not quite.

>  Intel cards have semi-hardcoded regulatory
> information in their EEPROMs, which allows Linux to automatically
> select the right regulatory settings.

Sort of right.

> Atheros cards have no such
> firmware-level regulatory enforcement.

Wrong.

The right answer is the windows Atheros driver uses the EEPROM for
regulatory enforcement. The Intel drivers, depending on the card
through different regulatory domain SKUs, also use their EEPROM
information for regulatory compliance but are mostly always configured
to a sort of world roaming regulatory domain. Both the Intel windows
and Linux drivers make use of these regulatory domains.

The reason why you may not see Channel 13 on ath5k is the old ath5k
doesn't make use of the EEPROM to take advantage of setting your
regulatory environment.

As Bob indicated though and mainly thanks to his efforts, ath5k will
soon be doing this so you won't have to be specifying your regulatory
domain manually.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
