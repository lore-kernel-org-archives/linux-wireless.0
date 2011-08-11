Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52111 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab1HKNZE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 09:25:04 -0400
Received: by yxj19 with SMTP id 19so1286525yxj.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 06:25:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1313067519.3992.4.camel@jlt3.sipsolutions.net>
References: <1313053697-19544-1-git-send-email-helmut.schaa@googlemail.com>
	<1313067519.3992.4.camel@jlt3.sipsolutions.net>
Date: Thu, 11 Aug 2011 15:25:02 +0200
Message-ID: <CAGXE3d8PWyUnkM+RA0=HHyc=Zw193w51R-KkAYGQz1qwCKT7YQ@mail.gmail.com> (sfid-20110811_152507_290059_97C9DE15)
Subject: Re: [PATCH] mac80211: Tear down BA session on BAR tx failure
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 11, 2011 at 2:58 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>> +             if (!acked && ieee80211_is_back_req(fc)) {
>> +                     /*
>> +                      * BAR failed, let's tear down the BA session as a
>> +                      * last resort as some STAs (Intel 5100 on Windows)
>> +                      * can get stuck when the BA window isn't flushed
>> +                      * correctly.
>> +                      */
>> +                     bar = (struct ieee80211_bar *) skb->data;
>> +                     ieee80211_stop_tx_ba_session(&sta->sta,
>> +                                                  bar->control >> 12 & 0xf);
>> +             }
>
> Hmm, that shift & mask makes me think twice, are there constants, and
> maybe there should be some parentheses?

This just masks out the TID associated to this BA agreement and the shift
has a higher precedence then the bitwise &.

We don't have a suitable constant yet, a hardcoded 12 is also used in
ieee80211_send_bar. Hence, I guess a define would be suitable here.

I'll resend with the fixed typos and replace the 12 with a define.

Thanks,
Helmut
