Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56046 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934364AbeF0PWw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Jun 2018 11:22:52 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Brian Norris" <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, 'Xinming Hu' <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>
Subject: Re: [EXT] Re: [PATCH] mwifiex: fix nested rtnl locking on BG_SCAN_STOPPED
References: <1524633572-5588-1-git-send-email-gbhat@marvell.com>
        <87in8fbvrr.fsf@purkki.adurom.net>
        <b534bd7a3e6a43baa7593a493f18e6fa@SC-EXCH02.marvell.com>
Date: Wed, 27 Jun 2018 18:22:45 +0300
In-Reply-To: <b534bd7a3e6a43baa7593a493f18e6fa@SC-EXCH02.marvell.com>
        (Ganapathi Bhat's message of "Wed, 27 Jun 2018 15:00:26 +0000")
Message-ID: <87zhzgs18a.fsf@kamboji.qca.qualcomm.com> (sfid-20180627_172303_048203_4242E583)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> writes:

> Hi Kalle,
>
>> > >
>> > >   case EVENT_BG_SCAN_STOPPED:
>> > >           dev_dbg(adapter->dev, "event: BGS_STOPPED\n");
>> > > -         cfg80211_sched_scan_stopped(priv->wdev.wiphy, 0);
>> > > +         if (rtnl_is_locked())
>> > > +                 cfg80211_sched_scan_stopped_rtnl(priv-
>> > >wdev.wiphy, 0);
>> > > +         else
>> > > +                 cfg80211_sched_scan_stopped(priv->wdev.wiphy,
>> > 0);
>> >
>> > IMHO checking if a lock is taking is rather ugly and an indication there's a
>> > problem with the locking. Instead making an ugly workaround like this I
>> > would rather investigate who is holding the rtnl and solve that.
>> There can be applications trying to access driver(via cfg80211), holding
>> rtnl_lock.
>> For example(in our case):
>> 1. "iw dev"  was called, when BG_SCAN was active.
>> 2. NL80211_CMD_GET_INTERFACE requires rtnl_lock to be hold(specified in
>> internal_flags)
>> 3. cfg80211 will  hold rtnl_lock before calling "get_tx_power"(in pre_doit).
>> 4. mwifiex will download RF_TX_PWR command to firmware
>> 5. firmware will send BG_SCAN_STOPPED event(since BG_SCAN was active).
>> 6. mwifiex will call "cfg80211_sched_scan_stopped" causing nested rtnl
>> locking.
>>
>> Please share your comments further.
>
> Let us know your thoughts on above sequence.

Sorry, I don't have time to help with this. Hopefully someone else can.

-- 
Kalle Valo
