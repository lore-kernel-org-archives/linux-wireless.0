Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:43674 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191AbaHYU0R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2014 16:26:17 -0400
Received: by mail-lb0-f180.google.com with SMTP id 10so267181lbg.11
        for <linux-wireless@vger.kernel.org>; Mon, 25 Aug 2014 13:26:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANUX_P0i7jUJ58ZT8pGfT6zMHphjUuF6iENyK=XPrfjgUXUc_Q@mail.gmail.com>
References: <6715079.xd2j4mnUMo@debian64>
	<1408997366.17421.5.camel@dubbel>
	<CANUX_P28E+ubMrzAK45mqs672JFEo7ci=GuBWSm7i3G=WrUfeQ@mail.gmail.com>
	<CANUX_P0i7jUJ58ZT8pGfT6zMHphjUuF6iENyK=XPrfjgUXUc_Q@mail.gmail.com>
Date: Mon, 25 Aug 2014 23:26:15 +0300
Message-ID: <CANUX_P1zeJCHp49DpGtxm4U=RoLee59zz=a4gJwiq+R0JUiOpA@mail.gmail.com> (sfid-20140825_222620_127809_80A28FDA)
Subject: Re: Iwlwifi 3160 AC (firmware?) clashes with CONFIG_IWLWIFI_BCAST_FILTERING
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Luca Coelho <luca@coelho.fi>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 25, 2014 at 11:25 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> On Mon, Aug 25, 2014 at 11:20 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>> Hi Christian,
>>>
>>> I'm not the best person to talk about the iwlwifi firmwares (that would
>>> be Emmanuel, but he is not available now), but I'll try.
>>
>> Here I am - thanks Luca for stepping in.
>>
>>>
>>> On Sat, 2014-08-23 at 00:01 +0200, Christian Lamparter wrote:
>>>> Hello,
>>>>
>>>> I got new hardware. Among the new stuff, there was one
>>>> Intel® Dual Band Wireless-AC 3160. When I tried to connect
>>>> to one (in fact any) of my networks, I was getting the
>>>> following errors:
>>>>
>>>> [ 1021.092378] iwlwifi 0000:01:00.0: Microcode SW error detected.  Restarting 0x82000000.
>>>> [...]
>>>> [ 1021.093935] iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
>>>> [ 1021.093939] iwlwifi 0000:01:00.0: Status: 0x00000000, count: 6
>>>> [ 1021.093942] iwlwifi 0000:01:00.0: Loaded firmware version: 25.223.9.0
>>>> [ 1021.093947] iwlwifi 0000:01:00.0: 0x00000038 | BAD_COMMAND <---
>>>> [ 1021.093951] iwlwifi 0000:01:00.0: 0x00A00220 | uPc
>>>
>>> Where did you get this firmware version? AFAICT the last version
>>> Emmanuel sent to linux-firmware.git is 23.214.9.0 (the one you also
>>> mentioned below).
>>>
>>
>> That's the Core6 FW that I "published" in a side branch in my
>> linux-firmware clone.
>>
>>>
>>>> [...]
>>>> [ 1021.094192] Call Trace:
>>>> [ 1021.094205]  [<ffffffff813ce9bd>] ? dump_stack+0x41/0x51
>>>> [ 1021.094217]  [<ffffffffa0b9cd8b>] ? iwl_trans_pcie_send_hcmd+0x367/0x438 [iwlwifi]
>>>> [ 1021.094226]  [<ffffffffa0b9b52c>] ? iwl_pcie_enqueue_hcmd+0x5e3/0x5fe [iwlwifi]
>>>> [ 1021.094235]  [<ffffffff8105fd4c>] ? finish_wait+0x5d/0x5d
>>>> [ 1021.094250]  [<ffffffffa0d50106>] ? iwl_mvm_send_cmd+0xd/0x22 [iwlmvm]
>>>> [ 1021.094262]  [<ffffffffa0d50160>] ? iwl_mvm_send_cmd_pdu+0x45/0x52 [iwlmvm]
>>>> [ 1021.094273]  [<ffffffffa0d4c5fb>] ? iwl_mvm_configure_bcast_filter.isra.14.part.15+0x36/0x3f [iwlmvm]
>>>>
>>>> (Full log attached below)
>>>>
>>>> What cough my eye was the "BAD_COMMAND" in the error log. I disabled
>>>> "CONFIG_IWLWIFI_BCAST_FILTERING" option and the 3160 is now working.
>>>>
>>>> As far as I can tell, there is already a firmware feature flag:
>>>> "IWL_UCODE_TLV_FLAGS_BCAST_FILTERING" which can be used to
>>>> distinguish whenever the feature is supported or not. But it
>>>> seems to be "stuck on" for the 3160.
>>>
>>> Weird, but it's possible that they set the flag mistakenly for the 3160
>>> firmware.  I'll check this with the firmware team.
>>>
>>
>> Right - we need to check with the firmware team (I already asked - but
>> things take time).
>> I'd say that the firmware mistakenly advertises support for this
>> feature. I bet that 3160 doesn't support it, but that's yet to be
>> checked.
>> Actually, we do have an internal ticket with this issue - but I don't
>> know if it was on 3160 or on 7260. Your report explicitly says that
>> you saw this on 3160, so I am only now connecting between the dots. I
>> can't check the internal bug since I am on vacation right now. Note
>> that 3160 is much less common than 7260 - so this kind of stupid bugs
>> can stay unseen for a fairly long time...
>>
>>
>>>
>>>> Regards
>>>> Christian
>>>>
>>>> BTW: I also tried the older "23.214.9.0" firmware too.
>>>> => Same result [Doesn't work with BCAST_FILTERING enabled].
>>>
>>> Thanks a lot for your report! Broadcast filtering is not set by default,
>>> so I haven't seen that bug before.
>
> One more thing - Chrisian, please open a bug on bug as described here:
> http://wireless.kernel.org/en/users/Drivers/iwlwifi#Bugzilla
>
> This can help to track things. Thanks.

Typo - Christian - sorry to have misspelled your name.
