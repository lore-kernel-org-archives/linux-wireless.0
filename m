Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47090 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbaI2IVe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2014 04:21:34 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH v2 03/10] ath10k: support ethtool stats.
References: <1411507045-18973-1-git-send-email-greearb@candelatech.com>
	<1411507045-18973-3-git-send-email-greearb@candelatech.com>
	<CA+BoTQkK=6NfPN9e-3qN2Qaq2RLVdEwrp5x03_T=E2ZLcBeiaA@mail.gmail.com>
	<5422D71F.7080809@candelatech.com>
Date: Mon, 29 Sep 2014 11:21:10 +0300
In-Reply-To: <5422D71F.7080809@candelatech.com> (Ben Greear's message of "Wed,
	24 Sep 2014 07:37:19 -0700")
Message-ID: <87eguu3ki1.fsf@kamboji.qca.qualcomm.com> (sfid-20140929_102138_355023_008283BA)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> On 09/24/2014 12:44 AM, Michal Kazior wrote:
>> On 23 September 2014 23:17,  <greearb@candelatech.com> wrote:
>> [...]
>>> +void ath10k_get_et_stats(struct ieee80211_hw *hw,
>>> +                        struct ieee80211_vif *vif,
>>> +                        struct ethtool_stats *stats, u64 *data)
>>> +{
>>> +       struct ath10k *ar = hw->priv;
>>> +       int i = 0;
>>> +       struct ath10k_target_stats *fw_stats;
>>> +
>>> +       fw_stats = &ar->debug.target_stats;
>>> +
>>> +       mutex_lock(&ar->conf_mutex);
>>> +
>>> +       if (ar->state == ATH10K_STATE_ON)
>>> +               ath10k_refresh_peer_stats(ar);
>>> +
>>> +       mutex_unlock(&ar->conf_mutex);
>>
>> Just for correctness sake - it's probably a good idea to
>> mutex_unlock() at the end (i.e. after spin_unlock_bh()) to make sure
>> the stats are for this particular request. With your patch there's a
>> very slight chance that, e.g. fw_stats debug file is being read at the
>> same time and it updates fw stats between the above mutex_unlock() and
>> following spin_lock_bh().
>
> That makes no difference at all to the user though, and it is one less
> set of nested locks to worry about.

I still do not want to have known races, especially when it's so easy to
fix. The ethtool patches patches conflict with Michal's fw_stats fixes.
Let me take the ethtool patches so that I can rebase them, fix this race
and do some other small changes as well. I'll send v2 soon.

-- 
Kalle Valo
