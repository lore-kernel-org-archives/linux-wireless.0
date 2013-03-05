Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:43102 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab3CEQMn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Mar 2013 11:12:43 -0500
Received: by mail-wg0-f52.google.com with SMTP id 12so6004081wgh.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Mar 2013 08:12:42 -0800 (PST)
Date: Tue, 5 Mar 2013 17:10:03 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH v2 1/2] mac80211: get the rates masks from the txrc in
 rate_control_get_rate
Message-ID: <20130305161003.GA30419@magnum.frso.rivierawaves.com> (sfid-20130305_171248_862405_E133C07C)
References: <1362421635-28008-1-git-send-email-karl.beldan@gmail.com>
 <1362427924.21028.42.camel@jlt4.sipsolutions.net>
 <20130304204541.GA8819@gobelin>
 <5135F327.4000408@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <5135F327.4000408@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 05, 2013 at 02:29:11PM +0100, Felix Fietkau wrote:
> On 2013-03-04 9:45 PM, john wrote:
> > On Mon, Mar 04, 2013 at 09:12:04PM +0100, Johannes Berg wrote:
> >> On Mon, 2013-03-04 at 19:27 +0100, Karl Beldan wrote:
> >> > From: Karl Beldan <karl.beldan@rivierawaves.com>
> >> > 
> >> > Currently it gets it from the sdata. This uses and updates the ad-hoc
> >> > masks of the ieee80211_tx_rate_control instead of copying them.
> >> 
> >> Is there any need to update them?
> >> 
> >> The change for "mask" seems to make it less efficient since it could
> >> otherwise be put into a register.
> >> 
> > Totally, this commit spares the 10bytes copy of mcs_mask but adds a less
> > efficient indirection to mask.
> > I thought of it but kept the symmetry with mcs_mask.
> > Apparently you wouldn't mind the dissymmetry so I will re-send using mask
> > by value, plus I wrote "updates .." where it is more like "lets the
> > ad-hoc masks get overwritten".
> It seems to me that all of this could be made more efficient by default
> if a mcs mask pointer is only passed to rate control if the user
> actually configured a MCS mask. Also, filtering out rates from the mask
> that the sta does not support seems a bit unnecessary, since the rate
> control usually looks at the HT capabilities and the sta's mcs rx mask
> anyway.
> 
Yes, some things look a bit overkill in the masks logic.
 
Karl
