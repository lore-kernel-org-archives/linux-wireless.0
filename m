Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:59663 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512Ab2EDAKu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 20:10:50 -0400
Received: by vbbff1 with SMTP id ff1so1706902vbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 17:10:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFED-jkzELRHGy7pwqDznLqPzhandwZLQEoCEFvw5F6ogMxiYA@mail.gmail.com>
References: <CABF+-6XxBKMx2wKuJr+idc9igeB-NHRCh0rL7eCyWifgH1YoKg@mail.gmail.com>
	<4FA15A70.2020108@stericsson.com>
	<CABF+-6XbdG_QMa0iQJMpbOsr4bXCq4mDEB6unkM8jxNGWYwFyQ@mail.gmail.com>
	<4FA23DA0.3030207@stericsson.com>
	<CABF+-6WjnVxC55iGHwoaL2zJ+_6oLbkVjaqwwLLrQzZxKwwWxw@mail.gmail.com>
	<4FA2BF0A.4040307@stericsson.com>
	<CABF+-6UgQek50abaLnUsBh3LEccG2Pd1vFQDiLyxgcky-JN4Ag@mail.gmail.com>
	<CAFED-jkzELRHGy7pwqDznLqPzhandwZLQEoCEFvw5F6ogMxiYA@mail.gmail.com>
Date: Thu, 3 May 2012 20:10:49 -0400
Message-ID: <CABF+-6WvgwjkrD6WG8GxcXQ+JM7szugFWZbLN6ssJ8589Q7-BA@mail.gmail.com> (sfid-20120504_021053_936181_0CB9D211)
Subject: Re: [PATCHv2 00/21] cw1200: ST-Ericsson cw1200 wlan device driver
From: Kevin Groeneveld <kgroeneveld@gmail.com>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Cc: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Janusz,

> Seems this flag is per vif in new compat now.
> IEEE80211_VIF_BEACON_FILTER
> IEEE80211_VIF_SUPPORTS_CQM_RSSI
>
> So, you should configure this in cw1200_add_interface() for new
> compat-wireless:
>
>        vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER |
>                             IEEE80211_VIF_SUPPORTS_CQM_RSSI;

Thanks for the suggestion.  I will take a look at this tomorrow.

On a positive note, just before leaving for the day I fired up hostapd
and was able to connect a couple clients to the cw1200 in AP mode!  I
didn't test it very much but it seemed to be working okay.  I
transferred a couple hundred MB of data without any issue.  I was only
getting about 500kB per second but I suspect all the logging I have
turned on may be slowing it down.  I am not even sure what rate I was
connected at as I was using an old MacBook for the test and not being
a Mac guy I couldn't figure out how to see what rate the WiFi was
connected at.

So if AP mode is working station mode can't be that far off...


Thanks,

Kevin
