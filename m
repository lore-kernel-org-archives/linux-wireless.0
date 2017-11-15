Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:53775 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932208AbdKOKgw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Nov 2017 05:36:52 -0500
Received: by mail-qt0-f177.google.com with SMTP id n61so33206597qte.10
        for <linux-wireless@vger.kernel.org>; Wed, 15 Nov 2017 02:36:52 -0800 (PST)
Subject: Re: mesh point and ap mode on same interface
To: Kalle Valo <kvalo@qca.qualcomm.com>
References: <e6b02c56-38c7-323e-2bc9-e2b4276b654c@tu-bs.de>
 <cc8baced-bd74-5703-d885-6ec444eb62ce@candelatech.com>
 <43bf6a27-be58-35e4-26fa-5e6b380353ac@bowerswilkins.com>
 <7dc592a5-9381-f715-6ea7-0a8b8deee311@tu-bs.de>
 <CADjYELwdUxEap_z=_HD4DS4FEQ2_2HP3w9cvDU-BTFLoOTDipg@mail.gmail.com>
 <5c04c7fe-8cf8-ddd8-d6a7-f42629586a63@bowerswilkins.com>
 <067d234a-59f0-4175-55af-9354617057b9@tu-bs.de>
 <61192d3b-b4c7-f47e-2ff9-44e17595d6a9@bowerswilkins.com>
 <fc1993f5-8b83-4e74-7866-2adcf318ff5f@tu-bs.de>
 <03700343-7b5c-b21e-8b7b-2ac8c7d3258b@bowerswilkins.com>
 <87po8jhncx.fsf@kamboji.qca.qualcomm.com> <5A0C133E.8080305@broadcom.com>
 <87lgj7hm5e.fsf@kamboji.qca.qualcomm.com>
Cc: Peter Oh <peter.oh@bowerswilkins.com>,
        "Harms, Hannes" <hannes.harms@tu-bs.de>,
        Ben Greear <greearb@candelatech.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A0C18C1.4000507@broadcom.com> (sfid-20171115_113656_173698_DC309611)
Date: Wed, 15 Nov 2017 11:36:49 +0100
MIME-Version: 1.0
In-Reply-To: <87lgj7hm5e.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/15/2017 11:27 AM, Kalle Valo wrote:
> Arend van Spriel <arend.vanspriel@broadcom.com> writes:
>
>> On 11/15/2017 11:01 AM, Kalle Valo wrote:
>>> (adding linux-wireless for a cfg80211 question)
>>>
>>> Peter Oh <peter.oh@bowerswilkins.com> writes:
>>>> On 11/08/2017 04:49 AM, Harms, Hannes wrote:
>>>>
>>>>> I found a solution for the problem:
>>>>>
>>>>> When joining the mesh with beacon interval  set  to 100
>>>>> both  mesh and ap interface are coming up.
>>>>>
>>>>>> iw mesh0 mesh join my_mesh beacon-interval 100
>>>>>
>>>>> The default beacon interval is 1000 for mesh interfaces.
>>>>> It seems that QCA9880 is not working
>>>>> with different beacon intervals for ap + mesh.
>>>>
>>>> Good to hear that working. But mesh beacon interval 1000 which is
>>>> default value should work. Any mesh beacon intervals of multiple of AP
>>>> beacon intervals are supposed to work.
>>>>
>>>> (In other words, mesh beacon intervals that are not aligned by
>>>> multiple of AP beacon intervals won't work). These are valid for both
>>>> of QCA9880 and QCA4019 as far as I know.
>>>
>>> It would be nice if ath10k could print a warning if the beacon intervals
>>> are not compatible. Or is there a way to enforce the beacon interval
>>> with help of cfg80211 or mac80211?
>>
>> There is beacon interval checking in utility function
>> cfg80211_check_combinations() ->
>> cfg80211_iter_combinations() -> cfg80211_calculate_bi_data() for that.
>
> Nice, that looks useful. Thanks for the tip.

Initally was added by:

commit 0c317a02ca982ca093e71bf07cb562265ba40032
Author: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
Date:   Wed Oct 12 18:26:51 2016 +0530

     cfg80211: support virtual interfaces with different beacon intervals

And last touched by Johannes:

commit 4c8dea638c16141adb046fd2e0cab51dfe43650c
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Fri Oct 21 14:25:13 2016 +0200

     cfg80211: validate beacon int as part of iface combinations

The last commit message has some info on how to use in case of AP/mesh.

>> However, it seems brcmfmac is the only user of that function according
>> to lxr (or elixir).
>
> git-grep says the same.

Yeah. git-grep has not sunk in my system yet ;-)

Regards,
Arend
