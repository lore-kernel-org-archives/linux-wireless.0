Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56592 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab0G0GzN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 02:55:13 -0400
Received: by pwi5 with SMTP id 5so333712pwi.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jul 2010 23:55:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1280213303.19098.3.camel@jlt3.sipsolutions.net>
References: <4C4DE6B5.5080307@candelatech.com> <4C4E0580.3060404@candelatech.com>
	<AANLkTi=qJXCxtMZcEm3VQT1s7ioJsdhj2kJzkgGSf3ND@mail.gmail.com>
	<4C4E1784.3030702@candelatech.com> <AANLkTimnZ9pSfVLsEPgiDPyc=_eUnyLj89RHCC6rsaX8@mail.gmail.com>
	<4C4E1C0B.9040608@candelatech.com> <1280213303.19098.3.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 26 Jul 2010 23:54:53 -0700
Message-ID: <AANLkTinh7JvGmx0s-A1ZKgGY+2WDPnptqt53=73PRzHD@mail.gmail.com>
Subject: Re: ath9k: /proc/net/wireless always shows status of 0
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ben Greear <greearb@candelatech.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 26, 2010 at 11:48 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2010-07-26 at 16:36 -0700, Ben Greear wrote:
>
>> > You can use nl28011 and register for netlink multicast messages which
>> > broadcast device state changes like the ones you mentioned. These come
>> > in on iw via event.c, see print_event() and see the case statements
>> > for NL80211_CMD_ASSOCIATE, NL80211_CMD_DEAUTHENTICATE,
>> > NL80211_CMD_DISASSOCIATE, etc, you even get reason codes parsed for
>> > you too.
>>
>> Ahhh, that is the kind of thing I'm looking for.  I'll check out that
>> code in detail tomorrow.
>
> Keep in mind though that not all drivers can give you the difference
> between AUTH and ASSOC, and will ONLY report "CONNECTED" events. This is
> those drivers that do roaming and all that in firmware rather than in
> mac80211. Therefore, generally speaking, you cannot get the states
> you're after.

FWIW I think he's on ath9k.

  Luis
