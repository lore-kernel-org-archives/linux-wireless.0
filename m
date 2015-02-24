Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38112 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177AbbBXKI4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 05:08:56 -0500
Message-ID: <1424772528.2192.13.camel@sipsolutions.net> (sfid-20150224_110908_827929_83DF8C16)
Subject: Re: Connection issues with BW Tracking in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 24 Feb 2015 11:08:48 +0100
In-Reply-To: <CABPxzYJD9KL1JngdKBwRqcGR2zFeo=hEfY0UVwAObd+E2ot5DQ@mail.gmail.com> (sfid-20150219_203032_581866_79C1F323)
References: <CABPxzYJD9KL1JngdKBwRqcGR2zFeo=hEfY0UVwAObd+E2ot5DQ@mail.gmail.com>
	 (sfid-20150219_203032_581866_79C1F323)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-02-20 at 01:00 +0530, Krishna Chaitanya wrote:
> Hi Johannes,
> 
> The BW tracking feature in mac80211 is causing connection problems and
> operating mode/bw problems when switching b/w modes and bw's in AP.
> 
> For Eg. Initially if AP is operating in VHT-80MHz, and then we changed
> in to HT-40MHz, mac80211 cannot handle it because the VHT capability
> is mismatched b/w stored info (ifmgd->flags).

How are you doing such a change? I was assuming that the BSS would cease
to exist if it was reconfigured in such a way.

> I have tried your DISABLE_BW_TRACK patch, that helps making the
> connection but it doesn't update the chipset causing issues.

Well, that was clearly going to happen.

> Ideally we should be able to handle all the config changes right?

Not sure. How does this config change work? I'd have expected the AP to
stop beaconing and kick everyone out if you actually reconfigured it to
no longer have VHT since then it can't do VHT rates any more either
according to the new config?

What exactly are you doing, and how does the AP behave, and what do you
expect to happen?

johannes

