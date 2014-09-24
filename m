Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:59780 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbaIXQa7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 12:30:59 -0400
Message-ID: <5422F1C2.4090100@candelatech.com> (sfid-20140924_183103_150981_2C202B5A)
Date: Wed, 24 Sep 2014 09:30:58 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC 2/2] ath10k: re-config ht_caps when chainmask is modified.
References: <1411518383-32634-1-git-send-email-greearb@candelatech.com> <1411518383-32634-2-git-send-email-greearb@candelatech.com> <CA+BoTQ=fS30xz9KcdBJcioNers6PovOFEeqPCCSFn52HkscXug@mail.gmail.com> <5422D6CF.10408@candelatech.com> <CA+BoTQk=X2qVJsY64ZH88h29L6+Y5M9K07nLtzo=0ga1bUsXGw@mail.gmail.com>
In-Reply-To: <CA+BoTQk=X2qVJsY64ZH88h29L6+Y5M9K07nLtzo=0ga1bUsXGw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/24/2014 08:05 AM, Michal Kazior wrote:
> On 24 September 2014 16:35, Ben Greear <greearb@candelatech.com> wrote:
>> On 09/24/2014 12:51 AM, Michal Kazior wrote:
>>> On 24 September 2014 02:26,  <greearb@candelatech.com> wrote:
>>> [...]
>>>>
>>>> +static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k
>>>> *ar,
>>>> +                                                         bool
>>>> use_cfg_chains)
>>>>   {
>>>>          struct ieee80211_sta_vht_cap vht_cap = {0};
>>>>          u16 mcs_map;
>>>>          int i;
>>>> +       int nrf = ar->num_rf_chains;
>>>> +
>>>> +       if (use_cfg_chains && ar->cfg_tx_chainmask)
>>>> +               nrf = get_nss_from_chainmask(ar->cfg_tx_chainmask);
>>>
>>>
>>> Is use_cfg_chains really necessary here? Is setting tx/rx chainmask to
>>> 0x0 make any sense at all? Shouldn't we deny it or make it fallback to
>>> the supported tx/rx chainmask values?
>>
>> It would cause the logic to flip back to the defaults, so seems mildly
>> useful.  I'm not sure
>> upper layers would ever let it be < 1 though.
> 
> 0 is a valid argument as far as upper layers are concerned and should
> be treated as "use all available antennas" (see `iw list` output
> before ever setting antenna, after setting to, e.g. 1 and then to 0).
> 
> This implies current set_antenna() implementation is actually buggy
> (pdev param should involve using supp_tx/rx_chainmask). Your
> assumption in recent patches is also incorrect as antenna mask = 0
> should imply max nss, not 1.

I tested this using:

iw phy wiphy1 set antenna 0 0

This flips it back to 3x3 (I had previously configured it for 2x2),
so I think the patches are working properly.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

