Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60054 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab0ETFRj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 May 2010 01:17:39 -0400
Received: by pwi5 with SMTP id 5so1907985pwi.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 May 2010 22:17:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201005201121.49846.br1@einfach.org>
References: <20100519012528.22206.77550.stgit@tt-desk> <201005201012.12045.br1@einfach.org>
	<AANLkTimso6hoef9IG2VtRQsHQiOVTQF-dwNZEooZTb3Y@mail.gmail.com>
	<201005201121.49846.br1@einfach.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 19 May 2010 22:17:19 -0700
Message-ID: <AANLkTilG3c2UDEQa66PMvKysRVTt_dd-ZAS8FiDOe4Ob@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH v2 13/20] cfg80211: Add nl80211 antenna
	configuration
To: Bruno Randolf <br1@einfach.org>
Cc: "ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> > that's not very clear. can you give me an example?
>>
>> iw dev wlan0 set_tx_antenna 4
>
> so you want to transmit on antenna 3. if the card has 3 antennas -
> why not?

None of the legacy 802.11 drivers we support have more than 2
antennas, I am also not aware of any.

>> > what if there is a 'legacy' hardware with 3 or more antennas?
>>
>> Like what?
>
> i can't find an actual real world example for that, but it thought it might be
> possible, from what i know from the atheros eeprom which seems to be prepared
> for up to 6 antennas.

That's for 802.11n, I think it'd be much cleaner to treat that
separately. But -- I can think of using an 802.11n device in legacy
mode of operation using specific antennas.... so there's your example
of a valid case for this.

>> > i don't see how "my" API is too complicated, and i think it allows for a
>> > clear configuration of these cases as well.
>> >
>> > your criticism seems to be based on the fact that it's not clear how to
>> > handle 802.11n chainmask + antenna configuration, but this is not what
>> > my patch is concerned about. let's go step by step...
>>
>> No no, that is my fault, I brought that up, I was hoping we could
>> address it but it seems that we can't as I don't have time to think
>> about this further in a unified clean API. But if its just going to be
>> legacy then I don't see why we would use a large bitmap.
>
> i wanted it to be easily extensibe for 802.11n

If we do want to address 802.11n then I say we go back to the drawing
board and really think about how antennas settings work for 802.11n
and consider chainmask settings.

> and possibly 'legacy' with more antennas in the future.

Legacy devices are dead. I don't know anyone in the industry making
them, the 1 stream 802.11n devices are cheaper today, so there is no
point in the market for it.

> if there really are not any pre-N cards with more than
> 2 antennas out there,

Yup, I think this is the case :)

> and we are sure we don't want to support more than 2
> antennas - well, we could save 6 bits... is it really worth it?

You're right, then if you really don't mind lets think 802.11n through
well then.

  Luis
