Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49801 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab3COABR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Mar 2013 20:01:17 -0400
Message-ID: <514264C6.2080204@openwrt.org> (sfid-20130315_010121_455283_EE5A574E)
Date: Fri, 15 Mar 2013 01:01:10 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com
Subject: Re: [PATCH 3.8 1/3] ath9k_hw: fix calibration issues on chainmask
 that don't include chain 0
References: <1358715322-46447-1-git-send-email-nbd@openwrt.org> <5138A4C8.7040500@neratec.com> <5138AB4A.7000405@openwrt.org> <5138B656.5090408@neratec.com> <513996DE.6030500@neratec.com> <5139B35D.9060803@neratec.com> <5139DCAA.8050003@openwrt.org> <513D78C8.5020708@neratec.com> <513DA74B.7000205@neratec.com>
In-Reply-To: <513DA74B.7000205@neratec.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-03-11 10:43 AM, Wojciech Dubowik wrote:
> On 03/11/2013 07:25 AM, Wojciech Dubowik wrote:
>> On 03/08/2013 01:42 PM, Felix Fietkau wrote:
>>> On 2013-03-08 10:46 AM, Wojciech Dubowik wrote:
>>>> On 03/08/2013 08:44 AM, Wojciech Dubowik wrote:
>>>>> On 03/07/2013 04:46 PM, Wojciech Dubowik wrote:
>>>>>> On 03/07/2013 03:59 PM, Felix Fietkau wrote:
>>>>>>> On 2013-03-07 3:31 PM, Wojciech Dubowik wrote:
>>>>>>>> There is a regression introduced by this patch when power save is
>>>>>>>> off on
>>>>>>>> the station for idle checks.
>>>>>>>> I have AR9590 station with rx and tx chain set to 0x1 connected
>>>>>>>> to legacy AP (based on Ar9390) with RF cable and 40dB attenuator.
>>>>>>>>
>>>>>>>> Before this patch in connection polling the station was properly
>>>>>>>> sending
>>>>>>>> null function to check whether AP is still there. After this patch
>>>>>>>> it sends
>>>>>>>> broadcast probe request which is anyway wrong or some 16 or so 
>>>>>>>> packets
>>>>>>>> of random data (rarely). It manifests itself in lost connection
>>>>>>>> because
>>>>>>>> there
>>>>>>>> is no ack from AP which is expected for null function.
>>>>>>>>
>>>>>>>> I have been following skb's up to the descriptor setting in ath9k
>>>>>>>> and it was
>>>>>>>> all ok i.e. proper null function with valid addresses.
>>>>>>>>
>>>>>>>> I have been bisecting it twice because it doesn't make much sense
>>>>>>>> but maybe
>>>>>>>> it's a HW issue?
>>>>>>> You're right, it does not make much sense. I can't figure out how 
>>>>>>> this
>>>>>>> patch could possibly change the runtime behavior with tx 
>>>>>>> chainmask set
>>>>>>> to 0x1. Have you tried reverting this patch in a current build to
>>>>>>> see if
>>>>>>> that fixes the issue?
>>>>>> It does fix it. I will check tomorrow whether it's only AR9590 or 
>>>>>> also
>>>>>> previous revisions. I will also try with different chainmasks. I will
>>>>>> have
>>>>>> to rescrew my setup...
>>>>>>
>>>>> I have been doing some tests and it seems to affect both AR9390 and
>>>>> AR9590.
>>>>> To summarize: sta doesn't send null function but broadcast probe
>>>>> request or
>>>>> corrupted frames in idle checking routine when power save is off and
>>>>> only some
>>>>> antennas are selected for transmission.
>>>>> So for example when I set antenna mask 7 i.e. all available it works
>>>>> ok but with
>>>>> mask 1, 3 or 6 not. When I swith power save it's all ok no matter what
>>>>> mask I use.
>>>>>
>>>>> Thing with power save on is that before it goes to idle check it will
>>>>> go to sleep since
>>>>> there is no traffic anyway, then we get beacon miss, it wakes up and
>>>>> it sends null
>>>>> function. I guess waking up is reinitializing sth in a chip which
>>>>> doesn't occur in my
>>>>> scenario.
>>>>> HW issue?
>>>> It will also work if I set user specified antenna masks instead of hw
>>>> capabilities.
>>> What do you mean with that? How do you set the rx and tx chainmasks if
>>> not via antenna masks? debugfs?
>> I do it with iw set antenna.
> This could be the solution if you are ok with it.
> Wojtek
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c 
> b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
> index 4cc1394..58c6256 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
> @@ -1023,7 +1023,7 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
> AR_PHY_AGC_CONTROL_FLTR_CAL   |
> AR_PHY_AGC_CONTROL_PKDET_CAL;
> 
> -       ar9003_hw_set_chain_masks(ah, ah->caps.rx_chainmask, 
> ah->caps.tx_chainmask);
> +       ar9003_hw_set_chain_masks(ah, ah->rxchainmask, ah->txchainmask);
I will do some testing, but I think this will probably be equivalent to
a revert of the patch.

- Felix

