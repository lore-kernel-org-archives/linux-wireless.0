Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:49606 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756445AbYGNVeZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2008 17:34:25 -0400
Received: by wa-out-1112.google.com with SMTP id j37so2915728waf.23
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jul 2008 14:34:25 -0700 (PDT)
Message-ID: <1ba2fa240807141434k5260e6b9q6468b450fccba3e7@mail.gmail.com> (sfid-20080714_233429_350889_A3B9DBA3)
Date: Tue, 15 Jul 2008 00:34:24 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Kalle Valo" <kalle.valo@nokia.com>
Subject: Re: [PATCH 2/2] mac80211: make listen_interval be configurable by low level driver
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <87fxqcoaue.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1216038684-29725-1-git-send-email-tomas.winkler@intel.com>
	 <1216038684-29725-2-git-send-email-tomas.winkler@intel.com>
	 <1216039127.11189.15.camel@johannes.berg>
	 <1ba2fa240807140546w4f08e32l59ed88dfa1b86403@mail.gmail.com>
	 <87fxqcoaue.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 14, 2008 at 4:26 PM, Kalle Valo <kalle.valo@nokia.com> wrote:
> Tomas Winkler <tomasw@gmail.com> writes:
>
>>> If this is a knob that should be adjusted then we want to enable users
>>> to do it, and if it isn't then we can put a value into mac80211 and fix
>>> it. Having drivers make these kinds of decisions is very bad for uniform
>>> wireless behaviour.
>>
>> The same story as with beacon interval. This is for the power
>> management. It's really hw dependent for how many beacons we can stay
>> dormant.
>
> This stuff is very much hardware dependent, I don't deny that, but
> still I would assume that the basic principles are almost the same. We
> just need to come up with a good interface for the drivers. Sure, it's
> more work now, but if we don't do it, PSM support will eventually get
> really messy because all drivers do it somehow differently.
>
This patch only sets value of listen interval from the driver  I just
think this is exactly what you are suggesting.
This is only required for sending correct value of listen interval to
AP in association. Anything else is handled in
the driver or firmware anyway.
This patch should go in and we can reconsider it when other HW driver
will implement PS so we can see the bigger picture.
Thanks
Tomas
