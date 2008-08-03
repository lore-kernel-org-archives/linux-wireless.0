Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.232]:19637 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbYHCGDa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 02:03:30 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1660884rvb.1
        for <linux-wireless@vger.kernel.org>; Sat, 02 Aug 2008 23:03:30 -0700 (PDT)
Message-ID: <1ba2fa240808022303i4d330023i74f3cbb7e08083eb@mail.gmail.com> (sfid-20080803_080334_915240_4FE297B7)
Date: Sun, 3 Aug 2008 09:03:30 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: [PATCH 8/8] rfkill: add support for wake-on-wireless-packet
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, "Ivo van Doorn" <ivdoorn@gmail.com>
In-Reply-To: <20080803035559.GB6053@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br>
	 <1217700664-20792-9-git-send-email-hmh@hmh.eng.br>
	 <1217703723.8621.50.camel@johannes.berg>
	 <20080802192704.GB24253@khazad-dum.debian.net>
	 <1ba2fa240808021421h421fc362ib92660f7be4727f8@mail.gmail.com>
	 <20080803035559.GB6053@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 3, 2008 at 6:55 AM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Sun, 03 Aug 2008, Tomas Winkler wrote:
>> >> why does it interfere with suspend anyway?
>> >
>> > The class makes sure that all transmitters are blocked on suspend.  You'd
>> > have to ask Ivo for the reason, but AFAIK, it is for both safety and to help
>> > conserve power.
>>
>> This one is also on my list to remove. Suspend/Hibernate Resume
>> definitelly doesn't mean to rfkill radio on and off.. Driver should
>
> I *certainly* don't want the chip active during S3 or S4 unless I want WoWL
> active, so I do agree that just killing the radio is not enough.
>
>> This only creates conflicts as both driver and rfkill system are
>> trying to bring radio down
>
> No conflicts.  The wireless driver gets the request to shut the radio down
> BEFORE its suspend method is called (the class suspends first).  It will
> also get the request to enable/disable (whatever state it was in before the
> suspend) the radio AFTER its resume method is called (the class resumes
> after).

At least from iwlwifi perspective killing radio is not the same
operation as shutting down the card.
The intention is different if nothing it's really redundant operation
Tomas

>> RFKILL  IMHO shell track rfkill switches states and not to invent
>
> RFKILL is not about tracking, it is about *controlling*.

 I think driver controls the radio why need to add another entity for
that. I don't like this definition, But that's just wording I hope.


> Without the patch, rfkill always disables radios on suspend.  If they were
> enabled before the suspend, it will try to enable them on resume.  If they
> were disabled before the suspend, it will try to disable them on resume.
>
> That's well part of rfkill's role.  It might not be *needed* at all though,
> and if it is not, it is best to stop doing it.  If it is needed just in a
> few situations, we need to make it configurable (that's what my patch does).

I rather remove it, If the driver has D3 operation it should move card
to operation
which is much more complex that just not killing radio so it seams useless.
Tomas
