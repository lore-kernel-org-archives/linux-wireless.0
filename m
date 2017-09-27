Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:37476 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751959AbdI0NPu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Sep 2017 09:15:50 -0400
Received: by mail-oi0-f65.google.com with SMTP id h9so8687906oia.4
        for <linux-wireless@vger.kernel.org>; Wed, 27 Sep 2017 06:15:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87wp4l6au9.fsf@kamboji.qca.qualcomm.com>
References: <1506345709-4699-1-git-send-email-amitkarwar@gmail.com> <87wp4l6au9.fsf@kamboji.qca.qualcomm.com>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Wed, 27 Sep 2017 18:45:49 +0530
Message-ID: <CAEhWJF=NusRJmdhQ7W9OPVjGG=XYAWU-+gnu_mYck2BsAOK+pg@mail.gmail.com> (sfid-20170927_151553_970976_6D29FB02)
Subject: Re: [PATCH 2/3] rsi: sdio: Add WOWLAN support for S4 hibernate state
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 26, 2017 at 3:27 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>
>> From: Karun Eagalapati <karun256@gmail.com>
>>
>> We are disabling of interrupts from firmware in freeze handler.
>> Also setting power management capability KEEP_MMC_POWER to make
>> device wakeup for WoWLAN trigger.
>> At restore, we observed a device reset on some platforms. Hence
>> reloading of firmware and device initialization is performed.
>
> With "reloading of firmware and device initialization" you mean calling
> rsi_mac80211_detach()?

After rsi_mac80211_detach, we have a call for rsi_hal_device_init() in
which reloading of firmware happens.

>
> void rsi_mac80211_detach(struct rsi_hw *adapter)
> {
>         struct ieee80211_hw *hw = adapter->hw;
>         enum nl80211_band band;
>
>         if (hw) {
>                 ieee80211_stop_queues(hw);
>                 ieee80211_unregister_hw(hw);
>                 ieee80211_free_hw(hw);
>         }
>
> That looks like a quite heavy sledgehammer workaround to a resume
> problem. Is it really the best way to handle this?

I agree with you. I will appreciate if someone propose a better
solution. Following are details about the problem.

Connection remain alive after suspend(S4 state). System is resumed
from S4 through GPIO pin after receiving magic packet. But SDIO
doesn't work after this. We need to do perform SDIO reset and
redownload the firmware. Mac80211 is under impression that connection
is alive. We keep on getting mac80211 handler calls and data while
firmware re-download is in progress. This leads to different race
issues and occasionally kernel crashes. detaching from mac80211 solves
the problem here.

>
> And even if that would be the right approach it needs to be properly
> described in the commit log, a vague sentence in the end of a commit log
> is not enough.

Understood. I will add detailed description and send updated version
if the patch is fine.

Regards,
Amitkumar Karwar
