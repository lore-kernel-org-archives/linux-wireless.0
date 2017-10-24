Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:36136 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751525AbdJXNic (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Oct 2017 09:38:32 -0400
Message-ID: <1508852310.2639.29.camel@sipsolutions.net> (sfid-20171024_153836_879156_07C31C24)
Subject: Re: A good way to get CSI info to user-space?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 24 Oct 2017 15:38:30 +0200
In-Reply-To: <d1746cd6-d889-a253-3638-8011d1ebd4fb@candelatech.com>
References: <6f9182c4-cff9-066c-173a-00d09af7c903@candelatech.com>
         <1508790635.2639.24.camel@sipsolutions.net>
         <76d6a1ad-2dc4-0542-808f-4be459c3508a@candelatech.com>
         <1508824462.2639.25.camel@sipsolutions.net>
         <d1746cd6-d889-a253-3638-8011d1ebd4fb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-10-24 at 06:36 -0700, Ben Greear wrote:
> 
> On 10/23/2017 10:54 PM, Johannes Berg wrote:
> > On Mon, 2017-10-23 at 13:59 -0700, Ben Greear wrote:
> > 
> > > > The CSI data has variable length [1] but it's fundamentally always tied
> > > > to a specific frame and as such we've always attached it to that frame
> > > > using a radiotap vendor namespace.
> > > > 
> > > > You can easily implement that in a mac80211 driver since it has support
> > > > for that via RX_FLAG_RADIOTAP_VENDOR_DATA and the associated struct
> > > > ieee80211_vendor_radiotap that you put into the skb's head.
> > > > 
> > > > Why should anything else be needed?
> > > 
> > > So this would only show up in user-space in something like a pkt-capture?
> > 
> > Sure. But since you can easily add virtual monitor interfaces at any
> > time, that doesn't really mean anything.
> 
> Adding a monitor device is a pretty big hammer on ath10k, at least, and
> probably not something one would want running continuously in a production
> environment.

We keep having this discussion. You need to fix this, it should be
really simple to fix this - just remove all checks for CONF_MONITOR
from ath10k and make it use WANT_MONITOR_VIF instead if it doesn't
already.

> The CSI data is one part, but tx-beamforming is another area of interest.
> 
> If I get a chance, I'll try to add a way to pass some of this opaque
> info up through netlink events.  I'm thinking something like:
> 
> mac80211_nl_send_opaque_event(mac80211-handle, int data-type, u8* data, int data_len);

I will not accept this upstream.

johannes
