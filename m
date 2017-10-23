Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:53074 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751295AbdJWUai (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Oct 2017 16:30:38 -0400
Message-ID: <1508790635.2639.24.camel@sipsolutions.net> (sfid-20171023_223041_628490_DDA607A6)
Subject: Re: A good way to get CSI info to user-space?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 23 Oct 2017 22:30:35 +0200
In-Reply-To: <6f9182c4-cff9-066c-173a-00d09af7c903@candelatech.com> (sfid-20171023_195440_976958_B20E3A62)
References: <6f9182c4-cff9-066c-173a-00d09af7c903@candelatech.com>
         (sfid-20171023_195440_976958_B20E3A62)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> I have been poking at ath10k to get some CSI reporting working.
> The CSI reports are a bit over 2k bytes in length, and they could
> happen quite often.  As far as I can tell, there is no good way in
> the kernel to make this available.
> 
> I was thinking maybe a callback into the mac80211 stack, which would
> then send a netlink event might be a useful way to implement this?

The CSI data has variable length [1] but it's fundamentally always tied
to a specific frame and as such we've always attached it to that frame
using a radiotap vendor namespace.

You can easily implement that in a mac80211 driver since it has support
for that via RX_FLAG_RADIOTAP_VENDOR_DATA and the associated struct
ieee80211_vendor_radiotap that you put into the skb's head.

Why should anything else be needed?

johannes

[1] mostly depending on the bandwidth
