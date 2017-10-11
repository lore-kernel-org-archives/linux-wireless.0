Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51110 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752917AbdJKJYW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 05:24:22 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>
Subject: Re: [PATCH 2/3] rsi: sdio: Add WOWLAN support for S4 hibernate state
References: <1506345709-4699-1-git-send-email-amitkarwar@gmail.com>
        <87wp4l6au9.fsf@kamboji.qca.qualcomm.com>
        <CAEhWJF=NusRJmdhQ7W9OPVjGG=XYAWU-+gnu_mYck2BsAOK+pg@mail.gmail.com>
Date: Wed, 11 Oct 2017 12:24:17 +0300
In-Reply-To: <CAEhWJF=NusRJmdhQ7W9OPVjGG=XYAWU-+gnu_mYck2BsAOK+pg@mail.gmail.com>
        (Amitkumar Karwar's message of "Wed, 27 Sep 2017 18:45:49 +0530")
Message-ID: <87fuaqqbpa.fsf@kamboji.qca.qualcomm.com> (sfid-20171011_112644_602507_2FB77040)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> On Tue, Sep 26, 2017 at 3:27 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>>
>>> From: Karun Eagalapati <karun256@gmail.com>
>>>
>>> We are disabling of interrupts from firmware in freeze handler.
>>> Also setting power management capability KEEP_MMC_POWER to make
>>> device wakeup for WoWLAN trigger.
>>> At restore, we observed a device reset on some platforms. Hence
>>> reloading of firmware and device initialization is performed.
>>
>> With "reloading of firmware and device initialization" you mean calling
>> rsi_mac80211_detach()?
>
> After rsi_mac80211_detach, we have a call for rsi_hal_device_init() in
> which reloading of firmware happens.
>
>>
>> void rsi_mac80211_detach(struct rsi_hw *adapter)
>> {
>>         struct ieee80211_hw *hw = adapter->hw;
>>         enum nl80211_band band;
>>
>>         if (hw) {
>>                 ieee80211_stop_queues(hw);
>>                 ieee80211_unregister_hw(hw);
>>                 ieee80211_free_hw(hw);
>>         }
>>
>> That looks like a quite heavy sledgehammer workaround to a resume
>> problem. Is it really the best way to handle this?
>
> I agree with you. I will appreciate if someone propose a better
> solution. Following are details about the problem.
>
> Connection remain alive after suspend(S4 state). System is resumed
> from S4 through GPIO pin after receiving magic packet. But SDIO
> doesn't work after this. We need to do perform SDIO reset and
> redownload the firmware. Mac80211 is under impression that connection
> is alive. We keep on getting mac80211 handler calls and data while
> firmware re-download is in progress. This leads to different race
> issues and occasionally kernel crashes. detaching from mac80211 solves
> the problem here.

So what I think is the right approach is that the firmare is restarted
behind the scenes and user space doesn't even notice it, for example
that's what ath10k does. There's ieee80211_restart_hw() even for just
that.

We discussed about this also on one of mwifiex patches from Brian Norris
and there it was concluded that for cfg80211 driver it's ok to delete
the whole interface when restarting the firmware. But mac80211 drivers
can do better.

>> And even if that would be the right approach it needs to be properly
>> described in the commit log, a vague sentence in the end of a commit log
>> is not enough.
>
> Understood. I will add detailed description and send updated version
> if the patch is fine.

Not sure if this is fine or not. I think what you do here is ugly but I
guess it's better than nothing?

-- 
Kalle Valo
