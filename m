Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:51469 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498AbZKWTSt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 14:18:49 -0500
Received: by ewy19 with SMTP id 19so2185495ewy.21
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2009 11:18:54 -0800 (PST)
Message-ID: <4B0AE012.30307@gmail.com>
Date: Mon, 23 Nov 2009 20:18:42 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 5/6] rt2x00: Properly request tx headroom for alignment
 	operations.
References: <1258960565-26736-1-git-send-email-gwingerde@gmail.com> 	<1258960565-26736-2-git-send-email-gwingerde@gmail.com> <1258960565-26736-3-git-send-email-gwingerde@gmail.com> 	<1258960565-26736-4-git-send-email-gwingerde@gmail.com> <1258960565-26736-5-git-send-email-gwingerde@gmail.com> 	<1258960565-26736-6-git-send-email-gwingerde@gmail.com> <646765f40911222335h63b3500en8f6442482af8b917@mail.gmail.com>
In-Reply-To: <646765f40911222335h63b3500en8f6442482af8b917@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/23/09 08:35, Julian Calaby wrote:
> On Mon, Nov 23, 2009 at 18:16, Gertjan van Wingerde <gwingerde@gmail.com> wrote:
>> Current rt2x00 drivers may result in a "ieee80211_tx_status: headroom too
>> small" error message when a frame needs to be properly aligned before
>> transmitting it.
>> This is because the space needed to ensure proper alignment isn't
>> requested from mac80211.
>> Fix this by adding sufficient amount of alignment space to the amount
>> of headroom requested for TX frames.
>>
>> Reported-by: David Ellingsworth <david@identd.dyndns.org>
>> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
>> Tested-by: David Ellingsworth <david@identd.dyndns.org>
>> ---
>>  drivers/net/wireless/rt2x00/rt2400pci.c   |   30 +++++++++++++++-------------
>>  drivers/net/wireless/rt2x00/rt2500pci.c   |   30 +++++++++++++++-------------
>>  drivers/net/wireless/rt2x00/rt2500usb.c   |   29 ++++++++++++++-------------
>>  drivers/net/wireless/rt2x00/rt2800lib.c   |    7 +----
>>  drivers/net/wireless/rt2x00/rt2800pci.c   |   31 +++++++++++++++--------------
>>  drivers/net/wireless/rt2x00/rt2800usb.c   |   25 ++++++++++++-----------
>>  drivers/net/wireless/rt2x00/rt2x00.h      |    7 ++++++
>>  drivers/net/wireless/rt2x00/rt2x00queue.c |    6 ++--
>>  drivers/net/wireless/rt2x00/rt61pci.c     |   28 ++++++++++++++------------
>>  drivers/net/wireless/rt2x00/rt73usb.c     |   27 +++++++++++++------------
>>  10 files changed, 117 insertions(+), 103 deletions(-)
>>
>> diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
>> index 6e68bc7..f534d70 100644
>> --- a/drivers/net/wireless/rt2x00/rt2400pci.c
>> +++ b/drivers/net/wireless/rt2x00/rt2400pci.c
>> @@ -1623,20 +1624,21 @@ static const struct data_queue_desc rt2400pci_queue_atim = {
>>  };
>>
>>  static const struct rt2x00_ops rt2400pci_ops = {
>> -       .name           = KBUILD_MODNAME,
>> -       .max_sta_intf   = 1,
>> -       .max_ap_intf    = 1,
>> -       .eeprom_size    = EEPROM_SIZE,
>> -       .rf_size        = RF_SIZE,
>> -       .tx_queues      = NUM_TX_QUEUES,
>> -       .rx             = &rt2400pci_queue_rx,
>> -       .tx             = &rt2400pci_queue_tx,
>> -       .bcn            = &rt2400pci_queue_bcn,
>> -       .atim           = &rt2400pci_queue_atim,
>> -       .lib            = &rt2400pci_rt2x00_ops,
>> -       .hw             = &rt2400pci_mac80211_ops,
>> +       .name                   = KBUILD_MODNAME,
>> +       .max_sta_intf           = 1,
>> +       .max_ap_intf            = 1,
>> +       .eeprom_size            = EEPROM_SIZE,
>> +       .rf_size                = RF_SIZE,
>> +       .tx_queues              = NUM_TX_QUEUES,
>> +       .extra_tx_headroom      = 0,
>> +       .rx                     = &rt2400pci_queue_rx,
>> +       .tx                     = &rt2400pci_queue_tx,
>> +       .bcn                    = &rt2400pci_queue_bcn,
>> +       .atim                   = &rt2400pci_queue_atim,
>> +       .lib                    = &rt2400pci_rt2x00_ops,
>> +       .hw                     = &rt2400pci_mac80211_ops,
>>  #ifdef CONFIG_RT2X00_LIB_DEBUGFS
>> -       .debugfs        = &rt2400pci_rt2x00debug,
>> +       .debugfs                = &rt2400pci_rt2x00debug,
>>  #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
>>  };
> 
> Shouldn't the re-formatting of the ops structures (and addition of the
> .debugfs member) go in a separate patch?
> 

Well, strictly speaking is the reformatting the result of the "meat" of this patch.
The addition of the extra_tx_headroom member. However, I can see how the reformatting
distracts the attention from that addition. I'll see if I can do the reformatting as
part of a preparatory patch.

Note that this patch does not add the .debugfs member.

---
Gertjan.
