Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59092 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab0IPSkm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 14:40:42 -0400
Received: by iwn5 with SMTP id 5so1231890iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Sep 2010 11:40:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1284661809.3731.8.camel@jlt3.sipsolutions.net>
References: <20100916125821.369545798@sipsolutions.net> <20100916125927.163519598@sipsolutions.net>
 <AANLkTi=6KKLty-pg1O9EbGB3n9AviddL63X14z4a250Y@mail.gmail.com> <1284661809.3731.8.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 16 Sep 2010 11:40:22 -0700
Message-ID: <AANLkTikxcSXgEA-zM250AZ2v4sJk_U-gf2sjSoJ2x4ZR@mail.gmail.com>
Subject: Re: [PATCH 2/2] mac80211: add p2p device type support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 16, 2010 at 11:30 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2010-09-16 at 11:22 -0700, Luis R. Rodriguez wrote:
>> On Thu, Sep 16, 2010 at 5:58 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > From: Johannes Berg <johannes.berg@intel.com>
>> >
>> > When a driver advertises p2p device support,
>> > mac80211 will handle it, but internally it will
>> > rewrite the interface type to STA/AP rather than
>> > P2P-STA/GO since otherwise a lot of paths need
>> > to be touched that are otherwise identical. A
>> > p2p boolean tells drivers whether or not a given
>> > interface will be used for p2p or not.
>> >
>> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>>
>> While at it can you add a is_beaconing_iftype() or something, that
>> should reduce code and make it easier to check for these modes.
>
> Err, it doesn't really change for drivers, since it's still AP/IBSS --
> since GO is just an AP subtype internally.

Well if the iftype is a beaconing one it used to use AP interface type
before and now its a GO then yeah I could see this requiring changes
in drivers. Apart from the filter stuff ath9k does have some checks
for current operating interface type IIRC.

> And anyway, I wouldn't use it
> internally, so does it really belong into this patch?

If there is not much usage for it in mac80211 / cfg80211 sure, I just
thought there would be a lot of uses for it in mac80211 / cfg80211 but
I guess there isn't.

  Luis
