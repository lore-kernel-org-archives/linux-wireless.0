Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55248 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760100AbcLPJam (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Dec 2016 04:30:42 -0500
Message-ID: <1481880638.27953.10.camel@sipsolutions.net> (sfid-20161216_103058_984261_DB7674AE)
Subject: Re: [RFC 1/3] mac80211: Add provision for 802.11 encap/decap offload
From: Johannes Berg <johannes@sipsolutions.net>
To: "Thiagarajan, Vasanthakumar" <vthiagar@qti.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 16 Dec 2016 10:30:38 +0100
In-Reply-To: <585273D4.7030100@qti.qualcomm.com>
References: <1481781608-5181-1-git-send-email-vthiagar@qti.qualcomm.com>
         <1481781608-5181-2-git-send-email-vthiagar@qti.qualcomm.com>
         <1481793392.31776.3.camel@sipsolutions.net>
         <585273D4.7030100@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-12-15 at 10:43 +0000, Thiagarajan, Vasanthakumar wrote:
> On Thursday 15 December 2016 02:46 PM, Johannes Berg wrote:
> > 
> > > Drivers advertising this capability should also implement other
> > > functionalities which deal with 802.11 frame format like below
> > > 	- ADDBA/DELBA offload
> > 
> > This shouldn't be necessary.
> 
> Ok. Since driver/hw needs to implement Tx/Rx aggregation related
> functionalities I thought ADDBA/DELBA processing will be little
> important to mac80211. May be I'm missing something.

It needs to do the aggregation of the data flows, but I don't think the
control flows will need to be offloaded entirely? We'd need to have
some feedback mechanism for the SN used etc., so that might be up to
the driver to implement and might not be easy.

Anyway, I'm only suggesting to drop this from the documentation since
it doesn't seem strictly necessary, assuming the driver can report the
correct SSN in the callback all the A-MPDU setup should work more or
less as-is (except I think mac80211 won't buffer frames while doing it,
so also that would have to be done by the driver).

> > > 	- Powersave offload
> > 
> > That's ambiguous - you do need to handle sleeping stations (and PS-
> > Poll/U-APSD) in AP mode in the device with this,
> 
> I did not dig deep into PS requirement with ethernet frame format
> because frame control is not available to mac80211, so I thought to
> mention PS offload is a requirement. May be there is already an
> infrastructure in mac80211 to learn PS state of client which was
> notified in the current data frame (other than 802.11 frame control).
> 
>   but I don't see a deep
> > technical reason to require it for client mode. OTOH, client mode
> > is
> > almost always offloaded anyway.
> 
> Ok.

Actually, come to think of it, the whole client-side powersave stuff is
so broken that I can't recommend using it - perhaps just clarify this
and say:

 * AP: offloaded support for powersaving clients
 * non-AP: offloaded support for powersave (if desired)

> > I think you may have forgotten one important item,
> > 
> > 	- control port handling
> 
> Hmmm, I'm getting WPA-PSK working with this. May be there are other
> control port handling which will not work with ethernet frame format?

I think I later saw control port handling in your 802.3 RX code - my
review at this point was tainted by some thoughts I had how I thought
it should work, but it's different :)

> > > +	int (*get_vif_80211_hdr_offload)(struct ieee80211_hw
> > > *hw,
> > > +					 struct ieee80211_vif
> > > *vif,
> > > +					 bool is_4addr, bool
> > > *supported);
> > 
> > Why are you not simply returning "supported"?
> > 
> > I don't like passing the vif pointer here. At this point, the vif
> > pointer isn't known to the driver yet (through drv_add_interface)
> > so it's a dead pointer as far as the sequencing is concerned.
> > 
> > Is there a possibility that drivers need to switch off ethernet
> > format handling entirely when an incompatible interface is added?
> > For example, if you add a mesh interface, is there a chance that
> > the AP interface might no longer be able to handle this?
> 
>  >
>  > I'd hope this doesn't happen because I think that would 
> be extremely
>  > complicated to handle safely.
> 
> Unfortunately "[RFC 2/3] mac80211: Implement data xmit for 802.11
> encap offload" tries to implement this but more likely buggy :(. You
> are right, it is very complex to get that right. May be we should not
> allow interface needing dynamic switch?

We discussed this over in the other part of the thread :)

johannes
