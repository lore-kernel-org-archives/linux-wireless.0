Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45744 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab3AIR3Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 12:29:24 -0500
Message-ID: <1357752583.9757.17.camel@jlt4.sipsolutions.net> (sfid-20130109_182928_712676_A55E4120)
Subject: Re: [PATCH] mac80211: fix delayed ADDBA response
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: Victor Goldenshtein <victorg@ti.com>,
	linux-wireless@vger.kernel.org
Date: Wed, 09 Jan 2013 18:29:43 +0100
In-Reply-To: <CA+XVXfc+zyLybv9bush3B-Ax65HNTeKOt-FAzT281gQytr3ABA@mail.gmail.com> (sfid-20130109_182521_008336_FEAA5EFA)
References: <1357654597-8493-1-git-send-email-victorg@ti.com>
	 <1357735100.9757.9.camel@jlt4.sipsolutions.net> <50ED94F7.9000709@ti.com>
	 <1357749133.9757.16.camel@jlt4.sipsolutions.net>
	 <CA+XVXfc+zyLybv9bush3B-Ax65HNTeKOt-FAzT281gQytr3ABA@mail.gmail.com>
	 (sfid-20130109_182521_008336_FEAA5EFA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-09 at 19:25 +0200, Arik Nemtsov wrote:

> This is just a speed optimization for BA session management, so I'm
> pretty sure the above was not tested.
> 
> Maybe we can make the "if" stricter and only allow it to pass if it's
> hw_scanning and mgmt->u.action.category == WLAN_CATEGORY_BACK ? Would
> that make sense?

Yeah that's the other option -- making the processing loop more
selective. That's more complex, but should work better.

johannes

