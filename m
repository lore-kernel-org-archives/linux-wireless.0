Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37024 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757116Ab0LAUvt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 15:51:49 -0500
Subject: Re: [PATCH/RFC] mac80211: use configured mesh TTL
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTi=GS7vjH07CJmN05Uc6jazNjjY2Pt6yGqwAYLmH@mail.gmail.com>
References: <1291168735-3423-1-git-send-email-javier@cozybit.com>
	 <1291184383.4199.4.camel@jlt3.sipsolutions.net>
	 <AANLkTikMex0A91Qy=5EwPAEfVWKDVz4_mneWnCvy3soR@mail.gmail.com>
	 <1291229642.4199.11.camel@jlt3.sipsolutions.net>
	 <1291232151.4199.12.camel@jlt3.sipsolutions.net>
	 <AANLkTimgfRvqp=-CDU=G8o-ZfD4fVbf3j-AdXCVtoM6c@mail.gmail.com>
	 <1291235337.4199.14.camel@jlt3.sipsolutions.net>
	 <AANLkTi=GS7vjH07CJmN05Uc6jazNjjY2Pt6yGqwAYLmH@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 21:51:47 +0100
Message-ID: <1291236707.4199.17.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-12-01 at 12:44 -0800, Javier Cardona wrote:

> Path selection frames use a different TTL, which was recently renamed
> from 'TTL' to 'Element TTL' in the 11s draft:
> 
> element time to live (Element TTL): An integer number that is used to
> limit the number of hops an
> HWMP element may be processed and propagated. Note that this Element
> TTL is different from the
> Mesh TTL in the Mesh Control (see 7.1.3.6.3 (Mesh Control field)).
> 
> So no, I would not change this.

Ok, can you look at v2 though please -- does this hold for all four
places, or is the one in mesh_path_error_tx really a bug?

Should we rename the constant then, to indicate the difference? Maybe
something like MESH_DEFAULT_ELEMENT_TTL even if that's a bit verbose?

johannes

