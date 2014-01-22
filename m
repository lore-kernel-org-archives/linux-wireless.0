Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f44.google.com ([209.85.216.44]:57987 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbaAVSqy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 13:46:54 -0500
Received: by mail-qa0-f44.google.com with SMTP id w5so943202qac.3
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jan 2014 10:46:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390415331.4334.37.camel@jlt4.sipsolutions.net>
References: <1390382185.4334.19.camel@jlt4.sipsolutions.net>
 <CAHmEv86saxzZzy-qS6C_6k48EXFh2GVb8gVEcwJcBKQtj1Cv7Q@mail.gmail.com> <1390415331.4334.37.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <twpedersen@gmail.com>
Date: Wed, 22 Jan 2014 10:46:32 -0800
Message-ID: <CAHmEv85Q2neJJchxx3783_kcfNcSfrkQ3D9LVvWrK_uwYo3Fyg@mail.gmail.com> (sfid-20140122_194657_722900_1E425876)
Subject: Re: [PATCH] nl80211: check channel switch validity better
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 22, 2014 at 10:28 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2014-01-22 at 10:02 -0800, Thomas Pedersen wrote:
>
>> > --- a/net/wireless/nl80211.c
>> > +++ b/net/wireless/nl80211.c
>> > @@ -5799,10 +5799,15 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
>
>> >         case NL80211_IFTYPE_MESH_POINT:
>> > +               if (!wdev->mesh_id_len)
>> > +                       return -ENOTCONN;
>>
>> Hmmm. I'm pretty sure there are some users which set the channel prior
>> to mesh join. This would break that and only allow sending the channel
>> with mesh join?
>
> I don't think channel_switch() is invoked for that? That's done only for
> run-time switching of the channel with CSA etc.

Oh right, that was a special case then.

Thanks,
Thomas
