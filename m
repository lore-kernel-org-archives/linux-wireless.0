Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42667 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab0GZO1a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jul 2010 10:27:30 -0400
Subject: Re: [PATCH] mac80211: simplify key locking
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20100726142058.GA7324@jm.kir.nu>
References: <1275380359.3621.17.camel@jlt3.sipsolutions.net>
	 <20100724053301.GA6773@jm.kir.nu>
	 <1279962385.8223.2.camel@jlt3.sipsolutions.net>
	 <20100726013953.GA29386@jm.kir.nu>
	 <1280130178.3693.1.camel@jlt3.sipsolutions.net>
	 <20100726142058.GA7324@jm.kir.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Jul 2010 16:27:27 +0200
Message-ID: <1280154447.3693.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-07-26 at 07:20 -0700, Jouni Malinen wrote:

> Well, the latter one may indeed do that since debugfs_remove_recursive()
> survives NULL pointer. However, the former one does not.
> ieee80211_key_disable_hw_accel() has a key->local dereference and it
> oopses without the "if (key->local)" part here (before checking whether
> the key is uploaded to hardware). I started first making that handle
> unlinked keys, but since this gets called before
> ieee80211_key_enable_hw_accel() in the problem case, it looked more
> logical to fix the caller not to get to the disable function in the
> first place.

Oh, indeed, that comes before the check. I agree then, this patch seems
like the best fix.

johannes

