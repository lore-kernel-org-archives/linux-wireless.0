Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44256 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab1JKLvU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 07:51:20 -0400
Subject: Re: [PATCH] mac80211: Populate radiotap header with MCS info for
 tx'ed frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <CAGXE3d8cuBg28PfMYQcAJ96oTEqUg6rG8ExUr+Sezq51eM2J_Q@mail.gmail.com> (sfid-20111011_134834_133793_0F4839D3)
References: <1318332535-8815-1-git-send-email-helmut.schaa@googlemail.com>
	 <1318332927.3965.9.camel@jlt3.sipsolutions.net>
	 <CAGXE3d8cuBg28PfMYQcAJ96oTEqUg6rG8ExUr+Sezq51eM2J_Q@mail.gmail.com>
	 (sfid-20111011_134834_133793_0F4839D3)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Oct 2011 13:51:15 +0200
Message-ID: <1318333875.3965.10.camel@jlt3.sipsolutions.net> (sfid-20111011_135123_367444_9F441A94)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-10-11 at 13:48 +0200, Helmut Schaa wrote:
> On Tue, Oct 11, 2011 at 1:35 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > So using something like
> > this would allow us to save some space as well:
> >
> > struct ieee80211_tx_status_rtap_hdr {
> >        struct ieee80211_radiotap_header hdr;
> >        union {
> >                struct {
> >                        u8 rate;
> >                        u8 padding_for_rate;
> >                        __le16 tx_flags;
> >                        u8 data_retries;
> >                } non_mcs;
> >                struct {
> >                        __le16 tx_flags;
> >                        u8 data_retries;
> >                        u8 mcs_known, mcs_flags, mcs;
> >                } mcs;
> >        }
> > } __packed;
> 
> I thought about the same but this means we have to fill in
> different fields (non_mcs.tx_flags vs mcs.tx_flags) for the MCS
> vs legacy path and set the radiotap header len differently in
> both cases.

Good point.

> Or should we just get rid of the whole struct and fill in the
> rtap header dynamically like it is done in the rx path and
> drop the build-bug-on thing?

I wouldn't mind that either, but we'll want to have a WARN_ON_ONCE()
somewhere if we run out of space.

johannes

