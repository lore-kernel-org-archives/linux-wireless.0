Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:55300 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbaI3M1Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 08:27:25 -0400
Received: by mail-we0-f177.google.com with SMTP id k48so87538wev.36
        for <linux-wireless@vger.kernel.org>; Tue, 30 Sep 2014 05:27:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5429833C.60003@candelatech.com>
References: <1411507045-18973-1-git-send-email-greearb@candelatech.com>
	<1411507045-18973-7-git-send-email-greearb@candelatech.com>
	<87a95i3kcb.fsf@kamboji.qca.qualcomm.com>
	<5429833C.60003@candelatech.com>
Date: Tue, 30 Sep 2014 14:27:23 +0200
Message-ID: <CA+BoTQ=NG9to+Tv4Ci+Vu_dOGRgGVzxJUyb1bydWCc-EeWc_9g@mail.gmail.com> (sfid-20140930_142731_590327_3A570979)
Subject: Re: [PATCH v2 07/10] ath10k: add fw-powerup-fail to ethtool stats.
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29 September 2014 18:05, Ben Greear <greearb@candelatech.com> wrote:
> On 09/29/2014 01:24 AM, Kalle Valo wrote:
>> greearb@candelatech.com writes:
>>
>>> From: Ben Greear <greearb@candelatech.com>
>>>
>>> This gives user-space a normal-ish way to detect that
>>> firmware has failed to start and that a reboot is
>>> probably required.
>>>
>>> Signed-off-by: Ben Greear <greearb@candelatech.com>
[...]
>>> -    return 0;
>>> +out:
>>> +    /* If we have failed to power-up, it may take a reboot to
>>> +     * get the NIC back online.
>>> +     * Set flag accordinly so that user-space can know.
>>> +     */
>>> +    ar->fw_powerup_failed = !!ret;
>>> +    return ret;
>>>  }
>>
>> Would it be better to use ATH10K_STATE_WEDGED for this and then just
>> export the state value to user space? Or should we have two different
>> states, like FW_WEDGED and HW_WEDGED?

Current WEDGED state is more like ON. It assumes mac80211 will call
ath10k_stop().

Adding another state just for the sake of handling power up / reset
issues seems like an overkill to me.


> I didn't want to mess with the state machine.  This counter
> is just a clue to users that things might be badly wrong.  Some systems
> might recover with another hard reset, some will hang the entire
> system hard, and some will just stick in this state unable to
> recover.  Some of my systems exhibit this last behaviour, so at
> least with this patch I can warn the user that they need to
> reboot to regain wifi functionality.

If power up fails the error should propagate to `ifconfig wlanX up`
(or whatever calling drv_start) eventually so I don't see the point in
having this counter.


Michał
