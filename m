Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:65095 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560AbbAHLHM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2015 06:07:12 -0500
Received: by mail-wi0-f174.google.com with SMTP id h11so2475828wiw.1
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jan 2015 03:07:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1420703288.2029.4.camel@sipsolutions.net>
References: <1420566070-25336-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<1420639929.3407.18.camel@sipsolutions.net>
	<CAA2SeN+KZqXcBpOuW=J_vyznOn03NceuH8RDdmcB30-7-9xyQw@mail.gmail.com>
	<1420703288.2029.4.camel@sipsolutions.net>
Date: Thu, 8 Jan 2015 12:07:05 +0100
Message-ID: <CAA2SeNL76Pd3ft4biBsHD9oTA4JOpD7oa5E+5ajk37irSDPhtw@mail.gmail.com> (sfid-20150108_120716_938800_6C56A43B)
Subject: Re: [PATCHv4] mac80211: enable TPC through mac80211 stack
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	=?UTF-8?B?VGhvbWFzIEjDvGhu?= <thomas@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Wed, 2015-01-07 at 15:39 +0100, Lorenzo Bianconi wrote:
>
>> > Does it really make sense to ask the driver to do "automatic"? After
>> > all, there are other limits in mac80211 (like 11h from the AP and
>> > regulatory) that need to be considered. So perhaps if userspace says
>> > "automatic", the driver should still see only "limited"?
>> >
>>
>> IMHO "automatic" means lower driver has to take into account just
>> channel/regulatory constraints (that is ath9k behavior), since the
>> user/mac80211 does not cap TX power, whereas "limited" means the
>> user/mac80211 has set a limit for emitted power, so that configuration
>> has to be taken into account.
>
> Well, mac80211 always gives you a max TX power value though - and if
> it's only the maximum regulatory permitted on that channel. So there's
> always a valid upper bound - unlike the userspace API where "automatic"
> means that you have no idea of an upper bound. Inside the kernel you
> always have an upper bound, so "automatic" doesn't make that much sense?
>

Sounds good, now I have clearer vision :)
I will overwrite bss_conf nl80211_tx_power_setting value in
ieee80211_set_tx_power() when txpower type is set to
NL80211_TX_POWER_AUTOMATIC from userspace. Moreover should we set
nl80211_tx_power_setting to NL80211_TX_POWER_LIMITED in
ieee80211_handle_pwr_constr() when the station receives a power
constraint in beacon frames? What do you think?

> johannes
>

Regards,
Lorenzo

-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
