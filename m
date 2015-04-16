Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:35525 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbbDPRCG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2015 13:02:06 -0400
Received: by obbfy7 with SMTP id fy7so46119879obb.2
        for <linux-wireless@vger.kernel.org>; Thu, 16 Apr 2015 10:02:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALhHN=pDDwx=AA=wnkbqrckXCu4JnBvJ=iDv=6MNrygVc73fNw@mail.gmail.com>
References: <1428911141-6534-1-git-send-email-janusz.dziedzic@tieto.com>
	<1428911141-6534-2-git-send-email-janusz.dziedzic@tieto.com>
	<CAFuUQkhQeCwP098DH7_R4mNCvrJ7WxdT7wnHi52DSOKm8c0k1Q@mail.gmail.com>
	<CALhHN=pefUssihniviRiBWg+EU2wYp3excwodJBDt1+H0tiiHQ@mail.gmail.com>
	<CAFuUQkieJ0CC83wPFm=c_gA5a6OzdbWBF-0EaDL0N=nNAsU2_g@mail.gmail.com>
	<CALhHN=pDDwx=AA=wnkbqrckXCu4JnBvJ=iDv=6MNrygVc73fNw@mail.gmail.com>
Date: Thu, 16 Apr 2015 10:02:05 -0700
Message-ID: <CAFuUQkhhUVshtsuuEVJuTEAwejq6D2fPUnF5rsSnSynaCni4Fg@mail.gmail.com> (sfid-20150416_190210_907584_DC93F9B7)
Subject: Re: [RFC 2/2] ath10k: don't disable PS when not connected
From: YanBo <dreamfly281@gmail.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 15, 2015 at 9:35 PM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
> On 15 April 2015 at 19:10, YanBo <dreamfly281@gmail.com> wrote:
>> On Tue, Apr 14, 2015 at 10:00 PM, Janusz Dziedzic
>> <janusz.dziedzic@tieto.com> wrote:
>>> On 15 April 2015 at 00:45, YanBo <dreamfly281@gmail.com> wrote:
>>>> On Mon, Apr 13, 2015 at 12:45 AM, Janusz Dziedzic
>>>> <janusz.dziedzic@tieto.com> wrote:
>>>>> Don't disable PS while we are not connected.
>>>>> In other case we will get higher power consumption.
>>>>>
>>>>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>>>>> ---
>>>>>  drivers/net/wireless/ath/ath10k/mac.c | 8 +++++++-
>>>>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
>>>>> index 52c5b1f..b896dd4 100644
>>>>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>>>>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>>>>> @@ -1730,7 +1730,13 @@ static int ath10k_mac_vif_setup_ps(struct ath10k_vif *arvif)
>>>>>                 enable_ps = false;
>>>>>         }
>>>>>
>>>>> -       if (enable_ps) {
>>>>> +       if (!arvif->is_started) {
>>>>> +               /* enable power save mode while not connected,
>>>>> +                * in other case after iface up we will get
>>>>> +                * higher power consumption - firmware design
>>>>> +                */
>>>>> +               psmode = WMI_STA_PS_MODE_ENABLED;
>>>>> +       } else if (enable_ps) {
>>>>>                 psmode = WMI_STA_PS_MODE_ENABLED;
>>>>>                 param = WMI_STA_PS_PARAM_INACTIVITY_TIME;
>>>>>
>>>>> --
>>>>
>>>> What the expectation behavior after we enable the
>>>> WMI_STA_PS_MODE_ENABLED at Idle status?
>>>> Is there any effect for TX or RX chain after set it?
>>>>
>>>
>>> First I think that WMI_STA_PS_MODE_ENABLED is important only when we
>>> are connected.
>>> But, I see current consumption drop in my test environtment from 88mA
>>> to 33mA when:
>>> 1) load driver, iface up
>>> 2) disconnect network, iface down, iface up
>>> So, seems WMI_STA_PS_MODE_ENABLED do something more in FW (not only
>>> standard PS enable/disable when
>>> connected to AP). Probably someone from FW team should answer that, if
>>> that is a feature or a bug.
>>>
>> I guess the chip enter Idle  mode power save  after set this,  did you
>> run the the
>> test on QCA61XX or QCA 98XX?   Can it still auto scan to get all the APs around
>> it, cause for IMPS mode it will only looks in its existing profile
>> list and sends a probe request,
>> with SSID specified in profile for what I know
>>
> I see iw scan works correctly after iface up (same scan results like ath9k):
>
> In my laptop I have 3 cards
> wlan0 - ath9k
> wlan1 - QCA9888
> wlan4 - QCA6174
>
> janusz@dell6430:~$ sudo iw wlan0 scan dump|grep SSID |wc -l
> 0
> janusz@dell6430:~$ sudo iw wlan0 scan |grep SSID| wc -l
> 21
> janusz@dell6430:~$ sudo ifconfig wlan0 down
>
> janusz@dell6430:~$ sudo iw wlan1 scan dump|grep SSID|wc -l
> 0
> janusz@dell6430:~$ sudo iw wlan1 scan |grep SSID|wc -l
> 21
> janusz@dell6430:~$ sudo ifconfig wlan1 down
>
> janusz@dell6430:~$ sudo iw wlan4 scan dump|grep SSID|wc -l
> 0
> janusz@dell6430:~$ sudo iw wlan4 scan |grep SSID|wc -l
> 22
>
> Should I run any other scan tests?
>

Thanks for the verification, I also get the confirmation that the card will
leave IMPS mode when scanning, so it works as expected.

BR /Yanbo
