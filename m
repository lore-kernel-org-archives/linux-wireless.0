Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:60531 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab3LKTSu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Dec 2013 14:18:50 -0500
Received: by mail-ea0-f173.google.com with SMTP id o10so3119721eaj.32
        for <linux-wireless@vger.kernel.org>; Wed, 11 Dec 2013 11:18:49 -0800 (PST)
Message-ID: <52A8BA8B.6040104@gmail.com> (sfid-20131211_201854_557275_9459AC3B)
Date: Wed, 11 Dec 2013 20:18:35 +0100
From: Jeremy Johnathan Rodent <rat.o.drat@gmail.com>
MIME-Version: 1.0
To: Emmanuel Grumbach <egrumbach@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Random lock-ups (?) of Centrino Ultimate-N 6300 (iwlwifi)
References: <52A40FE5.30004@gmail.com> <CANUX_P0iO2YdDGO6_GcBOA2A6QvUfYQNz8E2L2SjLpMPYYviuQ@mail.gmail.com>
In-Reply-To: <CANUX_P0iO2YdDGO6_GcBOA2A6QvUfYQNz8E2L2SjLpMPYYviuQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 08.12.2013 08:19, Emmanuel Grumbach wrote:
> On Sun, Dec 8, 2013 at 8:21 AM, Jeremy Johnathan Rodent
> <rat.o.drat@gmail.com> wrote:
>> Hello.
>>
>> I'd like to apologize in advance, if I shouldn't report such issues to this
>> mailing list. I was told this is a good place for bug reports associated
>> with Linux kernel modules for wireless devices.
>>
>> I have a ThinkPad X201 Tablet, which I recently bought used. This laptop has
>> an Intel Centrino Ultimate-N 6300 wireless 802.11abgn card, which is
>> supported via the iwlwifi module and a firmware image. I'm using Arch Linux
>> on it (i haven't tried a different OS yet), and so have fairly recent and
>> vanilla kernel and firmware packages (the policy of this distribution is to
>> have the latest packages marked as stable by upstream and only do patching
>> if it's required to build the package or make it work with others).
>>
>> Since some time I've been struggling with my laptop's wifi card randomly
>> locking up (at least, I think the hardware locks up), usually after at least
>> a few hours of usage. The initial symptom of such an event is the wifi card
>> ceasing to work. Afterwards, each few seconds the computer "freezes" for a
>> few other seconds. I can stop these freezes by flipping a radio disable
>> switch, which causes rfkill's hard block on all wireless devices. However,
>> flipping it back to unblock doesn't cause the wifi card to function, only
>> bringing back aforementioned freezes.
>>
>> These lock-ups happen completely randomly. I'm using this laptop a lot, over
>> 10 hours daily, and there are days when there is no problem. I even managed
>> to use it a week without problems. Other times it can happen as much as 4
>> times daily. Twice it happened straight after boot, but otherwise it happens
>> after at least a few hours of usage.
>>
>> I at first thought, that it might be associated with the amount of data sent
>> in and out of the interface, but there was no correlation. I specially
>> tested this by moving large amounts of data within my local network for a
>> few hours. Next thing I considered, was that the device overheats due to
>> radiation (I'm usually very close to my AP, and have the default tx-power
>> setting, which is 15dBm). But these issues happened no matter how far I was
>> and changing tx-power to smallest possible value didn't help. I also thought
>> this might be because the device accumulates heat after a few hours, but
>> recently I got the lock-up 3 minutes after boot, which happened after the
>> laptop was laying all night powered off.
>>
>> Since this issues started, I've considered many packages (such as those
>> network-related and kernel modules like tp-smapi) as the culprits
>> (especially those installed or updated around the time of the first
>> occurrence) and tried uninstalling or downgrading. I also tried removing any
>> module options and udev rules I made before the lock-ups started. Again, no
>> success.
>>
>> Finally, I recently tried a few options of the iwlwifi module
>> (11n_disable=1, swcrypto=1, bt_coex_active=0). None of those helped, though
>> after setting bt_coex_active=0 I had 2 days of peace. I haven't tried the
>> power-saving ones yet, though.
>>
>> My only remaining clue is that this seems more likely to happen if I'm on
>> battery power, especially when the battery has little charge. So I guess
>> this might be associated with power management.
>>
>> I have to say, I don't have the knowledge to understand what's really going
>> on, how to read the ring buffer output or how to debug such an issue. But it
>> seems to me, looking at the dmesg output, that the driver has some issue,
>> the device is reinitialized, which fails. Hence why I wrote that the device
>> locks up.
>>
>> I've attached output of dmesg captured right after a recent lock-up. I hope
>> I have a recent enough kernel for this to be useful. I also attached outputs
>> of dmidecode and lspci -vvvv, and /proc/config.gz, in case this information
>> would be useful.
>>
>> Please tell me if anything else is needed. I'm willing to invest some time
>> and have no problem with things like compiling a custom kernel, using gdb.
>> The only problem here is that I have no idea how I can trigger this, and can
>> never be sure if the issue went away.
>>
>> I thank in advance for any help.
>>
> can you please apply this and report back?
>
> diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c
> b/drivers/net/wireless/iwlwifi/pcie/tx.c
> index c5746ed..0a1f39c 100644
> --- a/drivers/net/wireless/iwlwifi/pcie/tx.c
> +++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
> @@ -708,10 +708,6 @@ void iwl_pcie_tx_start(struct iwl_trans *trans,
> u32 scd_base_addr)
>          reg_val = iwl_read_direct32(trans, FH_TX_CHICKEN_BITS_REG);
>          iwl_write_direct32(trans, FH_TX_CHICKEN_BITS_REG,
>                             reg_val | FH_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN);
> -
> -       /* Enable L1-Active */
> -       iwl_clear_bits_prph(trans, APMG_PCIDEV_STT_REG,
> -                           APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
>   }
>
>   void iwl_trans_pcie_tx_reset(struct iwl_trans *trans)
Sorry it took so long.
I've built 3.12.3 with this patch applied. What now?
