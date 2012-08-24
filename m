Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:40565 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461Ab2HXXiw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2012 19:38:52 -0400
Received: by vcbfk26 with SMTP id fk26so2767231vcb.19
        for <linux-wireless@vger.kernel.org>; Fri, 24 Aug 2012 16:38:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5036660B.9020208@lwfinger.net>
References: <CAE3CJbkhmZ75gBjEToshQ2M9Xu7ciVrDtv8n2DVZepnhBoNt-Q@mail.gmail.com>
	<50365AC8.7030503@lwfinger.net>
	<CAE3CJbm5a0hZ8uWT8yU5Z8vbKX2HNwZ2uPUFULGA-3no1XFc_Q@mail.gmail.com>
	<5036660B.9020208@lwfinger.net>
Date: Fri, 24 Aug 2012 16:38:51 -0700
Message-ID: <CAE3CJbkodiw7kZ9F1PQrzZA2hSCF2PAwPAw-UHMwKhC2-6Ky2g@mail.gmail.com> (sfid-20120825_013856_214005_B5A1B629)
Subject: Re: Question about ath9k/mac80211 Driver
From: Patrick Connolly <pjc999@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Okay so I built "iw" version 0.9.22 successfully (after much grief).
The help page shows that "set bitrates" is now supported:

        dev <devname> set bitrates [legacy-<2.4|5> <legacy rate in Mbps>*]


 but when I try to use it I get:

       # iw dev wlan0 set bitrates legacy-2.4 1 2 5.5 11
       command failed: Operation not supported (-95)

...so what does this mean?  Is it "iw" or the driver that lacks the support?

-Patrick



On Thu, Aug 23, 2012 at 10:19 AM, Larry Finger
<Larry.Finger@lwfinger.net> wrote:
> On 08/23/2012 12:07 PM, Patrick Connolly wrote:
>>
>> Larry,
>>       Thanks for the response.  It appears that "set bitrates" is not
>> possible with my version of iw (0.9.19) - I get a big long help screen
>> when I try that command:
>>
>>   "iw dev wlan0 set bitrates legacy-2.4 1 2 5.5 11"
>> ...the options printed out for "set" are:
>
>
> You need to upgrade iw. I have 0.9.22, which has the set bitrates option.
>
> Once the rates are locked by mac80211, the beacons should only advertise
> 802.11b rates. (I have not tested that statement.)
>
> Larry
>
