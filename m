Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:24571 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbYGOI3v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 04:29:51 -0400
Received: by wa-out-1112.google.com with SMTP id j37so3008059waf.23
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jul 2008 01:29:50 -0700 (PDT)
Message-ID: <1ba2fa240807150129v4906b7bcyba66ab62b57c5d71@mail.gmail.com> (sfid-20080715_102957_031204_D072D0D8)
Date: Tue, 15 Jul 2008 11:29:50 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] mac80211: make listen_interval be configurable by low level driver
Cc: "Kalle Valo" <kalle.valo@nokia.com>, linville@tuxdriver.com,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <1216109543.23746.21.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1216038684-29725-1-git-send-email-tomas.winkler@intel.com>
	 <1216038684-29725-2-git-send-email-tomas.winkler@intel.com>
	 <1216039127.11189.15.camel@johannes.berg>
	 <1ba2fa240807140546w4f08e32l59ed88dfa1b86403@mail.gmail.com>
	 <87fxqcoaue.fsf@nokia.com> <1216109543.23746.21.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 15, 2008 at 11:12 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> This stuff is very much hardware dependent, I don't deny that, but
>> still I would assume that the basic principles are almost the same. We
>> just need to come up with a good interface for the drivers. Sure, it's
>> more work now, but if we don't do it, PSM support will eventually get
>> really messy because all drivers do it somehow differently.
>
> I agree.
>
>> > I really don't know what other vendors do and user should not guess
>> > this.
>>
>> Yes, for the user this is too difficult, but I think the driver
>> shouldn't be making the decision either. So mac80211 stack would be
>> the most logical choice, and it could be make the decisions based on
>> user input (or something like that).
>
> Well, the user may want to make a choice based on the latency. Or,
> ideally, we would detect that they're using voice and want lower
> latency. Or something like that.


We are providing power save user interface reach enough to specify all
the above requirements.
I think you are both misinterpreting listen interval meaning.
Listen interval merely says to AP for how many beacons save direct
packets for this STA. It doesn't mean
it's can be shorter and it  does say it's won't be longer. It's
doesn't affect power save dynamics it's just sets upper limit.
This value for iwlwifi hw is derived from maximal supported  beacon
interval and size of the internal HW timers.
This value is hard coded in the driver.

Tomas
