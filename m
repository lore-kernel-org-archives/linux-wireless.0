Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:32145 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbYG1NKD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 09:10:03 -0400
Subject: Re: [ath5k-devel] [PATCH 12/12] ath5k: Fix a compilation error
	after reg list update
From: Pavel Roskin <proski@gnu.org>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@gmail.com
In-Reply-To: <40f31dec0807280604m19a8c511nf2568bb7aa357b90@mail.gmail.com>
References: <20080720035221.GL7440@makis> <4885F055.8000304@gmail.com>
	 <40f31dec0807280604m19a8c511nf2568bb7aa357b90@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 09:10:01 -0400
Message-Id: <1217250601.2441.20.camel@dv> (sfid-20080728_151008_549811_00493746)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-07-28 at 16:04 +0300, Nick Kossifidis wrote:

> > Please amend this to the patch 1 to not break bisectability.
> 
> I see your point but this series is meant to be applied as a whole, i
> didn't notice this bug until i tested the code with debugging enabled
> (which is off by default), that's why it's "last minute fix". Is it
> really that much needed to repost the first patch ? I mean the patch
> series works and doesn't introduce any problems...

The reason is that git-bisect divides the number of commits in half and
checks out the middle commit.  That commit make be a broken one.
Hitting one bug while hunting another is not nice.

Besides, nobody wants to apply a known bad patch.

It would be great if you repost fixed patches.  If you are not using
stgit, please try it.  I would make it easy to return to older patches
and change them.  "stg edit -d" even allows editing the patch.

-- 
Regards,
Pavel Roskin
