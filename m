Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:55770 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934462Ab3FSQ5q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 12:57:46 -0400
Received: by mail-ob0-f173.google.com with SMTP id wc20so6314322obb.32
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jun 2013 09:57:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130619164227.GC4784@cmadams.net>
References: <20130619160911.GB4784@cmadams.net>
	<51C1DDEB.3090701@lwfinger.net>
	<20130619164227.GC4784@cmadams.net>
Date: Wed, 19 Jun 2013 18:57:45 +0200
Message-ID: <CACna6rzbTHnyqs5SzTuYL7r_SW3iCNh0qqbnvfsF7Wspyhp1WA@mail.gmail.com> (sfid-20130619_185751_579944_9097F2B0)
Subject: Re: BCM4331 deauthenticates every five minutes
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	b43-dev@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/6/19 Chris Adams <cmadams@cmadams.net>:
> Once upon a time, Larry Finger <Larry.Finger@lwfinger.net> said:
>> What type of encryption are you using? If it is a re-keying type
>> such as TKIP, what is the interval? You should find that on the
>> setup page of the access point.
>
> I don't have access to the management of this particular AP (work
> environment), but "iw dev wlan0 scan dump" says CCMP.

I think some key interval applies not only to the TKIP, but also other
keys. For example GTK (which is part of WPA2 with it's 4-way
handshake). GTK is Group Temporal Key, and Broadcom's router have a
setting called "GTK rotation interval". I guess PMK/PTK also can have
some intervals.

I don't know how/if driver can be responsible for such reconnects.
Over all it just TX and RX packets, right? Loosing a signal is
something different, that can be related to the driver's bug. But as
this happens every 5 minutes... I don't know.

Did you try connecting to this AP with any other card and using
similar kernel? I wonder if this can be some supplicant / mac80211
stack issue...

-- 
Rafał
