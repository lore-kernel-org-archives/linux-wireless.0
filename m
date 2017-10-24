Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:57822 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750886AbdJXFyZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Oct 2017 01:54:25 -0400
Message-ID: <1508824462.2639.25.camel@sipsolutions.net> (sfid-20171024_075430_904389_E0B70748)
Subject: Re: A good way to get CSI info to user-space?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 24 Oct 2017 07:54:22 +0200
In-Reply-To: <76d6a1ad-2dc4-0542-808f-4be459c3508a@candelatech.com>
References: <6f9182c4-cff9-066c-173a-00d09af7c903@candelatech.com>
         <1508790635.2639.24.camel@sipsolutions.net>
         <76d6a1ad-2dc4-0542-808f-4be459c3508a@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-10-23 at 13:59 -0700, Ben Greear wrote:

> > The CSI data has variable length [1] but it's fundamentally always tied
> > to a specific frame and as such we've always attached it to that frame
> > using a radiotap vendor namespace.
> > 
> > You can easily implement that in a mac80211 driver since it has support
> > for that via RX_FLAG_RADIOTAP_VENDOR_DATA and the associated struct
> > ieee80211_vendor_radiotap that you put into the skb's head.
> > 
> > Why should anything else be needed?
> 
> So this would only show up in user-space in something like a pkt-capture?

Sure. But since you can easily add virtual monitor interfaces at any
time, that doesn't really mean anything.

johannes
