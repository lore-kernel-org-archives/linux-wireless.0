Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55730 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbaFXLzY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 07:55:24 -0400
Received: by mail-wi0-f178.google.com with SMTP id n15so436352wiw.17
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 04:55:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1403528633.4418.27.camel@jlt4.sipsolutions.net>
References: <1402577680-17888-1-git-send-email-michal.kazior@tieto.com>
	<1403009938-1084-1-git-send-email-michal.kazior@tieto.com>
	<1403009938-1084-2-git-send-email-michal.kazior@tieto.com>
	<1403528633.4418.27.camel@jlt4.sipsolutions.net>
Date: Tue, 24 Jun 2014 13:55:18 +0200
Message-ID: <CA+BoTQkNKQq2vQ1OY9jt9S4uvgWGuSn9NvwjTfZZOYMxB3_1QQ@mail.gmail.com> (sfid-20140624_135538_228685_F4A88338)
Subject: Re: [PATCH v10 1/5] mac80211: implement multi-vif in-place reservations
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 June 2014 15:03, Johannes Berg <johannes@sipsolutions.net> wrote:
> So, I was going to apply this, but then I ran sparse & smatch :-)
>
> On Tue, 2014-06-17 at 14:58 +0200, Michal Kazior wrote:
>
>> -     curr_ctx = container_of(conf, struct ieee80211_chanctx, conf);
>> +     curr_ctx = ieee80211_vif_get_chanctx(sdata);
>> +     if (curr_ctx && local->use_chanctx && !local->ops->switch_vif_chanctx)
>> +             return -ENOTSUPP;
>
> curr_ctx can be NULL?
>
>>       new_ctx = ieee80211_find_reservation_chanctx(local, chandef, mode);
>>       if (!new_ctx) {
>> +             if (ieee80211_can_create_new_chanctx(local)) {
>>                       new_ctx = ieee80211_new_chanctx(local, chandef, mode);
>> +                     if (IS_ERR(new_ctx))
>> +                             return PTR_ERR(new_ctx);
>>               } else {
>> +                     if ((curr_ctx->replace_state ==
>> +                          IEEE80211_CHANCTX_WILL_BE_REPLACED) ||
>
> then this crashes?

Right. Thanks to this I've just found another issue with unreserving
(if in-place reservation vifs are unreserved+unassigned then
(re)assign reservations need special treatment).


>> +     if (local->use_chanctx) {
>> +             vif_chsw = kzalloc(sizeof(*vif_chsw) * n_vifs, GFP_KERNEL);
>> +             if (vif_chsw) {
>
> clearly you didn't test this? :)

:(


>> +                     err = -ENOMEM;
>> +                     goto err;
>> +             }
>> +
>> +             i = 0;
>> +             list_for_each_entry(ctx, &local->chanctx_list, list) {
>> +                     if (ctx->replace_state != IEEE80211_CHANCTX_REPLACES_OTHER)
>> +                             continue;
>> +
>> +                     if (WARN_ON(!ctx->replace_ctx))
>> +                             return -EINVAL;
>
> This also leaks "vif_chsw".

This should be a `goto` too.

I'll re-spin once I fix all the problems that I'm aware of now.


Michał
