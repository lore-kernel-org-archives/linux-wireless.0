Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:46071 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab3KDTKq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Nov 2013 14:10:46 -0500
Received: by mail-pa0-f51.google.com with SMTP id ld10so7263575pab.24
        for <linux-wireless@vger.kernel.org>; Mon, 04 Nov 2013 11:10:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1383589965.14295.18.camel@jlt4.sipsolutions.net>
References: <5277AC85.5050104@gmail.com>
	<2241712.PWvD8zsTbX@blech>
	<1383581060.14295.16.camel@jlt4.sipsolutions.net>
	<8287832.vyseD3v7Cm@blech>
	<1383589965.14295.18.camel@jlt4.sipsolutions.net>
Date: Mon, 4 Nov 2013 14:10:46 -0500
Message-ID: <CAPEhTTHmNH5rMfnwULE+1e_koSw-p0DmV=Up_Dvf3bcXuL0kew@mail.gmail.com> (sfid-20131104_201049_909283_B89921E2)
Subject: Re: r92su: status and will it be merged anytime soon?
From: Alexandre Demers <alexandre.f.demers@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As I understand it, there is a will to replace r8712u with r92su. I
was thinking about it this weekend and if it is saner and nearer to
where the community wants to bring the driver, why not go with it?
Could we think about merging it in the staging drivers for kernel 3.13
and tag r8712u as deprecated? One could always build it or try r92su
instead, which would give a better overlook about its shape and
performance, don't you think?

Alexandre

On Mon, Nov 4, 2013 at 1:32 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2013-11-04 at 17:19 +0100, Christian Lamparter wrote:
>
>> Yes, there is even more duplicated code if you factor in the (de-)fragmentation
>> and deaggregation code from mac80211. Furthermore r92su could be sharing a bit
>> of infrastructure with rtlwifi.
>
> Yeah, that some of that seems to be duplicated in mwifiex too. I think
> there'd be some benefit in trying to share more. Maybe moving some to
> cfg80211? Or some new module?
>
>> I didn't include lib80211 since it reports mic failures via WEXT:
>> wireless_send_event(dev, IWEVMICHAELMICFAILURE, &wrqu, (char *)&ev);
>> (And I don't think this can be changed easily without touching ipw2200
>> and hostap-driver).
>
> Yeah that'd be tricky, though I guess you could pass a wdev pointer and
> allow it to be NULL or so.
>
> johannes
>
