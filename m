Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from erley.org ([97.107.129.9]:46112 "EHLO remote.erley.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566AbbAOVNk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 16:13:40 -0500
Message-ID: <54B82C0F.8070503@erley.org> (sfid-20150115_221344_658896_A1DEEF38)
Date: Thu, 15 Jan 2015 15:07:27 -0600
From: Pat Erley <pat-lkml@erley.org>
MIME-Version: 1.0
To: Mike Purvis <mpurvis@clearpathrobotics.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Delivery Status Notification (Failure)
References: <CACsJT9OOBcYNhNG6=+Q2EE4VHEvJ8_rJ3fr6gb9_3P4KpPPX3g@mail.gmail.com> <f46d043c061e8dd5c9050cb5990c@google.com> <CACsJT9M9LcHEuEa2mgAB2taYATZq4j_NeLq78w+=-VBvOw1NGw@mail.gmail.com> <54B82598.9060403@erley.org> <CACsJT9NHO=AZLTFqCN+R1wc_PMrmEonboS+kv1_o6O+xe0Yvig@mail.gmail.com>
In-Reply-To: <CACsJT9NHO=AZLTFqCN+R1wc_PMrmEonboS+kv1_o6O+xe0Yvig@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/15/2015 03:00 PM, Mike Purvis wrote:
> Hi Pat,
>
> It's a good guess, but I don't think that's the case, in part because
> the 6235 is a 2x2 MIMO module— the antennas are MAIN/AUX, not WIFI/BT.
>
> I actually did encounter an Azurewave module which was set up that
> way, and both portions came up on the Gigabyte motherboard— I would
> have kept using that module, but there was a supply availability
> issue, the wifi performance was very poor, and I was interested in
> using a MIMO part.

Any chance you can plug the card back into the system it worked in and
catch the lspci and lsusb outputs?  I think you might be surprised.

Wifi and BT can share antennas using something called bluetooth
co-exist (bt_coex is the iwlwifi module parameter to enable/disable
it).

I did some quick googling, and there are references to the 6235 modules
requiring a USB enabled mini-pcie slot.

>
> On 15 January 2015 at 15:39, Pat Erley <pat-lkml@erley.org> wrote:
>> On 01/15/2015 01:34 PM, Mike Purvis wrote:
>>>
>>> I'm having an issue with the Centrino Advanced-N 6235 module. I'm running
>>> Ubuntu Trusty, and I've tried both the 3.13 and 3.16 kernels. Haven't yet
>>> tried 3.18.
>>>
>>> What's weirdest about it is that the module actually works with full
>>> functionality on an Advantech AIMB-274 (Q87 chipset) with the described
>>> software configuration. However, when I plug the module into either a
>>> Gigabyte
>>> J1800N or an ASRock IMB-152 (J1900), I get no bluetooth— no hci0 device
>>> comes up at all in hciconfig dev or rfkill list.
>>
>>
>> I'd guess that the 6235 module has WLAN on the pci-e connector portion,
>> and Bluetooth on the USB portion.  Check the docs on the board you're
>> plugging it into, and I bet the mini-pcie connector doesn't have the
>> USB side wired up, or it's disabled in(or by) the bios?
>>
>>>
>>> My sense is that the 6235 is a very popular module, and low-cost celeron
>>> motherboards are also pretty popular, so there must be others who have run
>>> into this. Maybe people just don't use bluetooth, or don't expect it to
>>> work on Linux?
>>>
>>> Anyhow, here is a gist with the dmesg boot log and lshw output:
>>>
>>> https://gist.github.com/mikepurvis/ee7bc8fb85ff7ae64a9d
>>>
>>> Looks like there's a crash in there related to intel integrated graphics—
>>> could this be a cause? This is a headless machine, so disabling graphics
>>> completely is on the table, if someone can suggest a good way to go
>>> about that. Any other ideas as to what's going on here?
>>>
>>> Thanks muchly.
>>>
>>>    --
>>> Mike Purvis | Clearpath Robotics, Inc.
>>> 1425 Strasburg Road, Unit 2A , Kitchener, Ontario, N2R 1H2
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

