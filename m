Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:52830 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbaK1PCs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 10:02:48 -0500
Received: by mail-wg0-f45.google.com with SMTP id b13so9132139wgh.18
        for <linux-wireless@vger.kernel.org>; Fri, 28 Nov 2014 07:02:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1417181014.27562.4.camel@sipsolutions.net>
References: <1417095547-12197-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<1417099707.19919.0.camel@sipsolutions.net>
	<CAA2SeNJuMYXRAU3NFABsKk27_ojZARBByRx4oU3xApaDnBJYug@mail.gmail.com>
	<1417181014.27562.4.camel@sipsolutions.net>
Date: Fri, 28 Nov 2014 16:02:36 +0100
Message-ID: <CAA2SeNJy4UmLujROiKwj0aScRfQkPpNLNTeb_8e68FDgxKKwqg@mail.gmail.com> (sfid-20141128_160252_323861_636C535B)
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

>
>> I would like to enable TPC in ath9k using iw command:
>>
>> iw dev wlan0 set txpower auto
>>
>> I knew user_power_level is set to IEEE80211_UNSET_POWER_LEVEL in that
>> case. Is there a better way than to check user_power_level?
>
> But ... the API already allows for that flexibility? I think if anything
> you should expose the "TX power type" that the nl80211 API has.
>

I just need to notify lower driver (ath9k in my case) to setup TPC
registers in order to take into account TX power configured in frame
descriptors. For that purpose I added tpc_enabled flags in
ieee80211_bss_conf and in ieee80211_conf. Is there any other variables
I can use to notify that configuration?

Lorenzo

> johannes
>



-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
