Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64805 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab0G0Xv0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 19:51:26 -0400
Received: by pwi5 with SMTP id 5so674335pwi.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jul 2010 16:51:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimZsj6+cp6YGoVFn06NEQR3ZBCAheaWHaKPZNK6@mail.gmail.com>
References: <AANLkTimdDhHudW6_7Hwcf6UCumY_EgqGd7CLtmSgOzEz@mail.gmail.com>
	<AANLkTinfMiS=+dqi=azF2exJbkrSLYT9nN0aor7gff-Q@mail.gmail.com>
	<AANLkTi=Wy1r2C1xL289QQX10aVZaYfF7A1K8sd93ZXOd@mail.gmail.com>
	<AANLkTik2njXen5go8v2d8UPejC7THJiDJAvVunS7T5WU@mail.gmail.com>
	<AANLkTimZsj6+cp6YGoVFn06NEQR3ZBCAheaWHaKPZNK6@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 27 Jul 2010 16:51:06 -0700
Message-ID: <AANLkTinNAWZvDJVqL9U8AmJUNqV=fLLo4BN=dEfg=8cd@mail.gmail.com>
Subject: Re: regulatory hiccup
To: Andrew Lutomirski <luto@mit.edu>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 27, 2010 at 4:46 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> On Tue, Jul 27, 2010 at 7:33 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>>
>>> AFAICT net/wireless/reg.c ignores the last bit, and the other APs that
>>> work correctly here don't send country IEs.
>>
>> Can you provide the output of iw dev wlan0 scan from a fresh git
>> version of iw? That will actually tell me more than your listing.
>
> Unfortunately (or fortunately, I suppose) I can't, because a firmware
> upgrade for the AP removed the country IE entirely.  But if we're
> ignoring that data in 2.6.36 anyway, I'm not too worried.  If you
> really want that data, I can downgrade the AP the week after next and
> get it.
>
> (FWIW, it looks like the Intel driver on Windows refused to work with
> that AP but other people with macbooks could use it just fine.  I'd
> guess that no one would complain if Linux ignored country IEs that
> were transmitted outside their own "allowed" band, but this seems to
> be moot anyway.)

If sounds like the AP may have had an issue if the country IE is no
longer present and by the quick looks of your output it could have
been.. so unless you're confident of the AP I would think this is an
AP bug. If its a STA bug for sure though we certainly need to address
the issue on 2.6.35 even if 2.6.36 has a proper fix of ignoring the IE
altogether.

> P.S.  My thread about the AP that works on 2.6.34 but can't associate
> most of the time on 2.6.35-rc6 is the same AP but with the new
> firmware.

Wonderful.

 Luis
