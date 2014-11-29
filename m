Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:64548 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaK2ONo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Nov 2014 09:13:44 -0500
Received: by mail-wi0-f170.google.com with SMTP id bs8so22984871wib.3
        for <linux-wireless@vger.kernel.org>; Sat, 29 Nov 2014 06:13:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1417187462.27562.17.camel@sipsolutions.net>
References: <1417095547-12197-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<1417099707.19919.0.camel@sipsolutions.net>
	<CAA2SeNJuMYXRAU3NFABsKk27_ojZARBByRx4oU3xApaDnBJYug@mail.gmail.com>
	<1417181014.27562.4.camel@sipsolutions.net>
	<CAA2SeNJy4UmLujROiKwj0aScRfQkPpNLNTeb_8e68FDgxKKwqg@mail.gmail.com>
	<1417187462.27562.17.camel@sipsolutions.net>
Date: Sat, 29 Nov 2014 15:13:43 +0100
Message-ID: <CAA2SeNJVD4t2Mz44FkzO=fds6Ax8NqXpzZYkxGiidhPXsW-DBA@mail.gmail.com> (sfid-20141129_151406_709367_0A391760)
Subject: Re: [PATCH] mac80211: enable TPC through mac80211 stack
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	=?UTF-8?B?VGhvbWFzIEjDvGhu?= <thomas@net.t-labs.tu-berlin.de>,
	adrian@freebsd.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Fri, 2014-11-28 at 16:02 +0100, Lorenzo Bianconi wrote:
>
>> I just need to notify lower driver (ath9k in my case) to setup TPC
>> registers in order to take into account TX power configured in frame
>> descriptors. For that purpose I added tpc_enabled flags in
>> ieee80211_bss_conf and in ieee80211_conf. Is there any other variables
>> I can use to notify that configuration?
>
> Well, arguably, you can just do that unconditionally. If you want to do
> it "right" according to the nl80211 API that we introduced due to wext
> compatibility (IIRC), you'd have to look at the value passed in enum
> nl80211_tx_power_setting. This can take
>
> NL80211_TX_POWER_AUTOMATIC - no limit from userspace
> NL80211_TX_POWER_LIMITED - limit, but allow using less than specified
> NL80211_TX_POWER_FIXED - use exactly what userspace wanted
>
> I don't think any driver really implements this today, but you could
> take this as a hint and only enable TPC (with or without the user's
> specified limit) in the first two cases.

Sounds good to me. I will send a patch v2 where I will enable TPC if
tx_power_setting has been set to NL80211_TX_POWER_AUTOMATIC or
NL80211_TX_POWER_LIMITED. Right now ath9k computes maximum TX power
value per-rate as minimum between user TX power and channel/regulatory
constraints.

Best regards,
Lorenzo

>
> johannes
>



-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
