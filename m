Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37022 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422920AbcBZSy6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2016 13:54:58 -0500
Received: by mail-wm0-f51.google.com with SMTP id g62so82188171wme.0
        for <linux-wireless@vger.kernel.org>; Fri, 26 Feb 2016 10:54:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56D081F1.3030801@openwrt.org>
References: <1456492163-11437-1-git-send-email-michal.kazior@tieto.com>
	<56D081F1.3030801@openwrt.org>
Date: Fri, 26 Feb 2016 19:54:57 +0100
Message-ID: <CA+BoTQnYiSdzn99_xZPs9X2JO3SijXj10C2ezVr_8OEZvNCStg@mail.gmail.com> (sfid-20160226_195510_249790_641C853D)
Subject: Re: [RFC/RFT] mac80211: implement fq_codel for software queuing
From: Michal Kazior <michal.kazior@tieto.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Network Development <netdev@vger.kernel.org>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Dave Taht <dave.taht@gmail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tim Shepard <shep@alum.mit.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 February 2016 at 17:48, Felix Fietkau <nbd@openwrt.org> wrote:
[...]
>> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
>> index af584f7cdd63..f42f898cb8b5 100644
>> --- a/net/mac80211/tx.c
>> +++ b/net/mac80211/tx.c
>> + [...]
>> +static void ieee80211_txq_enqueue(struct ieee80211_local *local,
>> +                               struct txq_info *txqi,
>> +                               struct sk_buff *skb)
>> +{
>> +     struct ieee80211_fq *fq = &local->fq;
>> +     struct ieee80211_hw *hw = &local->hw;
>> +     struct txq_flow *flow;
>> +     struct txq_flow *i;
>> +     size_t idx = fq_hash(fq, skb);
>> +
>> +     flow = &fq->flows[idx];
>> +
>> +     if (flow->txqi)
>> +             flow = &txqi->flow;
> I'm not sure I understand this part correctly, but shouldn't that be:
>         if (flow->txqi && flow->txqi != txqi)

You're correct. Good catch, thanks!


Michał
