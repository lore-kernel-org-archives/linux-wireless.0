Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:49439 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbYIQU5t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 16:57:49 -0400
Received: by fg-out-1718.google.com with SMTP id 19so2122474fgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 17 Sep 2008 13:57:47 -0700 (PDT)
Message-ID: <1ba2fa240809171357p1b190760h19c3e521e100f7e4@mail.gmail.com> (sfid-20080917_225753_426599_893D453D)
Date: Wed, 17 Sep 2008 23:57:47 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] mac80211: re-enable aggregation
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1221547036.8916.1.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1221535073-6937-1-git-send-email-lrodriguez@atheros.com>
	 <1221547036.8916.1.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 16, 2008 at 9:37 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-09-15 at 20:17 -0700, Luis R. Rodriguez wrote:
>
>> +/**
>> + * is_part_ampdu - tells us whether this buffer is part of an AMPDU
>> + *
>> + * @skb: the buffer we want to check
>> + * @hw: the &struct ieee80211_hw to check the queue mapping on
>> + */
>> +static inline bool is_part_ampdu(struct sk_buff *skb, struct ieee80211_hw *hw)
>> +{
>> +     return (skb_get_queue_mapping(skb) >=
>> +             ieee80211_num_regular_queues(hw));
>> +}
>> +
>
> This is making the patch needlessly large and makes it change drivers
> etc, please just keep the flag and set it based on this in master xmit
> after we've cleared the info.
>
Yes, please keep the flag. Otherwise our rate scale algorithm won't work
Thanks
Tomas
