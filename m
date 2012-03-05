Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47603 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab2CEGzg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 01:55:36 -0500
Subject: Re: [PATCH v2 2/2] mac80211: fix mesh airtime link metric
 estimating
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	open11s <devel@lists.open80211s.org>
In-Reply-To: <CAG6hwVMpZTG=vuidSvQvvJhBj=avW_JP5ewATLwTCZsNqcu5zw@mail.gmail.com> (sfid-20120304_235047_838378_68018E05)
References: <1330731963-9905-1-git-send-email-thomas@cozybit.com>
	 <1330731963-9905-2-git-send-email-thomas@cozybit.com>
	 <1330774678.3619.1.camel@jlt3.sipsolutions.net>
	 <CAG6hwVMo2ZgcNYDQ3UKRC2Wo_gibERBdgvaLWJmi52min8w3Hg@mail.gmail.com>
	 <CAG6hwVMpZTG=vuidSvQvvJhBj=avW_JP5ewATLwTCZsNqcu5zw@mail.gmail.com>
	 (sfid-20120304_235047_838378_68018E05)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Mar 2012 07:55:34 +0100
Message-ID: <1330930534.3545.3.camel@jlt3.sipsolutions.net> (sfid-20120305_075539_991049_6B05F6CE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-03-04 at 14:49 -0800, Thomas Pedersen wrote:

> >> For stack usage, it'd be better if you gave this two arguments (struct
> >> rate_info *txrate, struct rate_info *rxrate), or maybe simply factored
> >> out *only* the TX-rate bit?
> >>
> >
> > like sta_set_rate_info(struct sta_info *sta, struct rate_info *txrate,
> > struct rate_info *rxrate)?
> >
> > How do you feel about consolidating last_rx_flags and _index into an
> > ieee80211_tx_rate? A bit odd maybe, but then we could use:
> >
> > sta_set_rate_info(struct ieee80211_tx_rate *rate, struct rate_info *rinfo);
> >
> > As needed for both last_rx and last_tx rates.

Seems a little odd to first translate RX rate into TX rate and then to
cfg80211 info? But you only care about TX rate anyway so ... why worry
at all?

johannes

