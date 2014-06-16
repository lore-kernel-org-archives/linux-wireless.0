Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f180.google.com ([209.85.220.180]:37567 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104AbaFPKid (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 06:38:33 -0400
Received: by mail-vc0-f180.google.com with SMTP id im17so4642421vcb.39
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jun 2014 03:38:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <539D56CE.9090209@broadcom.com>
References: <1402753689-13819-1-git-send-email-jahnavi.meher@gmail.com>
	<539D56CE.9090209@broadcom.com>
Date: Mon, 16 Jun 2014 16:08:32 +0530
Message-ID: <CAPD+p4LAu-_NPG0Ly6zahWRmi4hsEHGDKyS2GznSTtUSgxnYOg@mail.gmail.com> (sfid-20140616_123836_393129_4E346BD6)
Subject: Re: [PATCH 00/16] Fixes, adding support for 5GHz, bgscan and 40MHz.
From: Jahnavi Meher <jahnavi.meher@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 15, 2014 at 1:48 PM, Arend van Spriel <arend@broadcom.com> wrote:
>
> On 14-06-14 15:48, Jahnavi Meher wrote:
>>
>> This series of patches contains fixes, adds support for
>> 5GHz and bgscan and 40MHz.
>
>
> Thanks for splitting up this series. It would be good to version the series, ie. [PATCH v2 xx/16] and indicate this replaces the previous patch series referring to the Message-ID. In this case
>
> Message-ID: <1402670579-8818-1-git-send-email-jahnavi.meher@gmail.com>
>
> Regards,
> Arend

How can I indicate that this patch series is referring to a particular
Message-ID? Should I specify it
in the "Message-ID to be used as In-Reply-To for the first email?"
field that appears while sending out
a mail via git? I have just started using git and am not sure if this
was what you meant.
>
>
>> Jahnavi Meher (16):
>>    rsi: Mapping the debugfs stats to the correct s/w queues.
>>    rsi: Fixed the kernel doc
>>    rsi: Using band from rsi_common to fill in ieee80211_rx_status
>>    rsi: Add macros for endpoints and set default value of endpoint.
>>    rsi: Changed the radio caps frame.
>>    rsi: Changed the rsi_set_channel() and rsi_program_bb_rf().
>>    rsi: Changed rate handling.
>>    rsi: Lower level debug messages and changed handling of confirm
>>      received for rsi_program_bb_rf().
>>    rsi: Use SGI if configured for fixed rate transmission.
>>    rsi: Changed the SDIO interrupt variables and some clean up.
>>    rsi: Changed the logic of dequeuing packets from hal queues.
>>    rsi: Added debug messages.
>>    rsi: Sending QoS null packet via the mgmt queue.
>>    rsi: Adding support for 5GHz
>>    rsi: Adding support for host based bgscan.
>>    rsi: Changes for 40MHz
>>
>>   drivers/net/wireless/rsi/rsi_91x_core.c     |   85 +++++++---
>>   drivers/net/wireless/rsi/rsi_91x_debugfs.c  |   10 +-
>>   drivers/net/wireless/rsi/rsi_91x_mac80211.c |  143 ++++++++++++++---
>>   drivers/net/wireless/rsi/rsi_91x_mgmt.c     |  236 +++++++++++++++++++--------
>>   drivers/net/wireless/rsi/rsi_91x_pkt.c      |   17 ++
>>   drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |    8 +-
>>   drivers/net/wireless/rsi/rsi_main.h         |   12 ++
>>   drivers/net/wireless/rsi/rsi_mgmt.h         |   25 +++-
>>   drivers/net/wireless/rsi/rsi_sdio.h         |    8 +-
>>   9 files changed, 416 insertions(+), 128 deletions(-)
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>



-- 
Regards,
Jahnavi Meher
