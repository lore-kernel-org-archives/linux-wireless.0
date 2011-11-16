Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34984 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab1KPOqT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 09:46:19 -0500
Received: by vcbfk1 with SMTP id fk1so424002vcb.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2011 06:46:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1321454572.4502.3.camel@jlt3.sipsolutions.net>
References: <20111116142854.518391560@sipsolutions.net>
	<20111116142911.501655161@sipsolutions.net>
	<CAOZOX0VkGezQcijrEMiQSiuY=yadgSva7w9-SfrvYYW_UG+0LQ@mail.gmail.com>
	<1321454572.4502.3.camel@jlt3.sipsolutions.net>
Date: Wed, 16 Nov 2011 15:46:18 +0100
Message-ID: <CAOZOX0V4jVbVKQ1Qcc+wqi8URgzPSN6xXOSmRt9mHOQv=f75qA@mail.gmail.com> (sfid-20111116_154622_768954_37797A7F)
Subject: Re: [PATCH 4/4] mac80211: transmit fragment list to drivers
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 16, 2011 at 3:42 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2011-11-16 at 15:40 +0100, Ivo Van Doorn wrote:
>
>> > +static inline void drv_tx_frags(struct ieee80211_local *local,
>> > +                               struct ieee80211_sub_if_data *sdata,
>> > +                               struct sta_info *sta,
>> > +                               struct sk_buff_head *skbs,
>> > +                               void *internal)
>> > +{
>> > +       local->ops->tx_frags(&local->hw,
>> > +                            sdata ? &sdata->vif : NULL,
>> > +                            sta ? &sta->sta : NULL,
>> > +                            skbs, internal);
>> > +}
>>
>> Instead of changing every driver and making .tx_frags callback mandatory,
>> isn't it easier to have a if-else here?
>
> We certainly can't have the if-else here, if there should be one it
> should be in __ieee80211_tx().

Yeah, I was too lazy to search for the call to drv_tx_frags() itself. :)

>> Then it is much easier for the drivers as you can document that either
>> .tx or .tx_frags is mandatory but never both.
>
> Maybe that's the better option. Somehow I thought it would be more
> efficient this way, but I guess it doesn't actually make much of a
> difference and I can get rid of the void *internal parameter.
>
> I'll change.

Thanks,

Ivo
