Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.233]:38943 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbZEMVbJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 17:31:09 -0400
Received: by rv-out-0506.google.com with SMTP id f9so550587rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 13 May 2009 14:31:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b6c5339f0905131409y18ea0c6fp438db6fe34d3c0c4@mail.gmail.com>
References: <1242206461-30793-1-git-send-email-lrodriguez@atheros.com>
	<1242206461-30793-3-git-send-email-lrodriguez@atheros.com>
	<1242208388.14227.46.camel@johannes.local> <43e72e890905131020y66111b1nb89a3f17596efca6@mail.gmail.com>
	<b6c5339f0905131100v5ea764cejf005734ce9289290@mail.gmail.com>
	<20090513181329.GA19693@tesla> <b6c5339f0905131409y18ea0c6fp438db6fe34d3c0c4@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 13 May 2009 14:30:50 -0700
Message-ID: <43e72e890905131430p21873dbdr8f1b587fe796c1d8@mail.gmail.com>
Subject: Re: [RFC v2 2/5] mac80211: inform devices when we are suspending on
	the stop callback
To: Bob Copeland <bcopeland@gmail.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 13, 2009 at 2:09 PM, Bob Copeland <bcopeland@gmail.com> wro=
te:
> On Wed, May 13, 2009 at 2:13 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> Agreed, however ath9k is the only card I know how WoW works so far.
>
> Understood.
>
>> Thoughts?
>
> None really, it just seemed adding flags to stop() is a less-than-ide=
al
> interface. =C2=A0Hmm, maybe there is inspiration to be had from plain=
 old
> ethernet drivers...
>
> <looks quickly>
>
> The one example I looked at, amd8111e, used set_wol/get_wol callbacks
> from ethtool to set the option, then did something special in its bus
> suspend method for the magic. *shrug*

Heh I reviewed ethernet and it was a bit messy. So you're right we
should try to make it very consistent and easy to follow and document
it well. I tend to think listening to johill is good :)

 Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
