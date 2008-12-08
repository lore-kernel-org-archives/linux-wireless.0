Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:62213 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbYLHN1D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 08:27:03 -0500
Received: by wa-out-1112.google.com with SMTP id v27so530314wah.21
        for <linux-wireless@vger.kernel.org>; Mon, 08 Dec 2008 05:27:02 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18749.8223.628121.271121@localhost.localdomain> (sfid-20081208_142708_360752_09344A8E)
Date: Mon, 8 Dec 2008 18:54:47 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, Jouni.Malinen@atheros.com,
	Luis.Rodriguez@atheros.com, tomas.winkler@intel.com
Subject: Re: [RFC v2] mac80211: fix HT channel selection
In-Reply-To: <1228742349.22164.82.camel@johannes.berg>
References: <18748.62215.331271.141163@gargle.gargle.HOWL>
	<20081208131440.GA7365@jm.kir.nu>
	<1228742349.22164.82.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Mon, 2008-12-08 at 15:14 +0200, Jouni Malinen wrote:
> > On Mon, Dec 08, 2008 at 03:42:23PM +0530, Sujith wrote:
> > 
> > > HT management is done differently for AP and STA modes, unify
> > > to just the ->config() callback since HT is fundamentally a
> > > PHY property and cannot be per-BSS.
> > > 
> > > Add a new NL80211 attribute to enable/disable HT (NL80211_ATTR_WIPHY_HT).
> > > NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET now has only the secondary channel
> > > offsets.
> > 
> > Looks reasonable to me. Please just make sure this gets in before
> > NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET additions get included in any
> > official kernel release since otherwise this would change the userspace
> > API..
> 
> I don't like it because it allows specifying "disabled/_above" and a
> bunch of other invalid combinations.
> 

Ok, I'll remove this attribute and just rename enum nl80211_sec_chan_offset to
something else.

Sujith
