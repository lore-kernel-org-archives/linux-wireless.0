Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53857 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab3KDQT6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Nov 2013 11:19:58 -0500
Received: by mail-bk0-f46.google.com with SMTP id e11so738442bkh.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Nov 2013 08:19:57 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	alexandre.f.demers@gmail.com, linville@tuxdriver.com
Subject: Re: r92su: status and will it be merged anytime soon?
Date: Mon, 04 Nov 2013 17:19:54 +0100
Message-ID: <8287832.vyseD3v7Cm@blech> (sfid-20131104_172002_173785_97464AA8)
In-Reply-To: <1383581060.14295.16.camel@jlt4.sipsolutions.net>
References: <5277AC85.5050104@gmail.com> <2241712.PWvD8zsTbX@blech> <1383581060.14295.16.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, November 04, 2013 05:04:20 PM you wrote:
> On Mon, 2013-11-04 at 16:47 +0100, Christian Lamparter wrote:
> 
> > Be careful ;-). mac80211 is great for softmac/umac/halfmac/semimac devices.
> > However the rtl8712 firmware interface is fullmac-like, so it needs cfg80211.
> > ... and r92su uses cfg80211 exclusively. There's no more WEXT or realtek ioctl
> > legacy API support.
> 
> still seems there's duplicate stuff in there like the michael MIC, at
> least lib80211 has that?
Yes, there is even more duplicated code if you factor in the (de-)fragmentation
and deaggregation code from mac80211. Furthermore r92su could be sharing a bit 
of infrastructure with rtlwifi.

I didn't include lib80211 since it reports mic failures via WEXT: 
wireless_send_event(dev, IWEVMICHAELMICFAILURE, &wrqu, (char *)&ev);
(And I don't think this can be changed easily without touching ipw2200
and hostap-driver).

Regards,

Christian
