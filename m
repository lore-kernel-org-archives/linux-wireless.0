Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:45218 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbbBXVLe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 16:11:34 -0500
Received: by mail-wi0-f180.google.com with SMTP id h11so473701wiw.1
        for <linux-wireless@vger.kernel.org>; Tue, 24 Feb 2015 13:11:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1424810867.2192.60.camel@sipsolutions.net>
References: <CABPxzYJD9KL1JngdKBwRqcGR2zFeo=hEfY0UVwAObd+E2ot5DQ@mail.gmail.com>
 <CABPxzYLuCdoBNJXU88TOCLWZoQKYBDSF_QgLfhuG2cXu5mc9Aw@mail.gmail.com>
 <1424772587.2192.14.camel@sipsolutions.net> <CABPxzY+fhpwaS1Pr7_rirPbWy+TOEqSH3yA+gE5JADL_3gczkA@mail.gmail.com>
 <1424774105.2192.29.camel@sipsolutions.net> <CABPxzYJkoCWud=yfNHL5m2FUCPOc854i_L+VB4sN+o8Skb-Pnw@mail.gmail.com>
 <CABPxzYL4Fz+y7dpp650RyqXVWtL5WC4YkvsQ1_=znOmrmUZF5A@mail.gmail.com> <1424810867.2192.60.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Wed, 25 Feb 2015 02:41:13 +0530
Message-ID: <CABPxzY+Z97Q4JSSaR2GfGnxbbR721qJ-v_AjG4Kc1TGetHF4ng@mail.gmail.com> (sfid-20150224_221138_030310_0D65C218)
Subject: Re: Connection issues with BW Tracking in mac80211
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 25, 2015 at 2:17 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2015-02-25 at 02:03 +0530, Krishna Chaitanya wrote:
>
>> Use case2: When changing from HT40-VHT80, the connection goes through
>> but it still connected as HT40 (vht_ie from cfg80211 is returned
>> null).
>>
>> Can you think of any reason why the bss_list is not updated cfg80211?
>> Note: iwconfig and wpa_supplicant both show same behavior.
>
> Well, there's no flushing, only overwriting by new results - but if you
> previuosly got both beacons and probe responses each one will stick
> around until you get them again.
We do have the scan results expiry time of 30secs, that will flush the
results from bss_list right? Even the get_bss checks for aging?
>
> This sounds synthetic - just run your test scripts with "iw wlan0 scan
> flush".
Sure, will give it a shot.
