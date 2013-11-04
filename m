Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35972 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab3KDScz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Nov 2013 13:32:55 -0500
Message-ID: <1383589965.14295.18.camel@jlt4.sipsolutions.net> (sfid-20131104_193300_551157_2A07512F)
Subject: Re: r92su: status and will it be merged anytime soon?
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	alexandre.f.demers@gmail.com, linville@tuxdriver.com
Date: Mon, 04 Nov 2013 19:32:45 +0100
In-Reply-To: <8287832.vyseD3v7Cm@blech> (sfid-20131104_171958_354595_246E4CB6)
References: <5277AC85.5050104@gmail.com> <2241712.PWvD8zsTbX@blech>
	 <1383581060.14295.16.camel@jlt4.sipsolutions.net>
	 <8287832.vyseD3v7Cm@blech> (sfid-20131104_171958_354595_246E4CB6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-11-04 at 17:19 +0100, Christian Lamparter wrote:

> Yes, there is even more duplicated code if you factor in the (de-)fragmentation
> and deaggregation code from mac80211. Furthermore r92su could be sharing a bit 
> of infrastructure with rtlwifi.

Yeah, that some of that seems to be duplicated in mwifiex too. I think
there'd be some benefit in trying to share more. Maybe moving some to
cfg80211? Or some new module?

> I didn't include lib80211 since it reports mic failures via WEXT: 
> wireless_send_event(dev, IWEVMICHAELMICFAILURE, &wrqu, (char *)&ev);
> (And I don't think this can be changed easily without touching ipw2200
> and hostap-driver).

Yeah that'd be tricky, though I guess you could pass a wdev pointer and
allow it to be NULL or so.

johannes

