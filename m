Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:37802 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729472AbeHNOlf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 10:41:35 -0400
Message-ID: <1534247624.3547.28.camel@sipsolutions.net> (sfid-20180814_135447_527237_756C88B4)
Subject: Re: [PATCH] mac80211: allow station search on AP/VLANs
From: Johannes Berg <johannes@sipsolutions.net>
To: Manikanta Pubbisetty <mpubbise@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 14 Aug 2018 13:53:44 +0200
In-Reply-To: <1f50369a-61ae-cd7b-1300-78392852ebb5@codeaurora.org>
References: <1532931620-3161-1-git-send-email-mpubbise@codeaurora.org>
         <1534246103.3547.23.camel@sipsolutions.net>
         <1f50369a-61ae-cd7b-1300-78392852ebb5@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-08-14 at 17:22 +0530, Manikanta Pubbisetty wrote:
> On 8/14/2018 4:58 PM, Johannes Berg wrote:
> 
> > On Mon, 2018-07-30 at 11:50 +0530, Manikanta Pubbisetty wrote:
> > > When mac80211 receives a packet, we interate over the list of
> > > active interfaces to find the station(which transmitted the packet).
> > > Currently, station search is not allowed on AP/VLAN interface; since
> > > stations can also get mapped to AP/VLAN interfaces, they are worth
> > > considering for station search.
> > 
> > I don't see how this makes sense. We use sta_info_get_bss() later, so
> > any AP/AP_VLAN would be OK, so we don't need to try it twice for
> > AP_VLAN?
> 
> AP/VLANs are skipped currently, we don't even get to sta_info_get_bss() 
> if the iftype is AP/VLAN. No?

Yes, we won't try anything for the AP_VLANs, but when we hit the AP we
look up through everything, no?

Or maybe not - the _bss() just means fallback to AP?

Hmm. But even then I can't really see where this would apply?

johannes
