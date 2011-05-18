Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37863 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab1ERWnQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 18:43:16 -0400
Subject: Re: [PATCH] mac80211: fix and simplify mesh locking
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <BANLkTikyymbnXHANmB3N0ecJWdkY9xCG=Q@mail.gmail.com> (sfid-20110518_010612_404185_4EA4ADF2)
References: <1305363652.3437.8.camel@jlt3.sipsolutions.net>
	 <1305364803.3437.10.camel@jlt3.sipsolutions.net>
	 <BANLkTikyymbnXHANmB3N0ecJWdkY9xCG=Q@mail.gmail.com>
	 (sfid-20110518_010612_404185_4EA4ADF2)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 May 2011 15:45:52 -0700
Message-ID: <1305758752.8827.1.camel@jlt3.sipsolutions.net> (sfid-20110519_004319_900507_0C22AE4D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-05-17 at 16:05 -0700, Javier Cardona wrote:

> I'm seeing this after trying your patch, probably because the
> allocations mesh_table_alloc() can block.  In the past I had tried to
> allocate the table before entering the critical section.  If that is
> not possible for the race condition you mention,  then I guess we'll
> have to make those allocations GFP_ATOMIC?

Err, now I'm confused, how could the code have done non-atomic
allocations while under rcu_read_lock()? I guess there was just no
verification there?

johannes

