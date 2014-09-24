Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:58196 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbaIXOhV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 10:37:21 -0400
Message-ID: <5422D71F.7080809@candelatech.com> (sfid-20140924_163726_428778_E0517514)
Date: Wed, 24 Sep 2014 07:37:19 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH v2 03/10] ath10k: support ethtool stats.
References: <1411507045-18973-1-git-send-email-greearb@candelatech.com>	<1411507045-18973-3-git-send-email-greearb@candelatech.com> <CA+BoTQkK=6NfPN9e-3qN2Qaq2RLVdEwrp5x03_T=E2ZLcBeiaA@mail.gmail.com>
In-Reply-To: <CA+BoTQkK=6NfPN9e-3qN2Qaq2RLVdEwrp5x03_T=E2ZLcBeiaA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 09/24/2014 12:44 AM, Michal Kazior wrote:
> On 23 September 2014 23:17,  <greearb@candelatech.com> wrote:
> [...]
>> +void ath10k_get_et_stats(struct ieee80211_hw *hw,
>> +                        struct ieee80211_vif *vif,
>> +                        struct ethtool_stats *stats, u64 *data)
>> +{
>> +       struct ath10k *ar = hw->priv;
>> +       int i = 0;
>> +       struct ath10k_target_stats *fw_stats;
>> +
>> +       fw_stats = &ar->debug.target_stats;
>> +
>> +       mutex_lock(&ar->conf_mutex);
>> +
>> +       if (ar->state == ATH10K_STATE_ON)
>> +               ath10k_refresh_peer_stats(ar);
>> +
>> +       mutex_unlock(&ar->conf_mutex);
>
> Just for correctness sake - it's probably a good idea to
> mutex_unlock() at the end (i.e. after spin_unlock_bh()) to make sure
> the stats are for this particular request. With your patch there's a
> very slight chance that, e.g. fw_stats debug file is being read at the
> same time and it updates fw stats between the above mutex_unlock() and
> following spin_lock_bh().

That makes no difference at all to the user though, and it is one less
set of nested locks to worry about.

I'd prefer to leave it as is.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
