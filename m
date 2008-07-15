Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:19095 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbYGOH12 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 03:27:28 -0400
To: "Tomas Winkler" <tomasw@gmail.com>
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: make listen_interval be configurable by low level driver
References: <1216038684-29725-1-git-send-email-tomas.winkler@intel.com>
	<1216038684-29725-2-git-send-email-tomas.winkler@intel.com>
	<1216039127.11189.15.camel@johannes.berg>
	<1ba2fa240807140546w4f08e32l59ed88dfa1b86403@mail.gmail.com>
	<87fxqcoaue.fsf@nokia.com>
	<1ba2fa240807141434k5260e6b9q6468b450fccba3e7@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Tue, 15 Jul 2008 10:21:16 +0300
In-Reply-To: <1ba2fa240807141434k5260e6b9q6468b450fccba3e7@mail.gmail.com> (ext Tomas Winkler's message of "Tue\, 15 Jul 2008 00\:34\:24 +0300")
Message-ID: <87od4zd34j.fsf@nokia.com> (sfid-20080715_092732_589800_50479196)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler <tomasw@gmail.com> writes:

>>
>> This stuff is very much hardware dependent, I don't deny that, but
>> still I would assume that the basic principles are almost the same. We
>> just need to come up with a good interface for the drivers. Sure, it's
>> more work now, but if we don't do it, PSM support will eventually get
>> really messy because all drivers do it somehow differently.
>>
> This patch only sets value of listen interval from the driver I just
> think this is exactly what you are suggesting.

No, I don't suggest that. I understood that for setting the
listen_interval you are after something like this:

         sysfs?                 register_hw()
user   ---------->   driver    -------------->  mac80211

(Please correct me if I misunderstood this.)

But I think that the flow should be like this:

       WE/cfg80211                config()
user   ---------->   mac80211  -------------->  driver

So that mac80211 would be one making the choice for the listen value
based on user input. But what the user input would be, that's an
another question.

> This is only required for sending correct value of listen interval
> to AP in association. Anything else is handled in the driver or
> firmware anyway.

Yes, driver will pass the information to the firmware. But I still
think mac80211 should make the decision, and the driver should be only
forwarding mac80211 decisions to the firmware.

> This patch should go in and we can reconsider it when other HW
> driver will implement PS so we can see the bigger picture.

I guess it's a good compromise for now, but as long as we change it
later.

-- 
Kalle Valo
