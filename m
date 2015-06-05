Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:32820 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbbFEWAh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2015 18:00:37 -0400
Received: by labpy14 with SMTP id py14so63216812lab.0
        for <linux-wireless@vger.kernel.org>; Fri, 05 Jun 2015 15:00:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <30794f68f6374c509f1f98002ff7a7ab@SC-EXCH02.marvell.com>
References: <141c66f2950e4832a2bd99064db75970@SC-EXCH02.marvell.com>
	<557073D2.4080704@candelatech.com>
	<a244e659293f480fb9a53ee6a83f03bf@SC-EXCH02.marvell.com>
	<55712547.4010408@candelatech.com>
	<30794f68f6374c509f1f98002ff7a7ab@SC-EXCH02.marvell.com>
Date: Fri, 5 Jun 2015 15:00:35 -0700
Message-ID: <CAAnMG+NaQ8YzC6g2X-1odoWmMJO7edzfFqUPaWBi3cn7iLF2sw@mail.gmail.com> (sfid-20150606_000040_597650_598C76F2)
Subject: Re: [PATCH] mwlwifi: Initial submission of wireless driver to mainline
From: Alexis Green <agreen@cococorp.com>
To: David Lin <dlin@marvell.com>
Cc: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Pete Hsieh <peteh@marvell.com>,
	Chor Teck Law <ctlaw@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Are there plans to add support for 802.11s mesh point mode?

On Fri, Jun 5, 2015 at 8:09 AM, David Lin <dlin@marvell.com> wrote:
>> On 06/05/2015 12:29 PM, Ben Greear wrote:
>> On 06/04/2015 07:41 PM, David Lin wrote:
>> >> On 06/03/2015 09:55 PM, David Lin wrote:
>> >>> Hi all,
>> >>>
>> >>>   Herewith, I am submitting the Linux driver for WRT1900AC. The
>> work
>> >>> was initially developed as part of openwrt effort and maintained on
>> >>> https://github.com/kaloz/mwlwifi, thanks to the host where it is
>> >>> nurtured.
>> >>>
>> >>>   Recently, I have also patched it to pass checkpatch.pl so that it
>> >>> can be qualified for mainline.
>> >>>
>> >>>   This is still work in progress, with 8864 chipset more mature and
>> >>> tested, while 8897 for the similar use case is added recently. We
>> >>> will continue to maintain and enhance it.
>> >>>
>> >>> We hope the community will welcome this initial submission!
>> >>
>> >> Do you have any notes on what features this driver/NIC provides?
>> >>
>> >> Does it require firmware, and if so, is source available?
>> >>
>> > Support both 11b/g/a/n/ac AP mode, and STA mode (though the primary use
>> > case is AP). Driver matches most features in mac80211 and
>> > hostapd/supplicant. All basic securities mode have been validated.
>> >
>> > Yes, it will require firmware microcode. Matching "binary" is reprovided as a
>> > separate .bin file(s) for each chip. Source codes of chip-dependent microcode
>> > will not be provided.
>>
>> Can it do multiple virtual stations (and other virtual device combinations)?
>>
>> With ath10k, for instance, there is a complex firmware between the host and
>> the NIC hardware, so any bugs and limitations in the firmware make it almost
>> impossible to add interesting features or fix bugs w/out being able to modify
>> the firmware source.
>>
>> Any comments on how 'thick' the marvell firmware is?
>>
> Yes, the partitioning technically allows multiple logical interfaces. However, this open source driver is not yet developed for many combinations, yet.
>
> It is hard to comment about "thickness" of the firmware :) All (most?) 802.11 mgmt packets are handled in host driver. Think of microcode as part of hardware or controlling/abstracting the hardware.
>
> Thanks,
> David
>>
>> --
>> Ben Greear <greearb@candelatech.com>
>> Candela Technologies Inc  http://www.candelatech.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
