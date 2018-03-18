Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:51294 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750766AbeCRTQA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Mar 2018 15:16:00 -0400
Received: by mail-wm0-f53.google.com with SMTP id h21so11514870wmd.1
        for <linux-wireless@vger.kernel.org>; Sun, 18 Mar 2018 12:15:59 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: Add support for getting nvram contents from EFI
 variables
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
References: <20180311214751.12769-1-hdegoede@redhat.com>
 <5AA6409E.6050300@broadcom.com>
 <e98afbfb-35d0-8ae7-1377-d5e31a76dc4c@redhat.com>
 <5AA8324C.4030505@broadcom.com>
 <999c82a3-f886-acdd-32d1-205c1503ceb2@redhat.com>
 <5AAC2C07.90208@broadcom.com>
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <78f7d2db-a8af-1713-805d-97fa28b2056f@redhat.com> (sfid-20180318_201604_067856_D987B3DF)
Date: Sun, 18 Mar 2018 20:15:57 +0100
MIME-Version: 1.0
In-Reply-To: <5AAC2C07.90208@broadcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 16-03-18 21:41, Arend van Spriel wrote:
> On 3/14/2018 9:43 AM, Hans de Goede wrote:
>> Hi,
>>
>> On 13-03-18 21:19, Arend van Spriel wrote:
>>> On 3/12/2018 10:45 AM, Hans de Goede wrote:
>>
>> <snip>
>>
>>>>> Actually had a Sony device with nvram in EFI. Why not just drop this
>>>>> optimization.
>>>>
>>>> Ok, do you know if that variable had the same name and guid though ?
>>>> Because
>>>> if it doesn't then this code is not going to work for the Sony case.
>>>
>>> If I am not mistaken the name and guid are defined by Broadcom/Microsoft.
>>>
>>>> Anyways the overhead is small and this only runs once, so I will drop
>>>> the
>>>> check for v2.
>>>
>>> Due to XV issue we may want to keep the check for now.
>>
>> If we're going to do ccode=ALL replacement based on a dmi-model
>> table then there is no need to keep the check just for the XV stuff.
>>
>> <snip>
>>
>>>>> Also simply selecting XV instead is not correct. There is not just one
>>>>> worldwide domain in the regulatory database of the firmware image.
>>>>
>>>> Right, I've read elsewhere that "X2" is the right magic value to use and
>>>> I've tested that on some other devices and that does seem to work.
>>>>
>>>> I've also seen "XY" but the other Asus devices all use "XV" and that
>>>> works (makes channel 13 work) so it seemed like a good value.
>>>>
>>>> Can you help me understand this problem a bit better? Is the problem
>>>> with
>>>> "XV" that it may not work with all firmware versions, so on some
>>>> firmware
>>>> versions it will be as bad as using ALL which the firmware also does not
>>>> understand? Or do all firmwares understand XV / XY / X2 but are there
>>>> subtle differences?
>>>
>>> The firmware has a per-device recipe of what should be in the
>>> regulatory database and per release branch it can differ. So for the
>>> same device customer A could get XV and XY in the firmware regdb and
>>> customer B could get XY and X2.
>>
>> Hmm, so whether XV, XY and/or X2 works depends on the firmware used,
>> not on the model of the laptop? That means that:
>>
>>>> So how do you suggest we deal with this?
>>>>
>>>> One solution I see is:
>>>>
>>>> 1) check for ccode=ALL
>>>> 2) if found use DMI strings to match the specific model and set a
>>>> different
>>>> ccode based on the model (so for now use XV for the T200TA only)
>>>> 3) if found and the model is not known, warn about this and do nothing
>>>>
>>>> Would that work for you ?
>>>
>>> I think so.
>>
>> This is no good, because the model of the laptop and which firmware build
>> gets used are not really coupled. I think instead it would make more sense
>> to assume the firmware builds from linux-firmware and have a table of
>> which ccode=ALL override to use based on wifi-chip model, so in the
>> case of the T200TA, map brcmfmac43340-sdio to a ccode=XV override
>> (if ccode=ALL is present).
> 
> For our customers, ie. OEM/ODM, we provide a particular device and with it comes a firmware build with a regulatory database aka CLM. So in that project flow the laptop/phone/whatever model and firmware are really coupled. However, for linux-firmware the story is more as you depict it, because we simply do not know in what kind of device the chip will be used.
> 
>> So basically what I'm suggesting is:
>>
>> static const char * const ccode_all_map[][2] = {
>>         { "brcm/brcmfmac43241b4-sdio.txt", "XV\n" }, /* Tested on Asus
>> T100TA, T100CHI */
>>         { "brcm/brcmfmac43340-sdio.txt", "XV\n" },   /* Tested on Asus
>> T200TA */
>> };
>>
>> ...
>>
>>      ccode = strnstr((char *)data, "ccode=ALL", data_len);
>>      if (ccode) {
>>          /* lookup fwctx->nvram_name in ccode_all_map */
>>          /* if found patch in override string */
>>          /* else brcmf_info("EFI nvram contains ccode=ALL and %s is
>> missing from ccode-map, please report\n", fwctx->nvram_name) */
>>      }
>>
>> So we actually decide what to replace all with based on the
>> firmware name, rather then on the laptop model, does that make
>> sense?
> 
> Somewhat. However, I am leaning to a different approach. The ALL country code should not be supported in the firmware so it would fallback to something else and I would like to know what. The country code can be retrieved and set using firmware command. So I would like to retrieve it in brcmf_cfg80211_attach() just before doing the brcmf_setup_wiphy_bands() call. I want to know if it returns ALL or some other fallback country code. At this stage I am not sure what the criteria has to be to set the country code to XV.

Ok.

>>> I hope to get some more clarification from our regulatory team about
>>> the use of ALL and XV. Could you tell me what happens with T200TA when
>>> you leave ccode=ALL in place. What output do you get from "iw list"?
>>> Only channels 1 to 11 and no 5G? Or does it only have 2G.
>>
>> With ccode=ALL in place, I do see channel 13, but not 14 and channel 13
>> does
>> not work (the machine does not associate with my AP which is configured
>> at chan 13)
>> if I change it to "XV" then channel 13 does work, and shortly after
>> associating
>> channel 14 also shows up in the "iwlist wlan0 freq" output.
> 
> So XV seems to be the worldwide country code used for PC-OEMs. So that seems ok-ish. I would like to verify whether the firmwares released to linux-firmware all have XV in the firmware regulatory database.
> 
> Channel 14 is only applicable for Japan as far as I know. So that is weird unless your AP has JP in its beacon.

So as asked I've retried using "iw list" instead of "iwlist". here is
the output on a brcmfmac43340 device when not associated to any AP.
I've tried with ccode=ALL / XV / X2 the ccode seems to not matter:

                         * 2412 MHz [1] (20.0 dBm)
                         * 2417 MHz [2] (20.0 dBm)
                         * 2422 MHz [3] (20.0 dBm)
                         * 2427 MHz [4] (20.0 dBm)
                         * 2432 MHz [5] (20.0 dBm)
                         * 2437 MHz [6] (20.0 dBm)
                         * 2442 MHz [7] (20.0 dBm)
                         * 2447 MHz [8] (20.0 dBm)
                         * 2452 MHz [9] (20.0 dBm)
                         * 2457 MHz [10] (20.0 dBm)
                         * 2462 MHz [11] (20.0 dBm)
                         * 2467 MHz [12] (20.0 dBm)
                         * 2472 MHz [13] (20.0 dBm)
                         * 2484 MHz [14] (disabled)

                         * 5170 MHz [34] (disabled)
                         * 5180 MHz [36] (20.0 dBm)
                         * 5190 MHz [38] (20.0 dBm)
                         * 5200 MHz [40] (20.0 dBm)
                         * 5210 MHz [42] (20.0 dBm)
                         * 5220 MHz [44] (20.0 dBm)
                         * 5230 MHz [46] (20.0 dBm)
                         * 5240 MHz [48] (20.0 dBm)
                         * 5260 MHz [52] (20.0 dBm) (radar detection)
                         * 5280 MHz [56] (20.0 dBm) (radar detection)
                         * 5300 MHz [60] (20.0 dBm) (radar detection)
                         * 5320 MHz [64] (20.0 dBm) (radar detection)
                         * 5500 MHz [100] (20.0 dBm) (radar detection)
                         * 5520 MHz [104] (20.0 dBm) (radar detection)
                         * 5540 MHz [108] (20.0 dBm) (radar detection)
                         * 5560 MHz [112] (20.0 dBm) (radar detection)
                         * 5580 MHz [116] (20.0 dBm) (radar detection)
                         * 5600 MHz [120] (20.0 dBm) (radar detection)
                         * 5620 MHz [124] (20.0 dBm) (radar detection)
                         * 5640 MHz [128] (20.0 dBm) (radar detection)
                         * 5660 MHz [132] (20.0 dBm) (radar detection)
                         * 5680 MHz [136] (20.0 dBm) (radar detection)
                         * 5700 MHz [140] (20.0 dBm) (radar detection)
                         * 5720 MHz [144] (disabled)
                         * 5745 MHz [149] (disabled)
                         * 5765 MHz [153] (disabled)
                         * 5785 MHz [157] (disabled)
                         * 5805 MHz [161] (disabled)
                         * 5825 MHz [165] (disabled)

After connecting to an AP at channel 13 (which requires ccode=XV or ccode=X2
to be visible) this changes to:

                         * 2412 MHz [1] (20.0 dBm)
                         * 2417 MHz [2] (20.0 dBm)
                         * 2422 MHz [3] (20.0 dBm)
                         * 2427 MHz [4] (20.0 dBm)
                         * 2432 MHz [5] (20.0 dBm)
                         * 2437 MHz [6] (20.0 dBm)
                         * 2442 MHz [7] (20.0 dBm)
                         * 2447 MHz [8] (20.0 dBm)
                         * 2452 MHz [9] (20.0 dBm)
                         * 2457 MHz [10] (20.0 dBm)
                         * 2462 MHz [11] (20.0 dBm)
                         * 2467 MHz [12] (20.0 dBm)
                         * 2472 MHz [13] (20.0 dBm)
                         * 2484 MHz [14] (20.0 dBm)

                         * 5170 MHz [34] (20.0 dBm)
                         * 5180 MHz [36] (20.0 dBm)
                         * 5190 MHz [38] (20.0 dBm)
                         * 5200 MHz [40] (20.0 dBm)
                         * 5210 MHz [42] (20.0 dBm)
                         * 5220 MHz [44] (20.0 dBm)
                         * 5230 MHz [46] (20.0 dBm)
                         * 5240 MHz [48] (20.0 dBm)
                         * 5260 MHz [52] (20.0 dBm)
                         * 5280 MHz [56] (20.0 dBm)
                         * 5300 MHz [60] (20.0 dBm)
                         * 5320 MHz [64] (20.0 dBm)
                         * 5500 MHz [100] (20.0 dBm)
                         * 5520 MHz [104] (20.0 dBm)
                         * 5540 MHz [108] (20.0 dBm)
                         * 5560 MHz [112] (20.0 dBm)
                         * 5580 MHz [116] (20.0 dBm)
                         * 5600 MHz [120] (20.0 dBm)
                         * 5620 MHz [124] (20.0 dBm)
                         * 5640 MHz [128] (20.0 dBm)
                         * 5660 MHz [132] (20.0 dBm)
                         * 5680 MHz [136] (20.0 dBm)
                         * 5700 MHz [140] (20.0 dBm)
                         * 5720 MHz [144] (20.0 dBm)
                         * 5745 MHz [149] (20.0 dBm)
                         * 5765 MHz [153] (20.0 dBm)
                         * 5785 MHz [157] (20.0 dBm)
                         * 5805 MHz [161] (20.0 dBm)
                         * 5825 MHz [165] (20.0 dBm)

So it seems that once connected for some reason all channels report the
same flags, maybe a driver bug?

>> As for 5GHz on the T200TA that is really a different topic, I can access
>> 5GHz wifi
>> under Windows but not under Linux, the channels are there in "iwlist
>> wlan0 freq"
>> but "wlist wlan0 scan" only shows 2.4 GHz APs. I've tried replacing the
>> nvram
>> with the file from the Windows partition referenced by the .inf file there,
>> but that does not help. I'm not sure yet if this is a firmware / nvram /
>> driver
>> problem, so as said this really is a different topic.

Or not (not a different topic), while running the above tests with ccode=XV vs
ccode=X2 I noticed something very interesting. Although the reported channels
in iwlist do not change, the APs seem while scanning do change. With ccode=X2
I can see both my home AP at channel 13 and the 5GHz channel of my home ap
(chan 100). So it seems that with the brcmfmac43340 + current linux-firmware
we need ccode=X2. This might be related to:
https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/commit/brcm?id=ffdec3f6a5f29eb8a848b6a2417e0a1b45d32fcc
I guess?

So to fix this I have gone ahead for now (in my personal tree) with adding
a firmware-filename -> ccode fixup table. I will post a v2 of the patch
with this (I know this is likely not what you want, but it helps illustrate
the problem).

Note that with the brcmfmac43241b4-sdio.bin firmware ccode=XV works fine
and does see 5GHz APs.

> Could you try iw (which uses nl80211) instead of iwlist (which is old WEXT cruft).

See above.

Regards,

Hans
