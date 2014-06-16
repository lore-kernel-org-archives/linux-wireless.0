Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:36665 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaFPNID (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 09:08:03 -0400
Message-ID: <539EEC30.2040703@broadcom.com> (sfid-20140616_150825_948606_C8B4C0BD)
Date: Mon, 16 Jun 2014 15:08:00 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Jahnavi Meher <jahnavi.meher@gmail.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/16] Fixes, adding support for 5GHz, bgscan and 40MHz.
References: <1402753689-13819-1-git-send-email-jahnavi.meher@gmail.com>	<539D56CE.9090209@broadcom.com> <CAPD+p4LAu-_NPG0Ly6zahWRmi4hsEHGDKyS2GznSTtUSgxnYOg@mail.gmail.com>
In-Reply-To: <CAPD+p4LAu-_NPG0Ly6zahWRmi4hsEHGDKyS2GznSTtUSgxnYOg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16-06-14 12:38, Jahnavi Meher wrote:
> On Sun, Jun 15, 2014 at 1:48 PM, Arend van Spriel <arend@broadcom.com> wrote:
>>
>> On 14-06-14 15:48, Jahnavi Meher wrote:
>>>
>>> This series of patches contains fixes, adds support for
>>> 5GHz and bgscan and 40MHz.
>>
>>
>> Thanks for splitting up this series. It would be good to version the series, ie. [PATCH v2 xx/16] and indicate this replaces the previous patch series referring to the Message-ID. In this case
>>
>> Message-ID: <1402670579-8818-1-git-send-email-jahnavi.meher@gmail.com>
>>
>> Regards,
>> Arend
>
> How can I indicate that this patch series is referring to a particular
> Message-ID? Should I specify it
> in the "Message-ID to be used as In-Reply-To for the first email?"
> field that appears while sending out
> a mail via git? I have just started using git and am not sure if this
> was what you meant.

I meant to add a paragraph to the cover-letter stating "This series 
replaces the previous series with Message-ID: 
<123456789-5679-some-message-id@somemailer.com>" so John can clean his 
patch queue. Using the git In-Reply-To can also be useful as it will 
group the patch series together in online archives.

Regards,
Arend

>>
>>
>>> Jahnavi Meher (16):
>>>     rsi: Mapping the debugfs stats to the correct s/w queues.
>>>     rsi: Fixed the kernel doc
>>>     rsi: Using band from rsi_common to fill in ieee80211_rx_status
>>>     rsi: Add macros for endpoints and set default value of endpoint.
>>>     rsi: Changed the radio caps frame.
>>>     rsi: Changed the rsi_set_channel() and rsi_program_bb_rf().
>>>     rsi: Changed rate handling.
>>>     rsi: Lower level debug messages and changed handling of confirm
>>>       received for rsi_program_bb_rf().
>>>     rsi: Use SGI if configured for fixed rate transmission.
>>>     rsi: Changed the SDIO interrupt variables and some clean up.
>>>     rsi: Changed the logic of dequeuing packets from hal queues.
>>>     rsi: Added debug messages.
>>>     rsi: Sending QoS null packet via the mgmt queue.
>>>     rsi: Adding support for 5GHz
>>>     rsi: Adding support for host based bgscan.
>>>     rsi: Changes for 40MHz
>>>
>>>    drivers/net/wireless/rsi/rsi_91x_core.c     |   85 +++++++---
>>>    drivers/net/wireless/rsi/rsi_91x_debugfs.c  |   10 +-
>>>    drivers/net/wireless/rsi/rsi_91x_mac80211.c |  143 ++++++++++++++---
>>>    drivers/net/wireless/rsi/rsi_91x_mgmt.c     |  236 +++++++++++++++++++--------
>>>    drivers/net/wireless/rsi/rsi_91x_pkt.c      |   17 ++
>>>    drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |    8 +-
>>>    drivers/net/wireless/rsi/rsi_main.h         |   12 ++
>>>    drivers/net/wireless/rsi/rsi_mgmt.h         |   25 +++-
>>>    drivers/net/wireless/rsi/rsi_sdio.h         |    8 +-
>>>    9 files changed, 416 insertions(+), 128 deletions(-)
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>
>
>

