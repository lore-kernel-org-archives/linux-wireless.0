Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:55233 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab3CJWPi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Mar 2013 18:15:38 -0400
Received: by mail-wg0-f47.google.com with SMTP id dr13so4421006wgb.14
        for <linux-wireless@vger.kernel.org>; Sun, 10 Mar 2013 15:15:37 -0700 (PDT)
Date: Sun, 10 Mar 2013 23:16:27 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH v2 1/2] mac80211: get the rates masks from the txrc in
 rate_control_get_rate
Message-ID: <20130310221627.GA3824@gobelin> (sfid-20130310_231542_971337_10423E54)
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
Filtering is necessary to lookup alternative downgrade/upgrade rates.
 
Karl
