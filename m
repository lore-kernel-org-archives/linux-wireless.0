Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33898 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbaKEJf7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2014 04:35:59 -0500
Received: by mail-wi0-f174.google.com with SMTP id d1so11804643wiv.13
        for <linux-wireless@vger.kernel.org>; Wed, 05 Nov 2014 01:35:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <03fc01cff8d3$38bdbb60$aa393220$@acksys.fr>
References: <CAOtFK_Ue0xjEaYY3qm0n2Tj=Hnu1dbphupmdZmiouVuGLnktoA@mail.gmail.com>
 <544E21D4.9020401@neratec.com> <CAOtFK_XWgBxPNy77XVDc1XbYUkdPSd-Q9wmREN2iL6A8bzFDoQ@mail.gmail.com>
 <544E5BCF.6000703@neratec.com> <CAOtFK_VG0Z3EkAfYNjiQGdcUp03Pa2SMP+-6cfdJMMT8Rg4Y6A@mail.gmail.com>
 <03fc01cff8d3$38bdbb60$aa393220$@acksys.fr>
From: Adrien Decostre <ad.decostre@gmail.com>
Date: Wed, 5 Nov 2014 10:35:17 +0100
Message-ID: <CAOtFK_Xhd8h=8rc2ed58BkrLjLbUfOgLEPzXqJqYQCNWRZWTLg@mail.gmail.com> (sfid-20141105_103605_667071_D89192AD)
Subject: Re: Questions regarding ath9k and new EN 300 328 regulation
To: voncken <cedric.voncken@acksys.fr>
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Cedric,

As Zefir pointed out the DFS engine is not responsible for the
compatibility with EN 300 328 v1.8.1. To my understanding, this is the
role of the CCA engine.
I think that the key patch is the one provided by Sujith Manoharan at
http://www.spinics.net/lists/linux-wireless/msg118665.html. This patch
is valid for modules using the AR9462. If your module uses another
chipset, you will probably need to apply this patch on the relevant
header file among the series of arxxxx_xpx_initvals.h header files.
To know which header is used by your module, I suppose you need to
check the "hw_version.macVersion" and "hw_version.macRev" read from
the module EEPROM and check the macros defined in
drivers/net/wireless/ath/ath9k/reg.h.

Hope this may help

Adrien

On Wed, Nov 5, 2014 at 9:33 AM, voncken <cedric.voncken@acksys.fr> wrote:
>         Hi Adrien,
>
>         In the file driver/net/wireless/ath/dfs_pattern_detector.c a comment specify the dfs detector is compliant with EN300 328 1.5.1.
>         Is it also compatible with E300 328 v1.8.1 ?
>
>         Thanks for your reply.
>
>         Cedric voncken.
>
>> -----Message d'origine-----
>> De : linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
>> owner@vger.kernel.org] De la part de Adrien Decostre
>> Envoyé : lundi 27 octobre 2014 19:24
>> À : Zefir Kurtisi
>> Cc : linux-wireless@vger.kernel.org; ath9k-devel@lists.ath9k.org
>> Objet : Re: Questions regarding ath9k and new EN 300 328 regulation
>>
>> Dear Zefir,
>>
>> Thanks a lot for these precisions, This makes thing more clear.
>>
>> There is still one thing unclear to me. If we do not consider working on the
>> DFS channels and that we only want to operate on channels 36, 40, 44 and 48
>> in EU. Do we still need to enable DFS flags in ath9k to comply with EN 300
>> 328 v1.8.1. I mean, is the same pulse detector algorithm used for DFS and for
>> the adaptivity tests on channels 36 to 48?
>>
>> Many thanks in advance for your answer.
>>
>> Best regards
>>
>> Adrien
>>
>>
>> On Mon, Oct 27, 2014 at 3:50 PM, Zefir Kurtisi <zefir.kurtisi@neratec.com>
>> wrote:
>> > On 10/27/2014 03:18 PM, Adrien Decostre wrote:
>> >> Hello Zefir,
>> >>
>> >> Thanks a lot for your answer. This helps me a lot.
>> >> If I correctly understand, the ability of ath9k to detect all pulses
>> >> may also depend of the platform performances. So on an embedded
>> >> platform with limited performances, we may observe more pulses losses
>> >> than on a more powerful platform. Is this a right statement?
>> >>
>> > No, there is no bottleneck in the platform performance. Presumed radar
>> > pulses are reported as RX_ERROR descriptors and even lower end
>> > embedded systems are able to handle the load. What makes the
>> > difference with the minimum pulse width is the chip DFS engine's
>> > ability to isolate and identify very short spikes as potential radar
>> pulses.
>> >
>> > This goes very deeply into material I had available under NDA while
>> > implementing the DFS support for ath9k. If you intend to work on that
>> > topic, I encourage you to contact the folks at QCA and join their 'NDA
>> > for Developers' program. The document you want to read is 'Baseband DFS 2
>> (Radar) Micro-Architecture'.
>> >
>> >> What about the CONFIG_ATH9K_DFS_CERTIFIED build options? Do we need
>> >> it to enable the detection of 0.5usec. pulses?
>> >>
>> > Yes, this driver specific flag (also available for 10k) you need to
>> > set to get the DFS detector built (not related to pulse width). It
>> > essentially shifts the responsibility of the product working in restricted
>> bands to you / the manufacturer.
>> >
>> >
>> >> Thanks in advance for your answer.
>> >>
>> >> Best regards
>> >>
>> >> Adrien
>> >>
>> >
>> > Good Luck,
>> > Zefir
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html
>
