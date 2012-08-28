Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:46632 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab2H1Xsk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2012 19:48:40 -0400
Received: by vbbff1 with SMTP id ff1so6449725vbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Aug 2012 16:48:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAE3CJbmK4nF2gR56Rkrrd8qWoCuLot=XD-a9koWxCzcDeOrg8A@mail.gmail.com>
References: <CAE3CJbkhmZ75gBjEToshQ2M9Xu7ciVrDtv8n2DVZepnhBoNt-Q@mail.gmail.com>
	<50365AC8.7030503@lwfinger.net>
	<CAE3CJbm5a0hZ8uWT8yU5Z8vbKX2HNwZ2uPUFULGA-3no1XFc_Q@mail.gmail.com>
	<5036660B.9020208@lwfinger.net>
	<CAE3CJbkodiw7kZ9F1PQrzZA2hSCF2PAwPAw-UHMwKhC2-6Ky2g@mail.gmail.com>
	<50381437.7040903@lwfinger.net>
	<CAE3CJb=Zi12MVpBNGE3kOu00x3b1sZ7S67TCyBty3GkPbtoJXA@mail.gmail.com>
	<CAE3CJbmK4nF2gR56Rkrrd8qWoCuLot=XD-a9koWxCzcDeOrg8A@mail.gmail.com>
Date: Tue, 28 Aug 2012 16:48:39 -0700
Message-ID: <CAE3CJbmJ8JZzBKKJwYAL_6K_ossMK0HDCEkNLNfG-A4HzZSfzg@mail.gmail.com> (sfid-20120829_014920_416785_E9A340DF)
Subject: Re: Question about ath9k/mac80211 Driver
From: Patrick Connolly <patrickc@alumni.ucsd.edu>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Okay so using a compat-wireless build of 3.2.5-1, I get the command to
succeed (ie: no more error message) but when I look at the advertised
rates using "iwlist scanning" it certainly looks like the command does
not take effect.

COMMAND USED:
# iw dev wlan0 set bitrates legacy-2.4 1 2 5.5 11

RESULT OF "iwlist scanning":
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
                              9 Mb/s; 12 Mb/s; 18 Mb/s
                    Bit Rates:24 Mb/s; 36 Mb/s; 48 Mb/s; 54 Mb/s

  These Bit Rates are the same as they were before the "iw   set
bitrates" command.  I haven't actually captured the packets in
wireshark yet; I assume the output of "iwlist" is reliable enough.

  Can anyone comment on what is wrong?  Why don't the advertised rates change?

-Patrick


On Mon, Aug 27, 2012 at 7:54 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 08/27/2012 08:50 AM, Patrick Connolly wrote:
>>
>> So can anybody comment on whether kernel 2.6.32 is recent enough to
>> support "iw" version 0.9.22 ?
>
>
> It is not; however, you can build compat-wireless for that kernel and get
> code that will.
>
> Larry
>
>



>> On Fri, Aug 24, 2012 at 4:54 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>>> On 08/24/2012 06:38 PM, Patrick Connolly wrote:
>>>>
>>>> Okay so I built "iw" version 0.9.22 successfully (after much grief).
>>>> The help page shows that "set bitrates" is now supported:
>>>>
>>>>          dev <devname> set bitrates [legacy-<2.4|5> <legacy rate in
>>>> Mbps>*]
>>>>
>>>>
>>>>   but when I try to use it I get:
>>>>
>>>>         # iw dev wlan0 set bitrates legacy-2.4 1 2 5.5 11
>>>>         command failed: Operation not supported (-95)
>>>>
>>>> ...so what does this mean?  Is it "iw" or the driver that lacks the
>>>> support?
>>>
>>>
>>> I would think that your kernel is too old. What version are you running?
>>>
>>> Larry
>>>
>>>
