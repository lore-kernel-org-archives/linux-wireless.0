Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:33318 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853AbZKKEPm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 23:15:42 -0500
Received: by iwn8 with SMTP id 8so655707iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 10 Nov 2009 20:15:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <19194.14704.375018.158963@gargle.gargle.HOWL>
References: <43e72e890911101640r69ad67c6l2e48250596c19d44@mail.gmail.com>
	<19194.14704.375018.158963@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 10 Nov 2009 20:15:26 -0800
Message-ID: <43e72e890911102015t3b429a61s353845c8b1d63@mail.gmail.com>
Subject: Re: ath9k rate control - busted
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Aeolus Yang <Aeolus.Yang@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 10, 2009 at 8:11 PM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> Luis R. Rodriguez wrote:
>> One way or another I think we should prioritize making ath9k work with
>> minstrel optionally on legacy networks at least for now, and see if we
>> can help Felix test/advance minstrel support for MCS rate support.
>>
>> The ath9k rate control code proves unmaintainable, not clearly
>> understood even with things like this:
>>
>> /* Update PER, RSSI and whatever else that the code thinks it is doing.
>>    If you can make sense of all this, you really need to go out more. */
>
> I'll send a patch removing this comment. :-)

Heh, that piece of text is valid though, it'd do more harm to the read
to remove it.

On a better note, I took the same AP (WRT610n v1) and same laptop with
AR9285 home and things are lot nicer. I get average about ~17 Mbit/s
and rcstat looks like this after a while:

Every 2.0s: cat rcstat

  Tue Nov 10 20:12:00 2009

 Rate         Success  Retries  XRetries PER

  1.0:       34      184       46       12
  2.0:      105       75       30        6
  5.5:       76       45       13        7
 11.0:      138       38        9        7
  6.0:        0        0        0        0
  9.0:        0        0        0        0
 12.0:      485       66       11        7
 18.0:     6291      408       50        7
 24.0:    13820     3550      665        9
 36.0:   581538    58714     4602        6
 48.0:    27661    47472    23272       48
 54.0:      336     1973     1200       47

This was with the same kernel, 2.6.31 on ubuntu 9.10 with the
linux-backport-modules package (which takes the 2.6.32-rc6 wireless
bits) with the AP configured to bg-only.

The distance to the APs has been the same in both tests. The only
difference was the noise. My results on my original post are from
using the card and AP at work, where there are easily over 60 APs in
my area. Granted, not what your average user would run into but it
still needs to be addressed.

  Luis
