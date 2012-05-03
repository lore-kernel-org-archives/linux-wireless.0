Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41728 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746Ab2ECS5Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 14:57:24 -0400
Received: by wgbdr13 with SMTP id dr13so2037100wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 11:57:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FA2BF0A.4040307@stericsson.com>
References: <CABF+-6XxBKMx2wKuJr+idc9igeB-NHRCh0rL7eCyWifgH1YoKg@mail.gmail.com>
	<4FA15A70.2020108@stericsson.com>
	<CABF+-6XbdG_QMa0iQJMpbOsr4bXCq4mDEB6unkM8jxNGWYwFyQ@mail.gmail.com>
	<4FA23DA0.3030207@stericsson.com>
	<CABF+-6WjnVxC55iGHwoaL2zJ+_6oLbkVjaqwwLLrQzZxKwwWxw@mail.gmail.com>
	<4FA2BF0A.4040307@stericsson.com>
Date: Thu, 3 May 2012 14:57:23 -0400
Message-ID: <CABF+-6UgQek50abaLnUsBh3LEccG2Pd1vFQDiLyxgcky-JN4Ag@mail.gmail.com> (sfid-20120503_205737_176930_93439977)
Subject: Re: [PATCHv2 00/21] cw1200: ST-Ericsson cw1200 wlan device driver
From: Kevin Groeneveld <kgroeneveld@gmail.com>
To: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dmitry,

> It looks like mac80211 tries to monitor beacons and they are filtered by
> cw1200 device.
>
> IEEE80211_HW_CONNECTION_MONITOR and / or IEEE80211_HW_BEACON_FILTER flags
> (I don't remember, but both of them should be set) should prevent mac80211
> from
> monitoring. Please check if they are set in
> drivers/net/wireless/cw1200/main.c

main.c contains the following as in the patches that you posted:

hw->flags = IEEE80211_HW_SIGNAL_DBM |
		    IEEE80211_HW_SUPPORTS_PS |
		    IEEE80211_HW_SUPPORTS_DYNAMIC_PS |
		    IEEE80211_HW_REPORTS_TX_ACK_STATUS |
		    IEEE80211_HW_SUPPORTS_UAPSD |
		    IEEE80211_HW_CONNECTION_MONITOR |
		    IEEE80211_HW_NEED_DTIM_PERIOD;

IEEE80211_HW_BEACON_FILTER does not seem to be defined anywhere in the
header files.  Do I need this?

>>> Also I see unexpectedly high rate of IRQs, they should not come every now
>>> and then..
>>
>> Any ideas what could cause this or how I should debug it?
>
> Are you running with SDIO or GPIO IRQ?

I am using SDIO IRQ.


Thanks,

Kevin
