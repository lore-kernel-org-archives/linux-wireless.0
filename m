Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:43476 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab0AUPuV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 10:50:21 -0500
Received: by ewy19 with SMTP id 19so121936ewy.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2010 07:50:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1263982729.14538.5.camel@johannes.local>
References: <op.u6s09akf9lhzdc@linux-g0th.site>
	 <1263982729.14538.5.camel@johannes.local>
Date: Thu, 21 Jan 2010 16:50:20 +0100
Message-ID: <b170af451001210750t123a94e2r833e075933c06752@mail.gmail.com>
Subject: Re: [RFC] How to store HT (40MHz) support
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>,
	"bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 20 stycznia 2010 11:18 użytkownik Johannes Berg
<johannes@sipsolutions.net> napisał:
> On Wed, 2010-01-20 at 01:06 +0100, Rafał Miłecki wrote:
>> +             phy->use_40mhz = conf_is_ht(conf);
>
> This is wrong, conf_is_ht might also be 20mhz, look at the other
> helpers.

I tried to understand what actually is HT and after reading many
articles I have more knowledge but still I'm not 100% sure.

AFAIU:
1) HT means using more than 1 stream in channel (and can be on any:
20MHz or 40MHz)
2) conf_is_ht(...) checks if mac80211 want us to use more than 1
stream in channel
3) conf_is_ht40_minus(...) checks if we should use frequency below
current as additional 20MHz, so for example for channel 7 which is
2,431->2,453 we should use additinal 20MHz in channel 3 which is
2,411->2,433
4) conf_is_ht40_plus(...) checks if we should use frequency over
current as additional 20MHz, so for example for channel 3 which is
2,411->2,433 we should use additinal 20MHz in channel 7 which is
2,431->2,453

Is that correct?

-- 
Rafał
