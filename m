Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:9376 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932159AbdKOK1p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Nov 2017 05:27:45 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
CC: Peter Oh <peter.oh@bowerswilkins.com>,
        "Harms, Hannes" <hannes.harms@tu-bs.de>,
        Ben Greear <greearb@candelatech.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: mesh point and ap mode on same interface
Date: Wed, 15 Nov 2017 10:27:42 +0000
Message-ID: <87lgj7hm5e.fsf@kamboji.qca.qualcomm.com> (sfid-20171115_112749_729138_3A0FADDA)
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
        <87po8jhncx.fsf@kamboji.qca.qualcomm.com>       <5A0C133E.8080305@broadcom.com>
In-Reply-To: <5A0C133E.8080305@broadcom.com> (Arend van Spriel's message of
        "Wed, 15 Nov 2017 11:13:18 +0100")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 11/15/2017 11:01 AM, Kalle Valo wrote:
>> (adding linux-wireless for a cfg80211 question)
>>
>> Peter Oh <peter.oh@bowerswilkins.com> writes:
>>> On 11/08/2017 04:49 AM, Harms, Hannes wrote:
>>>
>>>> I found a solution for the problem:
>>>>
>>>> When joining the mesh with beacon interval  set  to 100
>>>> both  mesh and ap interface are coming up.
>>>>
>>>>> iw mesh0 mesh join my_mesh beacon-interval 100
>>>>
>>>> The default beacon interval is 1000 for mesh interfaces.
>>>> It seems that QCA9880 is not working
>>>> with different beacon intervals for ap + mesh.
>>>
>>> Good to hear that working. But mesh beacon interval 1000 which is
>>> default value should work. Any mesh beacon intervals of multiple of AP
>>> beacon intervals are supposed to work.
>>>
>>> (In other words, mesh beacon intervals that are not aligned by
>>> multiple of AP beacon intervals won't work). These are valid for both
>>> of QCA9880 and QCA4019 as far as I know.
>>
>> It would be nice if ath10k could print a warning if the beacon intervals
>> are not compatible. Or is there a way to enforce the beacon interval
>> with help of cfg80211 or mac80211?
>
> There is beacon interval checking in utility function
> cfg80211_check_combinations() ->
> cfg80211_iter_combinations() -> cfg80211_calculate_bi_data() for that.

Nice, that looks useful. Thanks for the tip.

> However, it seems brcmfmac is the only user of that function according
> to lxr (or elixir).

git-grep says the same.

--=20
Kalle Valo=
