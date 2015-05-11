Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37426 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbbEKMnk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2015 08:43:40 -0400
Received: by widdi4 with SMTP id di4so94820778wid.0
        for <linux-wireless@vger.kernel.org>; Mon, 11 May 2015 05:43:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1431346122.1964.26.camel@sipsolutions.net>
References: <1431336675-15944-1-git-send-email-janusz.dziedzic@tieto.com>
	<1431346122.1964.26.camel@sipsolutions.net>
Date: Mon, 11 May 2015 14:43:38 +0200
Message-ID: <CA+BoTQ=3VBsBWVy+e-hOJZD7ZUmoemsU0g8XoFLm7SE_iypQBw@mail.gmail.com> (sfid-20150511_144344_399341_E743BBE9)
Subject: Re: [PATCH] mac80211: WEP, move tailroom size check
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 May 2015 at 14:08, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2015-05-11 at 11:31 +0200, Janusz Dziedzic wrote:
>> Remove checking tailroom when adding IV, while
>> this goes to headroom. Move this check to the function
>> that will generate/put ICV for WEP.
>>
>> In other case I hit such warning and datapath don't work,
>> when testing:
>> - IBSS + WEP
>> - ath9k with hw crypt enabled
>> - IPv6 data (ping6)
>
> Is this new, perhaps due to fast-xmit, because we previously added
> tailroom for WEP always? I've certainly never seen this before.
>
> (just asking so I know where it needs to be applied)

I think this was hidden for quite some time now, possibly since
_PUT_IV_SPACE and _GENERATE_IV were split into _GENERATE_MMIC and
_RESERVE_TAILROOM counterparts. I know that `ping` didn't trigger this
problem, instead `ping6` did which leads me to think that maybe
sk_buff allocation was getting lucky most of the time.


Michał
