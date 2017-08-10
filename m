Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35924 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751468AbdHJHqZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Aug 2017 03:46:25 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Reizer\, Eyal" <eyalr@ti.com>
Cc: Tony Lindgren <tony@atomide.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sebastian.reichel\@collabora.co.uk"
        <sebastian.reichel@collabora.co.uk>,
        Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [v6] wlcore: add missing nvs file name info for wilink8
References: <1502264840-10569-1-git-send-email-eyalr@ti.com>
        <8665E2433BC68541A24DFFCA87B70F5B36420E5A@DFRE01.ent.ti.com>
        <20170809172651.GA3934@atomide.com>
        <ngx9scofrw0qb2vkesion8v9.1502300336052@email.android.com>
        <20170809211620.GF3934@atomide.com>
        <8665E2433BC68541A24DFFCA87B70F5B36422C65@DFRE01.ent.ti.com>
Date: Thu, 10 Aug 2017 10:46:19 +0300
In-Reply-To: <8665E2433BC68541A24DFFCA87B70F5B36422C65@DFRE01.ent.ti.com>
        (Eyal Reizer's message of "Thu, 10 Aug 2017 06:35:46 +0000")
Message-ID: <87r2wjeugk.fsf@codeaurora.org> (sfid-20170810_094638_832801_8AF3AAC4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Reizer, Eyal" <eyalr@ti.com> writes:

>> The fact that is old does not change a thing, we still need to
>> support it no matter what the data sheet and your system design
>> says. A fix that breaks other things is not really a fix :)
>> 
>
> Sure, just want to make sure we are not trying to add work around just for
> A couple of faulty devices.
>
>> > I have verified using a couple of com6 modules with an am335x-evm and
>> they had mac addresses read ok.
>> 
>> Sounds like there are multiple variants of the wl12xx
>> available then.
>> 
> I am trying to find out internally if there is a possibility that there were devices
> Produced in the past where the internal fuses were not programmed with a valid 
> Address before being assembled into the modules.

Just a general remark, based on my past experience, you can't really
know what hardware is out there, no matter how someone in the company
claims otherwise. Uncalibrated devices, prototypes and calibration data
broken are all possible and better be preparared for that in the driver.

It's a good idea at least to detect and print a proper error message if
the calibration data is broken. But if the data on the device only
consists of MAC address and nothing else, then I guess using a random
address is fine.

-- 
Kalle Valo
