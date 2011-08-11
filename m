Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34870 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab1HKJl0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 05:41:26 -0400
Received: by yxj19 with SMTP id 19so1186877yxj.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 02:41:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1313054258.2407.820.camel@cumari>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
	<1312881233-9366-34-git-send-email-eliad@wizery.com>
	<1313054258.2407.820.camel@cumari>
Date: Thu, 11 Aug 2011 12:41:25 +0300
Message-ID: <CAB3XZEemkaz-dsyhq6x6rPLNvFj9+t=jPr9JtvcuzmRNG-8Y1g@mail.gmail.com> (sfid-20110811_114129_331630_8661E6C6)
Subject: Re: [PATCH 33/40] wl12xx: track freed packets in FW by AC
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 11, 2011 at 12:17 PM, Luciano Coelho <coelho@ti.com> wrote:
> On Tue, 2011-08-09 at 12:13 +0300, Eliad Peller wrote:
>> From: Arik Nemtsov <arik@wizery.com>
>>
>> Track the number of freed packets in each AC when receiving an interrupt
>> from the FW. This paves the way for tracking allocated packets per AC.
>>
>> Signed-off-by: Arik Nemtsov <arik@wizery.com>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>>  drivers/net/wireless/wl12xx/main.c   |   16 +++++++++++++++-
>>  drivers/net/wireless/wl12xx/tx.c     |    2 ++
>>  drivers/net/wireless/wl12xx/wl12xx.h |    8 ++++++--
>>  3 files changed, 23 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
>> index b223c27..3bfd772 100644
>> --- a/drivers/net/wireless/wl12xx/main.c
>> +++ b/drivers/net/wireless/wl12xx/main.c
>> @@ -810,22 +810,32 @@ static void wl1271_irq_update_links_status(struct wl1271 *wl,
>>  static void wl1271_fw_status(struct wl1271 *wl,
>>                            struct wl1271_fw_status *status)
>>  {
>>       struct timespec ts;
>>       u32 old_tx_blk_count = wl->tx_blocks_available;
>>       int avail, freed_blocks;
>> +     int i;
>>
>>       wl1271_raw_read(wl, FW_STATUS_ADDR, status, sizeof(*status), false);
>>
>>       wl1271_debug(DEBUG_IRQ, "intr: 0x%x (fw_rx_counter = %d, "
>>                    "drv_rx_counter = %d, tx_results_counter = %d)",
>>                    status->intr,
>>                    status->fw_rx_counter,
>>                    status->drv_rx_counter,
>>                    status->tx_results_counter);
>>
>> +     for (i = 0; i < NUM_TX_QUEUES; i++) {
>> +             /* prevent wrap-around in freed-packets counter */
>> +             wl->tx_allocated_pkts -=
>> +                             (status->tx_released_pkts[i] -
>> +                             wl->tx_pkts_freed[i] + 256) % 256;
>
> Isn't the "+ 256" useless here, since you'll mod the result anyway?
>
modulus of negative numbers is not well defined.

Eliad.
