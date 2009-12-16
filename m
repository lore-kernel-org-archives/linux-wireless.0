Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:64089 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761578AbZLPGJ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2009 01:09:26 -0500
Received: by iwn1 with SMTP id 1so484023iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 15 Dec 2009 22:09:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1260937465.12734.6.camel@darkslate>
References: <1260811290.2612.21.camel@darkslate> <1260811456.2442.422.camel@johannes.local>
	<1260937465.12734.6.camel@darkslate>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 15 Dec 2009 22:09:03 -0800
Message-ID: <43e72e890912152209l319da6b8w2fcaa655777c0366@mail.gmail.com>
Subject: Re: mac80211 or ath9k? No connect to other band after resume
To: ASIC Felix <ic.felix@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 15, 2009 at 8:24 PM, ASIC Felix <ic.felix@gmail.com> wrote:
> On Mon, 2009-12-14 at 18:24 +0100, Johannes Berg wrote:
>> On Mon, 2009-12-14 at 09:21 -0800, ASIC Felix wrote:
>> > Hi,
>> >
>> > I found a suspend/resume bug.
>> > Kernel 2.6.32-wl-45997-gf02c03a master-2009-12-07
>> >
>> > To reproduce:
>> > - connect to 2G network (my office)
>> > - pm-suspend
>> > - resume (at home, wpa_supplicant.conf only has 5G home network)
>> > - laptop only scans 2G, never sees 5G AP
>> > - workaround:
>> >     /etc/init.d/network stop
>> >     rmmod bla bla bla
>> >     modprobe ath9k
>> >     /etc/init.d/network start
>> > - now laptop reconnects
>>
>> I'd guess regulatory -- enable debugging for that please.
>>
>> johannes
>
>
> yep, does looke like regulatory after pm-suspend, mcgrof?

So right now cfg80211 doesn't support roaming between countries. This
means for example if channel you have a card that *does* allow passive
scan scan on channel 13, connect to an AP with country IE info that
disables channel 13 (US), suspend, go to JP, resume and find out your
AP there is on channel 13 you won't be able to connect to it yet. This
definitely can be addressed and I've noted its not supported in
cfg80211 code but I haven't yet gotten around to it.

Your logs do not give me the information to confirm this is indeed the
issue, but your statement above indicates that you connect to the 2.4
GHz network at work, and on 5 GHz at home. Note that even if your AP
at work did not have any 5 GHz channels on the country IE it outputs
you will still be able to connect on 5 GHz APs because the cfg80211
treats such country IEs as non-regulatory-complete if a complete band
is missing and your own regulatory's cards rules are kept.

But -- if your AP at work which is on the 2.4 GHz spits out a Country
IE with 2 GHz channels and at least one 5 GHz channel and you connect
to it, we will assume it knows what its talking about and only enable
only those 5 GHz channels it told us to use.

The logs you posted do not give enough info though to properly debug
this. Please enable on your kernel:

CONFIG_CFG80211_REG_DEBUG=y

recompile and post the logs of the CRDA stuff based on the country IE
when you connect at work. You can also use the patch I'm about to post
for iw to just scan on the freq you know your AP is on and paste that
info (except the BSSID if you care about that.

I also need the output of:

'iw list'

both before you connect at work, once you connect at work. I assume
the output will be the same when you resume and get home. Then tell me
the exact channel / frequency both APs you are using are on.

  Luis
