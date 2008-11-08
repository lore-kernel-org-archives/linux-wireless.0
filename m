Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:49881 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbYKHTyo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Nov 2008 14:54:44 -0500
Received: by wa-out-1112.google.com with SMTP id v27so904502wah.21
        for <linux-wireless@vger.kernel.org>; Sat, 08 Nov 2008 11:54:44 -0800 (PST)
Message-ID: <1ba2fa240811081154y4090c8cbk57cd9d975e86df1f@mail.gmail.com> (sfid-20081108_205451_170641_56726B56)
Date: Sat, 8 Nov 2008 21:54:44 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwconfig power timeout
Cc: "Kalle Valo" <kalle.valo@nokia.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1226142620.3610.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <87tzaiwn3z.fsf@nokia.com> <1226140536.3610.2.camel@johannes.berg>
	 <87prl6wk73.fsf@nokia.com> <1226142620.3610.6.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 8, 2008 at 1:10 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sat, 2008-11-08 at 13:06 +0200, Kalle Valo wrote:
>
>> I don't think so. If mac80211 responds with -EINVAL the error would be
>> something like this:
>>
>> $ iwconfig wlan0 power 5m
>> Error for wireless request "Set Power Management" (8B2C) :
>>     SET failed on device wlan0 ; Operation not permitted.
>
> That looks like -EPERM. But then iwconfig always had messed up error
> handling.
>
>> So the error seems to happen happen during argument parsing. Oh yeah,
>> and I even had a printk in mac80211 and it wasn't printed.
>
> Ok I'm convinced then :)
>
>> I'm going
>> to investigate this with gdb and try to understand how iwconfig really
>> parses the arguments.
>
> Well there is source code too ;)

There bugs in command parsing in v29 grab v30 beta where this bugs are fixed.
Tomas
