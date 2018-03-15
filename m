Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44548 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750726AbeCOJAX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Mar 2018 05:00:23 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: Re: [PATCH 01/10] rsi: add support for hardware scan offload
References: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
        <1520260620-4694-2-git-send-email-amitkarwar@gmail.com>
        <87ina00zwv.fsf@purkki.adurom.net>
        <CAEhWJFk3CGJ9-QJZJt23-vvrwXgVq9GeY9AhXbPy2=FAUMUnOw@mail.gmail.com>
Date: Thu, 15 Mar 2018 11:00:17 +0200
In-Reply-To: <CAEhWJFk3CGJ9-QJZJt23-vvrwXgVq9GeY9AhXbPy2=FAUMUnOw@mail.gmail.com>
        (Amitkumar Karwar's message of "Thu, 15 Mar 2018 12:38:08 +0530")
Message-ID: <871sgl90im.fsf@kamboji.qca.qualcomm.com> (sfid-20180315_100027_511766_27701EA3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> On Tue, Mar 13, 2018 at 8:46 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>>
>>> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>>>
>>> With the current approach of scanning, roaming delays
>>> are observed. Firmware has support for back ground scanning.
>>> To get this advantage, mac80211 hardware scan is implemented.
>>> In this method, foreground scan is performed in driver and
>>> back ground scan is configured to firmware.
>>
>> To me doesn't like a good idea to duplicate scan functionality in the
>> driver.
>
> There is a limitation with our device. We need to configure background
> scan parameters to firmware when device is connected. 

Yeah, I guessed that.

> In non-connected state, we can directly dump probe requests received
> from mac80211 as a part of software scan. Some synchronization issues
> are with existing software scan when device is connected. This patch
> implements hw_scan where these issues are no seen, as driver has more
> control on scan state machine

What I don't like here is that you are duplicating functionality already
existing in mac80211 and I hope there is a better way to solve the
problem. Just as a a crazy idea what if the driver returns -EOPNOTSUPP
when hardware scan is not possible and mac80211 falls back to software
scan? But of course this depends on what Johannes thinks.

-- 
Kalle Valo
