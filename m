Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37421 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827AbaAFPcf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 10:32:35 -0500
Received: by mail-wi0-f170.google.com with SMTP id hq4so2877555wib.3
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jan 2014 07:32:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1389021322.5891.25.camel@jlt4.sipsolutions.net>
References: <1388869583-2767-1-git-send-email-chaitanya.mgit@gmail.com>
 <1389019739.5891.16.camel@jlt4.sipsolutions.net> <CABPxzY+yP1N1xLBHcVvMss_E=+2_3M95bQCEaxbkzvF+wbtnCQ@mail.gmail.com>
 <1389021322.5891.25.camel@jlt4.sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Mon, 6 Jan 2014 21:02:13 +0530
Message-ID: <CABPxzY+En=1GxfBWHYgaSYSLv61MMYiFHz=hnJnsGnfBWpBJSQ@mail.gmail.com> (sfid-20140106_163238_421834_DBF63FCA)
Subject: Re: [PATCH] mac80211: Fix the buffer length in debugfs for smps
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 6, 2014 at 8:45 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2014-01-06 at 20:35 +0530, Krishna Chaitanya wrote:
>> On Mon, Jan 6, 2014 at 8:18 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> > On Sun, 2014-01-05 at 02:36 +0530, Chaitanya T K wrote:
>> >> This was blocking sending SMPS action frames
>> >> through debugfs.
>> >
>> > I don't see any issue here, explain.
>> >
>> > johannes
>> >
>> buflen includes the new line character as well, hence the comparison
>> strncmp fails for all combiantions.
>>
>> echo "static" > ieee80211/phyX/netdev\:wlanX/smps
>> Then
>>
>> buf=static\n
>> buflen=7
>>
>> But the comparison is with "static" which doesn't include "\n"
>> hence the comparison fails.
>
> Err, ok, so you can just do "echo -n static", right?
>
> And then your patch breaks the way it currently works, which is about
> the worst you can do.
>
Ok, if one works other fails.

So instead why cant we use strlen(local_string)
instead of using buflen(remote). That way we can make sure we only
compare the characters we need and leave out the extra ones.
