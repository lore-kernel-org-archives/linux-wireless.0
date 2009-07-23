Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.232]:19512 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbZGWS4r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 14:56:47 -0400
Received: by rv-out-0506.google.com with SMTP id f6so324460rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2009 11:56:47 -0700 (PDT)
Subject: Re: [PATCH] compat-wireless-old: Fix problem with TX on amd64
From: Gao Lei <lei.alvin.gao@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890907221230m53109c3eqf388a2d987d8cdda@mail.gmail.com>
References: <1248290605.4717.76.camel@mountain.triplerocks.net>
	 <43e72e890907221230m53109c3eqf388a2d987d8cdda@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 24 Jul 2009 02:54:40 +0800
Message-Id: <1248375280.22109.33.camel@mountain.triplerocks.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-07-22 at 12:30 -0700, Luis R. Rodriguez wrote:
> On Wed, Jul 22, 2009 at 12:23 PM, Gao Lei wrote:
> > On amd64, the `ieee80211_tx_info' struct takes 56 bytes, thus cannot fit
> > into skb's control buffer.
>
> Thanks, what kernel is this against BTW? Just so you know we should be
> able to bring down compat-wireless down to 2.6.21 and maybe even
> further now that we no longer are using the master netdev, which used
> the multiqueue support added as of 2.6.27. Last I checked
> compat-wireless now compiles on 2.6.25, but I never actually tried
> loading it as I'm on ext4. So if you are on 2.6.25 or 2.6.26 you may
> want to try out compat-wireless directly and see if to works. If you
> are on 2.6.21..2.6.24 you can try adding backport support. I've added
> a few files already for older kernel support based on our old
> compat-wireless-old effort, so only the new stuff that mac80211 makes
> use of should require backporting.
> 
>   Luis

Hi,

I am using kernel 2.6.26. Just tested compat-wireless and yes it works!
Here the TX info struct takes exactly 48 bytes so it can fit well into
the control buffer.

Btw, I came up with the 'iwlagn: Unknown symbol iwl4965_agn_cfg' issue
though (actually also in compat-wireless-old). Strange as it seems
there're already some treatments there. Will look at it later.

While it's great to see compat-wireless working for more old kernels, I
wonder if compat-wireless-old is still actively maintained? Asking this
because currently most of the documentations still describe it as
'compat-wireless-old for <= 2.6.26 and compat-wireless for >= 2.6.27',
and I was probably not the only amd64 user reading that. :)

Best regards,
Gao Lei

