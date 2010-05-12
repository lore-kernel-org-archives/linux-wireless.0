Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:45757 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab0ELJza convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 05:55:30 -0400
Received: by wwi18 with SMTP id 18so651845wwi.19
        for <linux-wireless@vger.kernel.org>; Wed, 12 May 2010 02:55:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinMB9AThStTLQ5vkRrKJgDz84n447kFcTwQaQvQ@mail.gmail.com>
References: <1273614705-25118-1-git-send-email-gwingerde@gmail.com>
	 <1273614705-25118-9-git-send-email-gwingerde@gmail.com>
	 <AANLkTinMB9AThStTLQ5vkRrKJgDz84n447kFcTwQaQvQ@mail.gmail.com>
Date: Wed, 12 May 2010 11:55:29 +0200
Message-ID: <AANLkTinzPPIbH6bivhjTF1jB6R2mZ5e9rnhX23Yr8bJ7@mail.gmail.com>
Subject: Re: [PATCH 8/9] rt2x00: Reverse calling order of bus write_tx_desc
	and driver write_tx_desc.
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 12, 2010 at 9:02 AM, Ivo Van Doorn <ivdoorn@gmail.com> wrote:
> On Tue, May 11, 2010 at 11:51 PM, Gertjan van Wingerde
> <gwingerde@gmail.com> wrote:
>> For rt2800 reverse the calling order of rt2x00pci_write_data and
>> rt2800pci_write_data. Currently rt2800pci_write_data calls rt2x00pci_write_data
>> as there can be only 1 driver callback function specified by the driver.
>> Reverse this calling order by introducing a new driver callback function,
>> called add_tx_datadesc, which is called from the bus-specific write_tx_data
>> functions.
>> Preparation for futher cleanups in the skb data handling of rt2x00.
>>
>> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
>> ---
>>  drivers/net/wireless/rt2x00/rt2800pci.c |   15 ++++-----------
>>  drivers/net/wireless/rt2x00/rt2x00.h    |    2 ++
>>  drivers/net/wireless/rt2x00/rt2x00pci.c |    6 ++++++
>>  drivers/net/wireless/rt2x00/rt2x00usb.c |    6 ++++++
>>  4 files changed, 18 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
>> index fcca30c..bbd6481 100644
>> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
>> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
>> @@ -614,18 +614,10 @@ static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
>>  /*
>>  * TX descriptor initialization
>>  */
>> -static int rt2800pci_write_tx_data(struct queue_entry* entry,
>> -                                  struct txentry_desc *txdesc)
>> +static void rt2800pci_add_tx_datadesc(struct queue_entry* entry,
>> +                                     struct txentry_desc *txdesc)
>>  {
>> -       int ret;
>> -
>> -       ret = rt2x00pci_write_tx_data(entry, txdesc);
>> -       if (ret)
>> -               return ret;
>> -
>>        rt2800_write_txwi(entry->skb, txdesc);
>> -
>> -       return 0;
>>  }
>>
>>
>> @@ -1080,7 +1072,8 @@ static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
>>        .reset_tuner            = rt2800_reset_tuner,
>>        .link_tuner             = rt2800_link_tuner,
>>        .write_tx_desc          = rt2800pci_write_tx_desc,
>> -       .write_tx_data          = rt2800pci_write_tx_data,
>> +       .write_tx_data          = rt2x00pci_write_tx_data,
>> +       .add_tx_datadesc        = rt2800pci_add_tx_datadesc,
>>        .write_beacon           = rt2800pci_write_beacon,
>>        .kick_tx_queue          = rt2800pci_kick_tx_queue,
>>        .kill_tx_queue          = rt2800pci_kill_tx_queue,
>
> Doesn't the name write_tx_datadesc make more sense?
>

The names are equivalent to me. But if that name makes more sense to
you then I have no problem with changing the name of the callback
function.

---
Gertjan
