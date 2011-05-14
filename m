Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45840 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab1ENJUI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 May 2011 05:20:08 -0400
Subject: Re: [PATCH] mac80211: fix and simplify mesh locking
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Javier Cardona <javier@cozybit.com>
In-Reply-To: <1305363652.3437.8.camel@jlt3.sipsolutions.net> (sfid-20110514_110059_273421_3D561F0E)
References: <1305363652.3437.8.camel@jlt3.sipsolutions.net>
	 (sfid-20110514_110059_273421_3D561F0E)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 14 May 2011 11:20:03 +0200
Message-ID: <1305364803.3437.10.camel@jlt3.sipsolutions.net> (sfid-20110514_112046_346188_F0B6E7E1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-05-14 at 11:00 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The locking in mesh_{mpath,mpp}_table_grow not only
> has an rcu_read_unlock() missing, it's also racy
> (though really only technically since it's invoked
> from a single function only) since it obtains the
> new size of the table without any locking, so two
> invocations of the function could attempt the same
> resize.

Actually, it _can_ happen, if you have multiple mesh interfaces.

johannes

