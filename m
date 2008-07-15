Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:48655 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888AbYGOKmJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 06:42:09 -0400
Received: by py-out-1112.google.com with SMTP id p76so3026489pyb.10
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jul 2008 03:42:08 -0700 (PDT)
Message-ID: <1ba2fa240807150342p626f0c24pf1a5551a5782550@mail.gmail.com> (sfid-20080715_124214_702949_C73C8AF0)
Date: Tue, 15 Jul 2008 13:42:07 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] mac80211: make listen_interval be configurable by low level driver
Cc: "Kalle Valo" <kalle.valo@nokia.com>, linville@tuxdriver.com,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <1216111261.3535.7.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1216038684-29725-1-git-send-email-tomas.winkler@intel.com>
	 <1216038684-29725-2-git-send-email-tomas.winkler@intel.com>
	 <1216039127.11189.15.camel@johannes.berg>
	 <1ba2fa240807140546w4f08e32l59ed88dfa1b86403@mail.gmail.com>
	 <87fxqcoaue.fsf@nokia.com> <1216109543.23746.21.camel@johannes.berg>
	 <1ba2fa240807150129v4906b7bcyba66ab62b57c5d71@mail.gmail.com>
	 <1216111261.3535.7.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 15, 2008 at 11:41 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2008-07-15 at 11:29 +0300, Tomas Winkler wrote:
>
>> We are providing power save user interface reach enough to specify all
>> the above requirements.
>> I think you are both misinterpreting listen interval meaning.
>> Listen interval merely says to AP for how many beacons save direct
>> packets for this STA. It doesn't mean
>> it's can be shorter and it  does say it's won't be longer.
>
> Right, but it does make sense to advertise what we're using, and this
> patch just adds a strict "driver tells mac80211 what it's using" flow.
> That's mostly what I'm objecting to. If you were calling the variable
> "max_listen_interval" and having mac80211 send it back to the driver in
> the BSS config as bssconf->listen_interval, and, for now, simply use the
> max, I wouldn't have a problem with it.

Okay will work for me, although I think it's just overhead in this
stage and  I doubt it will ever be utilized.
Will submit V2

>> It's
>> doesn't affect power save dynamics it's just sets upper limit.
>> This value for iwlwifi hw is derived from maximal supported  beacon
>> interval and size of the internal HW timers.
>> This value is hard coded in the driver.
>
> Shouldn't it depend on the beacon interval then?

Yes, but why to complicate things if not needed.
Tomas
