Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:34800 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732AbaCNWMh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Mar 2014 18:12:37 -0400
Received: by mail-wi0-f170.google.com with SMTP id n15so1221300wiw.5
        for <linux-wireless@vger.kernel.org>; Fri, 14 Mar 2014 15:12:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6X02Apk8XFt7yomQKwNoENvKAy1QbGBknQUGJ2ZDs73Gw@mail.gmail.com>
References: <1393376982-28276-1-git-send-email-mcgrof@do-not-panic.com>
	<1393376982-28276-3-git-send-email-mcgrof@do-not-panic.com>
	<1393852248.10039.5.camel@jlt4.sipsolutions.net>
	<CANrMYP6Rvv4EBjY9-78bdm70G_3YGZFrJH9tFz5XVsbSSi-m=Q@mail.gmail.com>
	<CAB=NE6X02Apk8XFt7yomQKwNoENvKAy1QbGBknQUGJ2ZDs73Gw@mail.gmail.com>
Date: Fri, 14 Mar 2014 15:12:36 -0700
Message-ID: <CANrMYP4GhDZZzYkyyVCHKpb7YvJzNbFZn77hZH9T+y7HTQ4R=w@mail.gmail.com> (sfid-20140314_231241_088291_58AACC10)
Subject: Re: [PATCH 2/3] cfg80211: fix processing world regdomain when non modular
From: Colleen T <colleen@cozybit.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Sander Eikelenboom <linux@eikelenboom.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 14, 2014 at 1:48 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> On Fri, Mar 14, 2014 at 1:30 PM, Colleen T <colleen@cozybit.com> wrote:
>> This commit -- 5a970df8990d173e7e4092952f2e3da1de69b27d -- is causing
>> a regression on mac80211-next/master in our mesh test framework on
>> qemu.  We are using cfg80211 as a module.
>>
>> In /etc/default/crda, I have:
>> REGDOMAIN=US
>>
>> I can trigger the oops by loading mac80211_hwsim with three or more radios:
>>
>>> modprobe mac80211_hwsim radios=3
>
>
> Thanks for reporting this, I'll take a look at this right away. Are
> you using wireless-testing or mac80211-next? What sha1sum are you on?

Thanks a lot!  I'm on mac80211-next/master, sha is
5a970df8990d173e7e4092952f2e3da1de69b27d
>
>   Luis

Colleen
