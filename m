Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:63030 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494Ab2ECV5T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 17:57:19 -0400
Received: by qadb17 with SMTP id b17so631071qad.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 14:57:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABF+-6UgQek50abaLnUsBh3LEccG2Pd1vFQDiLyxgcky-JN4Ag@mail.gmail.com>
References: <CABF+-6XxBKMx2wKuJr+idc9igeB-NHRCh0rL7eCyWifgH1YoKg@mail.gmail.com>
	<4FA15A70.2020108@stericsson.com>
	<CABF+-6XbdG_QMa0iQJMpbOsr4bXCq4mDEB6unkM8jxNGWYwFyQ@mail.gmail.com>
	<4FA23DA0.3030207@stericsson.com>
	<CABF+-6WjnVxC55iGHwoaL2zJ+_6oLbkVjaqwwLLrQzZxKwwWxw@mail.gmail.com>
	<4FA2BF0A.4040307@stericsson.com>
	<CABF+-6UgQek50abaLnUsBh3LEccG2Pd1vFQDiLyxgcky-JN4Ag@mail.gmail.com>
Date: Thu, 3 May 2012 23:57:18 +0200
Message-ID: <CAFED-jkzELRHGy7pwqDznLqPzhandwZLQEoCEFvw5F6ogMxiYA@mail.gmail.com> (sfid-20120503_235723_103089_1C48564E)
Subject: Re: [PATCHv2 00/21] cw1200: ST-Ericsson cw1200 wlan device driver
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: Kevin Groeneveld <kgroeneveld@gmail.com>
Cc: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/5/3 Kevin Groeneveld <kgroeneveld@gmail.com>:
> Hi Dmitry,
>
>> It looks like mac80211 tries to monitor beacons and they are filtered by
>> cw1200 device.
>>
>> IEEE80211_HW_CONNECTION_MONITOR and / or IEEE80211_HW_BEACON_FILTER flags
>> (I don't remember, but both of them should be set) should prevent mac80211
>> from
>> monitoring. Please check if they are set in
>> drivers/net/wireless/cw1200/main.c
>
> main.c contains the following as in the patches that you posted:
>
> hw->flags = IEEE80211_HW_SIGNAL_DBM |
>                    IEEE80211_HW_SUPPORTS_PS |
>                    IEEE80211_HW_SUPPORTS_DYNAMIC_PS |
>                    IEEE80211_HW_REPORTS_TX_ACK_STATUS |
>                    IEEE80211_HW_SUPPORTS_UAPSD |
>                    IEEE80211_HW_CONNECTION_MONITOR |
>                    IEEE80211_HW_NEED_DTIM_PERIOD;
>
> IEEE80211_HW_BEACON_FILTER does not seem to be defined anywhere in the
> header files.  Do I need this?
>
>>>> Also I see unexpectedly high rate of IRQs, they should not come every now
>>>> and then..
>>>
>>> Any ideas what could cause this or how I should debug it?
>>
>> Are you running with SDIO or GPIO IRQ?
>
> I am using SDIO IRQ.
>
>

Seems this flag is per vif in new compat now.
IEEE80211_VIF_BEACON_FILTER
IEEE80211_VIF_SUPPORTS_CQM_RSSI

So, you should configure this in cw1200_add_interface() for new compat-wireless:

	vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER |
			     IEEE80211_VIF_SUPPORTS_CQM_RSSI;


BR
Janusz
