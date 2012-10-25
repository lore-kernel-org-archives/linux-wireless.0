Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52050 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760100Ab2JYTUC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 15:20:02 -0400
Message-ID: <1351192833.10421.16.camel@jlt4.sipsolutions.net> (sfid-20121025_212007_102317_EB46E047)
Subject: Re: [PATCH] mac80211: Don't inspect Sequence Control field on
 control frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: linville@tuxdriver.com, Javier Lopez <jlopex@cozybit.com>,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Thu, 25 Oct 2012 21:20:33 +0200
In-Reply-To: <CAPjQAd9T5Ju3aEE1HeWT_5zLjW+rPQWkGQbh5Km9E1XunyFB9A@mail.gmail.com> (sfid-20121025_211316_966656_B5DA9711)
References: <1351188618-11155-1-git-send-email-javier@cozybit.com>
	 <1351191838.10421.15.camel@jlt4.sipsolutions.net>
	 <CAPjQAd9T5Ju3aEE1HeWT_5zLjW+rPQWkGQbh5Km9E1XunyFB9A@mail.gmail.com>
	 (sfid-20121025_211316_966656_B5DA9711)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-10-25 at 12:12 -0700, Javier Cardona wrote:

> >>       hdr = (struct ieee80211_hdr *)rx->skb->data;
> >>       fc = hdr->frame_control;
> >> +
> >> +     if (ieee80211_is_ctl(fc))
> >> +             return RX_CONTINUE;
> >
> > Shouldn't that be "goto out"?
> 
> If we goto out, we'll increment the rx_packets counter, which
> according to sta_info.h should only count MSDUs.

Ok.

> > And it seems it should also incorporate the skb->len check here, rather than accessing the field before checking
> > that it's present?
> 
> ieee80211_rx_h_check() zaps all skbs with len < 16, so I don't think
> it's needed, no?

But the sequence control field is at offset 22, I think?

johannes

