Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:58256 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaIXOnB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 10:43:01 -0400
Message-ID: <5422D874.1030007@candelatech.com> (sfid-20140924_164305_667908_9419F73D)
Date: Wed, 24 Sep 2014 07:43:00 -0700
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

I was thinking we should register with supported values, instead of
configured values.  That is the intention of the code.  In case we
ever re-register after user has configured the system, this should
retain that functionality.  If it is impossible to re-register the
wiphy, then this extra use_cfg_chains logic could go away.

On startup, before user ever configures anything (and most users never will),
the cfg-tx-chainmask is 0, so it would stay with chip's defaults.

Thanks,
Ben

>
>
> Michał
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
