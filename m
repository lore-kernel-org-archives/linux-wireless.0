Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35256 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750839AbeCPEyZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Mar 2018 00:54:25 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Sebastian Reichel <sre@kernel.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Linux Bluetooth mailing list
        <linux-bluetooth@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH] [v2] Bluetooth: btrsi: rework dependencies
References: <20180315165050.2211236-1-arnd@arndb.de>
        <988BDE3E-B2D2-4ABF-B644-4BFF41AF4157@holtmann.org>
        <CAK8P3a1DTbbRUoCoYsmaSAQBQhaePZ0Tx-g2+xuab3yRcGhLpw@mail.gmail.com>
Date: Fri, 16 Mar 2018 06:54:19 +0200
In-Reply-To: <CAK8P3a1DTbbRUoCoYsmaSAQBQhaePZ0Tx-g2+xuab3yRcGhLpw@mail.gmail.com>
        (Arnd Bergmann's message of "Thu, 15 Mar 2018 22:16:51 +0100")
Message-ID: <87r2ok4o3o.fsf@kamboji.qca.qualcomm.com> (sfid-20180316_055444_481960_C52C9F67)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> writes:

> On Thu, Mar 15, 2018 at 7:30 PM, Marcel Holtmann <marcel@holtmann.org> wrote:
>> Hi Arnd,
>>
>>> The linkage between the bluetooth driver and the wireless
>>> driver is not defined properly, leading to build problems
>>> such as:
>>>
>>> warning: (BT_HCIRSI) selects RSI_COEX which has unmet direct
>>> dependencies (NETDEVICES && WLAN && WLAN_VENDOR_RSI && BT_HCIRSI &&
>>> RSI_91X)
>>> drivers/net/wireless/rsi/rsi_91x_main.o: In function `rsi_read_pkt':
>>> (.text+0x205): undefined reference to `rsi_bt_ops'
>>>
>>> As the dependency is actually the reverse (RSI_91X uses
>>> the BT_RSI driver, not the other way round), this changes
>>> the dependency to match, and enables the bluetooth driver
>>> from the RSI_COEX symbol.
>>>
>>> Fixes: 38aa4da50483 ("Bluetooth: btrsi: add new rsi bluetooth driver")
>>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>>> ---
>>> v2: Pick a different from v1
>>> ---
>>> drivers/bluetooth/Kconfig        | 4 +---
>>> drivers/net/wireless/rsi/Kconfig | 4 +++-
>>> 2 files changed, 4 insertions(+), 4 deletions(-)
>>
>> Acked-by: Marcel Holtmann <marcel@holtmann.org>
>>
>> Since I think Kalle still has to take it through his tree until the
>> btrsi driver makes it into net-next.

Yes, I have to take this as I haven't sent the original patch to Dave
yet.

> Kalle, please wait for v3 though, I just ran into another build
> failure caused by a typo in v2.

Ok, I saw it.

-- 
Kalle Valo
