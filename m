Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:64705 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793AbaAFQrP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 11:47:15 -0500
Received: by mail-we0-f178.google.com with SMTP id u57so16170614wes.9
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jan 2014 08:47:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1389023718.5891.31.camel@jlt4.sipsolutions.net>
References: <1388869583-2767-1-git-send-email-chaitanya.mgit@gmail.com>
 <1389019739.5891.16.camel@jlt4.sipsolutions.net> <CABPxzY+yP1N1xLBHcVvMss_E=+2_3M95bQCEaxbkzvF+wbtnCQ@mail.gmail.com>
 <1389021322.5891.25.camel@jlt4.sipsolutions.net> <CABPxzY+En=1GxfBWHYgaSYSLv61MMYiFHz=hnJnsGnfBWpBJSQ@mail.gmail.com>
 <1389023718.5891.31.camel@jlt4.sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Mon, 6 Jan 2014 22:16:53 +0530
Message-ID: <CABPxzYJwEimPKw3YWi-zAZQCMTR4H2GzrLx+uyespD8ooHcW0g@mail.gmail.com> (sfid-20140106_174724_577181_BD84FC90)
Subject: Re: [PATCH] mac80211: Fix the buffer length in debugfs for smps
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 6, 2014 at 9:25 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2014-01-06 at 21:02 +0530, Krishna Chaitanya wrote:
>> On Mon, Jan 6, 2014 at 8:45 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> > On Mon, 2014-01-06 at 20:35 +0530, Krishna Chaitanya wrote:
>> >> On Mon, Jan 6, 2014 at 8:18 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> >> > On Sun, 2014-01-05 at 02:36 +0530, Chaitanya T K wrote:
>> >> >> This was blocking sending SMPS action frames
>> >> >> through debugfs.
>> >> >
>> >> > I don't see any issue here, explain.
>> >> >
>> >> > johannes
>> >> >
>> >> buflen includes the new line character as well, hence the comparison
>> >> strncmp fails for all combiantions.
>> >>
>> >> echo "static" > ieee80211/phyX/netdev\:wlanX/smps
>> >> Then
>> >>
>> >> buf=static\n
>> >> buflen=7
>> >>
>> >> But the comparison is with "static" which doesn't include "\n"
>> >> hence the comparison fails.
>> >
>> > Err, ok, so you can just do "echo -n static", right?
>> >
>> > And then your patch breaks the way it currently works, which is about
>> > the worst you can do.
>> >
>> Ok, if one works other fails.
>>
>> So instead why cant we use strlen(local_string)
>> instead of using buflen(remote). That way we can make sure we only
>> compare the characters we need and leave out the extra ones.
>
> It wouldn't fix the problem and would introduce a buffer overflow bug.
>
We can add some checks to make sure it doesn't overflow, but its not
worth it.

My intention is as most of the users are familiar with "echo" and
not "echo -n", its better to have a solution which works with "echo".

Also if we use buflen-1 and give "echo -n" it still works but problem is
it compares 1 less character.

Anyways either one is fine with me.

Thanks.
