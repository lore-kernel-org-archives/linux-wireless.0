Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45646 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751189AbdJ1P0E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 28 Oct 2017 11:26:04 -0400
Subject: Re: [PATCH 03/12] wil6210: refresh FW capabilities during interface
 up
To: Kalle Valo <kvalo@codeaurora.org>,
        Maya Erez <qca_merez@qca.qualcomm.com>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
References: <1508937247-11890-1-git-send-email-qca_merez@qca.qualcomm.com>
 <1508937247-11890-4-git-send-email-qca_merez@qca.qualcomm.com>
 <87o9ors4ef.fsf@purkki.adurom.net>
From: Lior David <liord@codeaurora.org>
Message-ID: <17994ee8-0d84-2e67-c290-5f1a2f18e0a1@codeaurora.org> (sfid-20171028_172609_230375_832F507C)
Date: Sat, 28 Oct 2017 18:25:59 +0300
MIME-Version: 1.0
In-Reply-To: <87o9ors4ef.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 10/28/2017 6:01 PM, Kalle Valo wrote:
> Maya Erez <qca_merez@qca.qualcomm.com> writes:
> 
>> From: Lior David <qca_liord@qca.qualcomm.com>
>>
>> FW capabilities are currently retrieved only during module
>> initialization, but userspace can replace the firmware while
>> interface is down, so refresh the FW capabilities when
>> interface is up (after FW is loaded) to ensure driver
>> functionality matches the loaded FW.
> 
> I think usually the firmware is loaded only once during probe() and I
> think it's quite special that you retrieve it during interface up. Being
> able to change the firmware version runtime like that can lead to
> problems eventually, for example cfg80211 might not allow changing
> already registered configuration etc.
> 
Yes you are right, it is not perfect.
We shutdown our chip in interface down so the FW is lost, we have to load it
every interface up. We could request_firmware only once at insmod and store it
so the same FW will be used every time but this is a big waste of memory (FW
size is ~400KB and may be larger with future chips). We only touch one or two
very simple fields in struct wiphy that are not validated in wiphy_register. The
behavior is not 100% proof but good enough, and we recommend to our users to
always rmmod/insmod when replacing FW (replacing FW at runtime is usually not
done in production systems, this is only for debugging).
However, if we do not refresh the capabilities we will have larger problems -
the driver can try to access features not supported by FW and cause FW/host crashes.
