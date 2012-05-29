Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:51990 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab2E2NMT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 09:12:19 -0400
Date: Tue, 29 May 2012 08:12:12 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH 4/8] brcm80211: smac: inform mac80211 of the X2
 regulatory domain
Message-ID: <20120529131212.GB28007@thinkpad-t410> (sfid-20120529_151223_077986_939802F8)
References: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com>
 <1334607462-5387-5-git-send-email-seth.forshee@canonical.com>
 <4FC008AB.4080107@broadcom.com>
 <20120526171800.GC11759@ubuntu-mba>
 <4FC21B3F.6090903@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FC21B3F.6090903@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 27, 2012 at 02:17:03PM +0200, Arend van Spriel wrote:
> On 05/26/2012 07:18 PM, Seth Forshee wrote:
> > On Sat, May 26, 2012 at 12:33:15AM +0200, Arend van Spriel wrote:
> >>> +#define BRCM_2GHZ_2412_2462	REG_RULE(2412-10, 2462+10, 40, 0, 19, 0)
> >>> +#define BRCM_2GHZ_2467_2472	REG_RULE(2467-10, 2472+10, 20, 0, 19, \
> >>> +					 NL80211_RRF_PASSIVE_SCAN | \
> >>> +					 NL80211_RRF_NO_IBSS)
> >>> +#define BRCM_2GHZ_2484		REG_RULE(2484-10, 2484+10, 40, 0, 19, \
> >>> +					 NL80211_RRF_PASSIVE_SCAN | \
> >>> +					 NL80211_RRF_NO_OFDM)
> >>> +
> >>
> >> If channels 12 and 13 are 20MHz only, shouldn't channel 14 above
> >> (2484MHz) be 20MHz as well?
> > 
> > Heh, good point. I'm trying to remember why I made 12 and 13 20MHz only
> > though; maybe that's a mistake. Is there any reason why they couldn't
> > all be 40MHz?
> 
> Not sure either. A number of countries have this rule so maybe it is
> regulatory requirement.

Maybe. I note that among the in-kernel rules, domain 00 only allows
20MHz for those frequencies, but ath and rtlwifi allow 40MHz. I'll be
conservative and leave them at 20MHz unless I hear otherwise from you.

> >> You can avoid this code if you/we do not add the channels to
> >> wiphy->bands[IEEE80211_BAND_5GHZ]. The driver does not support DFS so we
> >> better stay away from these channels, which was your original issue to
> >> start this work if I recall correct :-( Sorry.
> > 
> > This is what originally got me looking at the brcmsmac regulatory
> > support, so it would be disappointing if at the end these channels still
> > aren't usable.
> 
> Hence me saying sorry.
> 
> > My understanding of DFS is pretty rudamentary. Could you explain what
> > support is needed? I do see that mac80211 doesn't really support power
> > measurement requests, but if we can at least stop transmission when
> > radar is present couldn't we still operate on the channels?
> 
> The hardware would need to signal the driver that a radar has been detected.

Yes. I was trying to ask (not so clearly it turns out) whether or not
Broadcom hardware can do this.

I note that if I boot into OS X then I can use the DFS channels with
BCM43224. So obviously we should be able to use those frequencies. The
question I'm trying to get an answer to is what's needed in the Linux
driver to be in compliance. I'm planning to spend some time today
reading to better understand DFS in 802.11.

