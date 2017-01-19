Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49444 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752402AbdASMgK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jan 2017 07:36:10 -0500
Subject: Re: [PATCH v2 01/13] wil6210: add sysfs file for FTM calibration
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>,
        qca_merez <qca_merez@qca.qualcomm.com>
References: <1484226365-10433-1-git-send-email-qca_merez@qca.qualcomm.com>
 <1484226365-10433-2-git-send-email-qca_merez@qca.qualcomm.com>
 <871svzp79p.fsf@kamboji.qca.qualcomm.com>
Cc: qca_liord <qca_liord@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        wil6210 <wil6210@qca.qualcomm.com>
From: Lior David <liord@codeaurora.org>
Message-ID: <c066ef7d-f61b-3b3e-1a6c-e2b89de812e9@codeaurora.org> (sfid-20170119_133613_540463_CF6EAFF2)
Date: Thu, 19 Jan 2017 14:36:05 +0200
MIME-Version: 1.0
In-Reply-To: <871svzp79p.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1/19/2017 2:24 PM, Valo, Kalle wrote:
> Maya Erez <qca_merez@qca.qualcomm.com> writes:
> 
>> From: Lior David <qca_liord@qca.qualcomm.com>
>>
>> In fine timing measurements, the calculation is affected by
>> 2 parts: timing of packets over the air, which is platform
>> independent, and platform-specific delays, which are dependent
>> on things like antenna cable length and type.
>> Add a sysfs file which allows to get/set these platform specific
>> delays, separated into the TX and RX components.
>> There are 2 key scenarios where the file can be used:
>> 1. Calibration - start with some initial values (for example,
>> the default values at startup), make measurements at a known
>> distance, then iteratively change the values until the
>> measurement results match the known distance.
>> 2. Adjust the delays when platform starts up, based on known
>> values.
>>
>> Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
>> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
> 
> Can't this go via nl80211? sysfs is not really supposed to be used for
> something like this.
> 
There is no nl80211 API for this (yet?).
Will it be ok to put this in debugfs? Normally this will be in the board
file (as part of RF configuration) but it will be useful to play
with these values for debugging/diagnostics.

Thanks,
Lior
