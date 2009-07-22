Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:24386 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbZGVTao convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2009 15:30:44 -0400
Received: by qw-out-2122.google.com with SMTP id 8so238899qwh.37
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2009 12:30:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1248290605.4717.76.camel@mountain.triplerocks.net>
References: <1248290605.4717.76.camel@mountain.triplerocks.net>
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Date: Wed, 22 Jul 2009 12:30:23 -0700
Message-ID: <43e72e890907221230m53109c3eqf388a2d987d8cdda@mail.gmail.com>
Subject: Re: [PATCH] compat-wireless-old: Fix problem with TX on amd64
To: Gao Lei <lei.alvin.gao@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 22, 2009 at 12:23 PM, Gao Lei<lei.alvin.gao@gmail.com> wrote:
> On amd64, the `ieee80211_tx_info' struct takes 56 bytes, thus cannot fit
> into skb's control buffer.
>
> The very first result is that nothing can be really sent out, because
> skb's next member `len' also gets cleared when doing:
>
>        info = IEEE80211_SKB_CB(skb);
>        memset(info, 0, sizeof(*info));
>
> A quick fix may be removing the TX control's sta pointer, since IMHO
> it's rarely used for now (the only place that I found was a function
> assigning values to it).
>
> It has been working well for me so far, but please let me know if
> there're better solutions. Thanks!
>
> Best regards,
> Gao Lei

Thanks, what kernel is this against BTW? Just so you know we should be
able to bring down compat-wireless down to 2.6.21 and maybe even
further now that we no longer are using the master netdev, which used
the multiqueue support added as of 2.6.27. Last I checked
compat-wireless now compiles on 2.6.25, but I never actually tried
loading it as I'm on ext4. So if you are on 2.6.25 or 2.6.26 you may
want to try out compat-wireless directly and see if to works. If you
are on 2.6.21..2.6.24 you can try adding backport support. I've added
a few files already for older kernel support based on our old
compat-wireless-old effort, so only the new stuff that mac80211 makes
use of should require backporting.

  Luis
