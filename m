Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.221.181]:52181 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbZG0TS7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 15:18:59 -0400
Received: by qyk11 with SMTP id 11so963957qyk.33
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2009 12:18:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1248721855.32365.2.camel@johannes.local>
References: <1248720784-15671-1-git-send-email-lrodriguez@atheros.com>
	<1248720784-15671-4-git-send-email-lrodriguez@atheros.com>
	<1248721855.32365.2.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 27 Jul 2009 12:18:39 -0700
Message-ID: <43e72e890907271218w74e9f13dj209c2e5213584180@mail.gmail.com>
Subject: Re: [PATCH 3/3] ath9k: move workqueue cancels to stop callback
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 27, 2009 at 12:10 PM, Johannes
Berg<johannes@sipsolutions.net> wrote:
> On Mon, 2009-07-27 at 11:53 -0700, Luis R. Rodriguez wrote:
>> We should be cancelling our work at the stop callback since
>> we are borrowing the mac80211 workqueue for our work. As it
>> stands mac80211 expects this for suspend purposes.
>>
>> The ath9k specific virtual wiphy stuff need only be
>> cancelled only when the we have no secondary virtual wiphys.
>
> inverted logic here?

Nope, ie the sc->num_sec_wiphy wil be decremented on device removal.
As long as there is some secondary wiphy it means we need our internal
scheduler working and work is being queued. So upon suspend we'll
iterate over all interfaces and remove them unless you have WoW
enabled (eventually), the last interface drv_stop() then would ensure
to clear the virtual scheduler work.

  Luis
