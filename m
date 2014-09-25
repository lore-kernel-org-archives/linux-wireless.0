Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:41672 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbaIYN0r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2014 09:26:47 -0400
Message-ID: <54241815.6030000@candelatech.com> (sfid-20140925_152650_250648_FD9D3C8B)
Date: Thu, 25 Sep 2014 06:26:45 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC 2/2] ath10k: re-config ht_caps when chainmask is modified.
References: <1411518383-32634-1-git-send-email-greearb@candelatech.com>	<1411518383-32634-2-git-send-email-greearb@candelatech.com>	<CA+BoTQ=fS30xz9KcdBJcioNers6PovOFEeqPCCSFn52HkscXug@mail.gmail.com>	<5422D6CF.10408@candelatech.com>	<CA+BoTQk=X2qVJsY64ZH88h29L6+Y5M9K07nLtzo=0ga1bUsXGw@mail.gmail.com>	<5422F1C2.4090100@candelatech.com> <CA+BoTQkncctvMFx7U0Qzq7+7W2o9Vo5qKcDEi6DUdJTEQWDfAA@mail.gmail.com>
In-Reply-To: <CA+BoTQkncctvMFx7U0Qzq7+7W2o9Vo5qKcDEi6DUdJTEQWDfAA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 09/24/2014 11:23 PM, Michal Kazior wrote:
> On 24 September 2014 18:30, Ben Greear <greearb@candelatech.com> wrote:
>> On 09/24/2014 08:05 AM, Michal Kazior wrote:
>>> On 24 September 2014 16:35, Ben Greear <greearb@candelatech.com> wrote:
>>>> On 09/24/2014 12:51 AM, Michal Kazior wrote:
>>>>> On 24 September 2014 02:26,  <greearb@candelatech.com> wrote:
>>>>> [...]
>>>>>>
>>>>>> +static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k
>>>>>> *ar,
>>>>>> +                                                         bool
>>>>>> use_cfg_chains)
>>>>>>    {
>>>>>>           struct ieee80211_sta_vht_cap vht_cap = {0};
>>>>>>           u16 mcs_map;
>>>>>>           int i;
>>>>>> +       int nrf = ar->num_rf_chains;
>>>>>> +
>>>>>> +       if (use_cfg_chains && ar->cfg_tx_chainmask)
>>>>>> +               nrf = get_nss_from_chainmask(ar->cfg_tx_chainmask);
>>>>>
>>>>>
>>>>> Is use_cfg_chains really necessary here? Is setting tx/rx chainmask to
>>>>> 0x0 make any sense at all? Shouldn't we deny it or make it fallback to
>>>>> the supported tx/rx chainmask values?
>>>>
>>>> It would cause the logic to flip back to the defaults, so seems mildly
>>>> useful.  I'm not sure
>>>> upper layers would ever let it be < 1 though.
>>>
>>> 0 is a valid argument as far as upper layers are concerned and should
>>> be treated as "use all available antennas" (see `iw list` output
>>> before ever setting antenna, after setting to, e.g. 1 and then to 0).
>>>
>>> This implies current set_antenna() implementation is actually buggy
>>> (pdev param should involve using supp_tx/rx_chainmask). Your
>>> assumption in recent patches is also incorrect as antenna mask = 0
>>> should imply max nss, not 1.
>>
>> I tested this using:
>>
>> iw phy wiphy1 set antenna 0 0
>>
>> This flips it back to 3x3 (I had previously configured it for 2x2),
>> so I think the patches are working properly.
>
> Mea culpa. It will flip back indeed.
>
> But I still don't see why use_cfg_chains is necessary. I don't see how
> cfg_tx_chainmask could be non-zero when ath10k is registering to mac.

I was thinking we might want to re-register someday, like after loading
a new firmware, or tuning firmware differently so that the vdev limits
changed.

If you are sure we currently only register once per module load, then
I agree that use_cfg_chains should not be needed currently.

But, considering my desire to allow to re-register in the future, I'd
prefer the patch to remain as is unless you disagree.

Thanks,
Ben

>
>
> Michał
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
