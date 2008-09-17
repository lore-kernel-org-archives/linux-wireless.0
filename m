Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:62824 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbYIQW51 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 18:57:27 -0400
Received: by fk-out-0910.google.com with SMTP id 18so3082924fkq.5
        for <linux-wireless@vger.kernel.org>; Wed, 17 Sep 2008 15:57:25 -0700 (PDT)
Message-ID: <1ba2fa240809171557i498cb5e1rcacb5961d8e1c3c6@mail.gmail.com> (sfid-20080918_005737_471067_1A033227)
Date: Thu, 18 Sep 2008 01:57:25 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH v2] mac80211: re-enable aggregation
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890809171545k5aeaa52dje2223bdbeb97ce7e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1221535073-6937-1-git-send-email-lrodriguez@atheros.com>
	 <1221547036.8916.1.camel@johannes.berg>
	 <1ba2fa240809171357p1b190760h19c3e521e100f7e4@mail.gmail.com>
	 <43e72e890809171545k5aeaa52dje2223bdbeb97ce7e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 18, 2008 at 1:45 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Wed, Sep 17, 2008 at 1:57 PM, Tomas Winkler <tomasw@gmail.com> wrote:
>> On Tue, Sep 16, 2008 at 9:37 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>>> On Mon, 2008-09-15 at 20:17 -0700, Luis R. Rodriguez wrote:
>>>
>>>> +/**
>>>> + * is_part_ampdu - tells us whether this buffer is part of an AMPDU
>>>> + *
>>>> + * @skb: the buffer we want to check
>>>> + * @hw: the &struct ieee80211_hw to check the queue mapping on
>>>> + */
>>>> +static inline bool is_part_ampdu(struct sk_buff *skb, struct ieee80211_hw *hw)
>>>> +{
>>>> +     return (skb_get_queue_mapping(skb) >=
>>>> +             ieee80211_num_regular_queues(hw));
>>>> +}
>>>> +
>>>
>>> This is making the patch needlessly large and makes it change drivers
>>> etc, please just keep the flag and set it based on this in master xmit
>>> after we've cleared the info.
>>>
>> Yes, please keep the flag. Otherwise our rate scale algorithm won't work
>
> OK -- you can ignore this I like the path you took better.

What I need to next is to add is rtnl_lock
qdisc_root_lock requires this. This root lock is held during requeuing
which can be triggered by removal or addition of an aggregation queue.
Tomas
