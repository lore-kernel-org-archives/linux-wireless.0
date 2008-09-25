Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:53318 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbYIYWFr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2008 18:05:47 -0400
Received: by fg-out-1718.google.com with SMTP id 19so436887fgg.17
        for <linux-wireless@vger.kernel.org>; Thu, 25 Sep 2008 15:05:45 -0700 (PDT)
Message-ID: <1ba2fa240809251505p342d8a6do51cf870624e0c8dd@mail.gmail.com> (sfid-20080926_000551_846070_AD8B43A0)
Date: Fri, 26 Sep 2008 01:05:45 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: [PATCH RFC] mac80211: notify mac80211 about rfkill events
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, hmh@hmh.eng.br, linux-wireless@vger.kernel.org,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>
In-Reply-To: <200809252310.21320.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1222357719-26294-1-git-send-email-tomas.winkler@intel.com>
	 <200809252310.21320.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 26, 2008 at 12:10 AM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> Hi,
>
>> Currently mac80211 is not notified about rfill state of low level driver
>> and doesn't now when it's disconnected and when to restart connection
>> There also there is conflict or no synchronization between 'wext txpower
>> disable' and rfkill events coming from rfkill subsystem
>>
>> This patch is just a sketch of possible solution, it probably even doesn't
>> compile
>
> I am not sure if registring a notifier would be the best solution,
> persionally I was thinking of implementing the rfkill structure into ieee80211_local
> and make it listen to events directly.
>
> Through a small callback function drivers can easily report their rfkill events
> to mac80211 which in turn will call rfkill_force_state().

> On the other hand, perhaps notifications might work better, depends on what
> the drivers like better.

That's definitely other option we wanted to suggest that mac80211
would register itself to rfkill subsystem and will provide to driver
appropriate callbacks.  The question is how  drivers vary in the rfkil
implementation and whether it wouldn't be more complex, in that case
the notification is quite clean solution.

> As mentioned in a discussion on the list a few days ago, SOFT_BLOCKED
> is not for 'iwconfig txpower off' commands or any other commands coming
> from userspace. Those are not HW triggered rfkill events.

> That means that the only change needed in ieee80211_ioctl_siwtxpower() is
> only allowing the enabling of the radio when RFKILL is not set to BLOCKED.

That's just complicates everything and moving the policy  decisions to
the driver after all even
form txpower off you implement it as soft rfkill.

I would suggest just remove the support for txpower off in mac80211
now when appropriate or sync it with soft block after all it coming
from user space as a software event.

Tomas
