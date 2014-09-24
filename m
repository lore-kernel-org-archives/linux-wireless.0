Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:35855 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaIXPFv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 11:05:51 -0400
Received: by mail-wi0-f180.google.com with SMTP id q5so7490988wiv.7
        for <linux-wireless@vger.kernel.org>; Wed, 24 Sep 2014 08:05:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5422D6CF.10408@candelatech.com>
References: <1411518383-32634-1-git-send-email-greearb@candelatech.com>
	<1411518383-32634-2-git-send-email-greearb@candelatech.com>
	<CA+BoTQ=fS30xz9KcdBJcioNers6PovOFEeqPCCSFn52HkscXug@mail.gmail.com>
	<5422D6CF.10408@candelatech.com>
Date: Wed, 24 Sep 2014 17:05:50 +0200
Message-ID: <CA+BoTQk=X2qVJsY64ZH88h29L6+Y5M9K07nLtzo=0ga1bUsXGw@mail.gmail.com> (sfid-20140924_170556_912012_29F01328)
Subject: Re: [RFC 2/2] ath10k: re-config ht_caps when chainmask is modified.
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 September 2014 16:35, Ben Greear <greearb@candelatech.com> wrote:
> On 09/24/2014 12:51 AM, Michal Kazior wrote:
>> On 24 September 2014 02:26,  <greearb@candelatech.com> wrote:
>> [...]
>>>
>>> +static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k
>>> *ar,
>>> +                                                         bool
>>> use_cfg_chains)
>>>   {
>>>          struct ieee80211_sta_vht_cap vht_cap = {0};
>>>          u16 mcs_map;
>>>          int i;
>>> +       int nrf = ar->num_rf_chains;
>>> +
>>> +       if (use_cfg_chains && ar->cfg_tx_chainmask)
>>> +               nrf = get_nss_from_chainmask(ar->cfg_tx_chainmask);
>>
>>
>> Is use_cfg_chains really necessary here? Is setting tx/rx chainmask to
>> 0x0 make any sense at all? Shouldn't we deny it or make it fallback to
>> the supported tx/rx chainmask values?
>
> It would cause the logic to flip back to the defaults, so seems mildly
> useful.  I'm not sure
> upper layers would ever let it be < 1 though.

0 is a valid argument as far as upper layers are concerned and should
be treated as "use all available antennas" (see `iw list` output
before ever setting antenna, after setting to, e.g. 1 and then to 0).

This implies current set_antenna() implementation is actually buggy
(pdev param should involve using supp_tx/rx_chainmask). Your
assumption in recent patches is also incorrect as antenna mask = 0
should imply max nss, not 1.


Michał
