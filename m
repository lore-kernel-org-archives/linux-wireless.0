Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43506 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab0IPS40 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 14:56:26 -0400
Received: by iwn5 with SMTP id 5so1240316iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Sep 2010 11:56:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1284662538.3731.12.camel@jlt3.sipsolutions.net>
References: <20100916125821.369545798@sipsolutions.net> <20100916125927.163519598@sipsolutions.net>
 <AANLkTi=6KKLty-pg1O9EbGB3n9AviddL63X14z4a250Y@mail.gmail.com>
 <1284661809.3731.8.camel@jlt3.sipsolutions.net> <AANLkTikxcSXgEA-zM250AZ2v4sJk_U-gf2sjSoJ2x4ZR@mail.gmail.com>
 <1284662538.3731.12.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 16 Sep 2010 11:56:05 -0700
Message-ID: <AANLkTikYJ3Fn-5qPngcNySns7HAur+nDY2krjsHv77Rx@mail.gmail.com>
Subject: Re: [PATCH 2/2] mac80211: add p2p device type support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 16, 2010 at 11:42 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2010-09-16 at 11:40 -0700, Luis R. Rodriguez wrote:
>
>> >> While at it can you add a is_beaconing_iftype() or something, that
>> >> should reduce code and make it easier to check for these modes.
>> >
>> > Err, it doesn't really change for drivers, since it's still AP/IBSS --
>> > since GO is just an AP subtype internally.
>>
>> Well if the iftype is a beaconing one it used to use AP interface type
>> before and now its a GO then yeah I could see this requiring changes
>> in drivers. Apart from the filter stuff ath9k does have some checks
>> for current operating interface type IIRC.
>
> But nothing changes for it -- look at the patch again, I translate
> P2P_GO to AP and P2P_CLIENT to STATION precisely to require fewer
> changes in drivers unless they actually want to care. The only ath9k
> change that is required is the one I posted (and you'll be back to the
> same non-functioning state, but that's another matter).

Ah OK fair enough, didn't pick up on that on first glance, nice.

  Luis
