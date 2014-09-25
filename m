Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:41638 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbaIYNWV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2014 09:22:21 -0400
Message-ID: <5424170B.2010409@candelatech.com> (sfid-20140925_152224_809654_A93B0F7C)
Date: Thu, 25 Sep 2014 06:22:19 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: use configured nss instead of max nss.
References: <1411426820-4047-1-git-send-email-greearb@candelatech.com>	<CA+BoTQn9sECMNZsxQpB4i3wHPxfVL+LXq9=2GBd-opH6+9TD=A@mail.gmail.com>	<5421A44C.8080307@candelatech.com>	<CA+BoTQ=mry3tPD-LK+gFD2bC6RU0KvY6LC9=FOAGTLi_1rzUog@mail.gmail.com>	<5422ECAA.6050600@candelatech.com> <CA+BoTQnLbJ7cnyUo-o6Ebx9pAxGyAHv8W8eKE8BEd7Kh8f+uTw@mail.gmail.com>
In-Reply-To: <CA+BoTQnLbJ7cnyUo-o6Ebx9pAxGyAHv8W8eKE8BEd7Kh8f+uTw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 09/24/2014 11:16 PM, Michal Kazior wrote:
> On 24 September 2014 18:09, Ben Greear <greearb@candelatech.com> wrote:
>> On 09/24/2014 12:09 AM, Michal Kazior wrote:
>>> On 23 September 2014 18:48, Ben Greear <greearb@candelatech.com> wrote:
>>>> On 09/23/2014 01:59 AM, Michal Kazior wrote:
>>>>> On 23 September 2014 01:00,  <greearb@candelatech.com> wrote:
>>>>>> From: Ben Greear <greearb@candelatech.com>
>>> [...]
>>>>>> @@ -4086,6 +4086,10 @@ ath10k_default_bitrate_mask(struct ath10k *ar,
>>>>>>          u32 legacy = 0x00ff;
>>>>>>          u8 ht = 0xff, i;
>>>>>>          u16 vht = 0x3ff;
>>>>>> +       u16 nrf = ar->num_rf_chains;
>>>>>> +
>>>>>> +       if (ar->cfg_tx_chainmask)
>>>>>> +               nrf = get_nss_from_chainmask(ar->cfg_tx_chainmask);
>>> [...]
>>>>> I think it might be a good idea to convey the limitation of tx/rx
>>>>> chainmask to the user: you can't change the tx/rx chainmask on the fly
>>>>> easily (while connected/have associated stations). Or do you plan to
>>>>> schedule peer reassoc in __ath10k_set_antenna() in a follow up
>>>>> patch(es) later?
> [...]
>> See this in net/mac80211/cfg.c:
>>
>> static int ieee80211_set_antenna(struct wiphy *wiphy, u32 tx_ant, u32 rx_ant)
>> {
>>          struct ieee80211_local *local = wiphy_priv(wiphy);
>>
>>          if (local->started)
>>                  return -EOPNOTSUPP;
>
> Ah, thanks! So my argument is invalid :)
>
>
>>> But it's still probably a good idea to comment the quoted code chunk
>>> above explaining why nrf is overriden by chainmask (i.e. due to
>>> firmware rate control issues, right?).
>>
>> I am not certain it is a bug in the firmware.  The driver should not configure
>> nss incorrectly as it was doing previous to my recent patches.
>
> Since firmware does rate control it just seems redundant for the
> driver to update both chainmask and nss (the first implies the other).
> But maybe that's just me.

nss is really a per-station issue, where the chainmask is a per-radio issue.

Think of an AP with 2x2 and 3x3 stations connected, for instance.

Thanks,
Ben

>
>
> Michał
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
