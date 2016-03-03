Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:34887 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbcCCQXD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 11:23:03 -0500
Received: by mail-ob0-f180.google.com with SMTP id xx9so24526908obc.2
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2016 08:23:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1457018090.2044.20.camel@sipsolutions.net>
References: <1456669193-56860-1-git-send-email-nbd@openwrt.org>
	<CAA93jw5Vk1-1AcawzQxNT1Re9EsMPUK220A5WsxS6MhX3VJQBQ@mail.gmail.com>
	<1457018090.2044.20.camel@sipsolutions.net>
Date: Thu, 3 Mar 2016 08:23:01 -0800
Message-ID: <CAA93jw7hK9wQvwjdYRMueCHm+Uc0wvHfKsm9y-r37gWEFLgxoQ@mail.gmail.com> (sfid-20160303_172308_171791_236A93C6)
Subject: Re: [PATCH] mac80211: fix AP buffered multicast frames with queue
 control and txq
From: Dave Taht <dave.taht@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 3, 2016 at 7:14 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sun, 2016-02-28 at 09:35 -0800, Dave Taht wrote:
>> On Sun, Feb 28, 2016 at 6:19 AM, Felix Fietkau <nbd@openwrt.org>
>> wrote:
>> > Buffered multicast frames must be passed to the driver directly via
>> > drv_tx instead of going through the txq, otherwise they cannot
>> > easily be
>> > scheduled to be sent after DTIM.
>> >
>> > Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> > ---
>> >  net/mac80211/tx.c | 3 ++-
>> >  1 file changed, 2 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
>> > index 3a7475f..b294820 100644
>> > --- a/net/mac80211/tx.c
>> > +++ b/net/mac80211/tx.c
>> > @@ -1247,7 +1247,8 @@ static void ieee80211_drv_tx(struct
>> > ieee80211_local *local,
>> >         struct txq_info *txqi;
>> >         u8 ac;
>> >
>> > -       if (info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE)
>> > +       if ((info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) ||
>> > +           (info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE))
>> >                 goto tx_normal;
>> >
>> >         if (!ieee80211_is_data(hdr->frame_control))
>> > --
>> > 2.2.2
>>
>> I would like
>
> Feel free to propose patches for anything you like :)

At the moment all I can do is cheer people on, and try to assemble
enough gear to test comprehensively when enough patches have landed in
your tree... Go, felix! Go, Michal! Go Mohammed! Go, Ben! Go Tim! Go,
Emmanuel! Go Johannes!


>
> johannes
>>
