Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54852 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab1I2Kuz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 06:50:55 -0400
Received: by yxl31 with SMTP id 31so468159yxl.19
        for <linux-wireless@vger.kernel.org>; Thu, 29 Sep 2011 03:50:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1317291672.3974.3.camel@jlt3.sipsolutions.net>
References: <1317288432-26380-1-git-send-email-helmut.schaa@googlemail.com>
	<1317290375.3974.1.camel@jlt3.sipsolutions.net>
	<CAGXE3d87utQhKifrA8bco14rv9zn3-uZEsDiisg8wkDfipeBMQ@mail.gmail.com>
	<1317291672.3974.3.camel@jlt3.sipsolutions.net>
Date: Thu, 29 Sep 2011 12:50:55 +0200
Message-ID: <CAGXE3d-OHGCm4VKUEvzcdjba_0TM+B4ozV+WdvA44SBzXqHpBg@mail.gmail.com> (sfid-20110929_125059_140949_71FCD4B8)
Subject: Re: [PATCH] mac80211: Allow NO_ACK flag overwrite for injected frames
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 29, 2011 at 12:21 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>> >> @@ -1257,7 +1265,7 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
>> >>               tx->flags |= IEEE80211_TX_UNICAST;
>> >>               if (unlikely(local->wifi_wme_noack_test))
>> >>                       info->flags |= IEEE80211_TX_CTL_NO_ACK;
>> >> -             else
>> >> +             else if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
>> >>                       info->flags &= ~IEEE80211_TX_CTL_NO_ACK;
>> >
>> > ??
>>
>> Don't remove the IEEE80211_TX_CTL_NO_ACK flag when it was set via radiotap.
>
> Well, ok, but the logic is:
>
> if (flag not set)
>        unset flag
>
> which is kinda useless, right?

Haha, right!

Since the tx info is always initialized to 0 the code was useless before
as well :) but now it is even more useless ...

I guess it was good for documentary purposes. Hence, I'll replace it with
a comment instead ...

Helmut
