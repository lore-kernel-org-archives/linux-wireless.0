Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:58181 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbaIXOgB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 10:36:01 -0400
Message-ID: <5422D6CF.10408@candelatech.com> (sfid-20140924_163610_502578_66EE33FB)
Date: Wed, 24 Sep 2014 07:35:59 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC 2/2] ath10k: re-config ht_caps when chainmask is modified.
References: <1411518383-32634-1-git-send-email-greearb@candelatech.com>	<1411518383-32634-2-git-send-email-greearb@candelatech.com> <CA+BoTQ=fS30xz9KcdBJcioNers6PovOFEeqPCCSFn52HkscXug@mail.gmail.com>
In-Reply-To: <CA+BoTQ=fS30xz9KcdBJcioNers6PovOFEeqPCCSFn52HkscXug@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 09/24/2014 12:51 AM, Michal Kazior wrote:
> On 24 September 2014 02:26,  <greearb@candelatech.com> wrote:
> [...]
>> +static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k *ar,
>> +                                                         bool use_cfg_chains)
>>   {
>>          struct ieee80211_sta_vht_cap vht_cap = {0};
>>          u16 mcs_map;
>>          int i;
>> +       int nrf = ar->num_rf_chains;
>> +
>> +       if (use_cfg_chains && ar->cfg_tx_chainmask)
>> +               nrf = get_nss_from_chainmask(ar->cfg_tx_chainmask);
>
> Is use_cfg_chains really necessary here? Is setting tx/rx chainmask to
> 0x0 make any sense at all? Shouldn't we deny it or make it fallback to
> the supported tx/rx chainmask values?

It would cause the logic to flip back to the defaults, so seems mildly useful.  I'm not sure
upper layers would ever let it be < 1 though.

Thanks,
Ben

>
>
> Michał
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
