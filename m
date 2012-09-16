Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1448 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025Ab2IPQcc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2012 12:32:32 -0400
Message-ID: <5055FF08.7000204@broadcom.com> (sfid-20120916_183236_852341_60545E54)
Date: Sun, 16 Sep 2012 18:32:08 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "Eliad Peller" <eliad@wizery.com>, linux-wireless@vger.kernel.org,
	"Michal Kazior" <michal.kazior@tieto.com>
Subject: Re: [PATCH 01/10] mac80211: introduce channel context skeleton
 code
References: <1347626233-21916-1-git-send-email-johannes@sipsolutions.net>
 <1347626233-21916-2-git-send-email-johannes@sipsolutions.net>
 <CAB3XZEdAX8=BU5QQaQpS=OF-5XXDH=k3rO7C2z2F+sZpaCNK1Q@mail.gmail.com>
In-Reply-To: <CAB3XZEdAX8=BU5QQaQpS=OF-5XXDH=k3rO7C2z2F+sZpaCNK1Q@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/15/2012 11:42 PM, Eliad Peller wrote:
> On Fri, Sep 14, 2012 at 3:37 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> From: Michal Kazior <michal.kazior@tieto.com>
>>
>> Channel context are the foundation for multi-channel
>> operation. They are are immutable and are re-created
>> (or re-used if other interfaces are bound to a certain
>> channel and a compatible channel type) on channel
>> switching.
>>
>> This is an initial implementation and more features
>> will come in separate patches.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>> [some changes including RCU protection]
>> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>> ---
> [...]
>
>> +int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
>> +                             struct ieee80211_channel *channel,
>> +                             enum nl80211_channel_type channel_type,
>> +                             enum ieee80211_chanctx_mode mode)
>> +{
>> +       struct ieee80211_local *local = sdata->local;
>> +       struct ieee80211_chanctx *ctx;
>> +       int ret;
>> +
>> +       mutex_lock(&local->chanctx_mtx);
>> +       __ieee80211_vif_release_channel(sdata);
>> +
>> +       ctx = ieee80211_find_chanctx(local, channel, channel_type, mode);
> since you might use an existing ctx here...
>
>> +       if (!ctx)
>> +               ctx = ieee80211_new_chanctx(local, channel, channel_type, mode);
>> +       if (IS_ERR(ctx)) {
>> +               ret = PTR_ERR(ctx);
>> +               goto out;
>> +       }
>> +
>> +       ret = ieee80211_assign_vif_chanctx(sdata, ctx);
>> +       if (ret) {
>> +               ieee80211_free_chanctx(local, ctx);
> i think you should check ctx->refcount before freeing it.
>
> Eliad.

Would it make sense to have the refcount check in 
ieee80211_free_chanctx() instead of the WARN_ON_ONCE() in there.

Gr. AvS

