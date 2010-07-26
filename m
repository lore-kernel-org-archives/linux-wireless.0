Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:42190 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753418Ab0GZOV0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jul 2010 10:21:26 -0400
Date: Mon, 26 Jul 2010 07:20:58 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: simplify key locking
Message-ID: <20100726142058.GA7324@jm.kir.nu>
References: <1275380359.3621.17.camel@jlt3.sipsolutions.net>
 <20100724053301.GA6773@jm.kir.nu>
 <1279962385.8223.2.camel@jlt3.sipsolutions.net>
 <20100726013953.GA29386@jm.kir.nu>
 <1280130178.3693.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1280130178.3693.1.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 26, 2010 at 09:42:58AM +0200, Johannes Berg wrote:
> On Sun, 2010-07-25 at 18:39 -0700, Jouni Malinen wrote:
> > -	ieee80211_key_disable_hw_accel(key);
> > +	if (key->local)
> > +		ieee80211_key_disable_hw_accel(key);
> 
>  
> > -	ieee80211_debugfs_key_remove(key);
> > +	if (key->local)
> > +		ieee80211_debugfs_key_remove(key);
> 
> These might look odd, but they're fine on a key that hasn't been used
> since it couldn't have been uploaded to hardware, or put into debugfs,
> so they'll just exit right away.

Well, the latter one may indeed do that since debugfs_remove_recursive()
survives NULL pointer. However, the former one does not.
ieee80211_key_disable_hw_accel() has a key->local dereference and it
oopses without the "if (key->local)" part here (before checking whether
the key is uploaded to hardware). I started first making that handle
unlinked keys, but since this gets called before
ieee80211_key_enable_hw_accel() in the problem case, it looked more
logical to fix the caller not to get to the disable function in the
first place.

-- 
Jouni Malinen                                            PGP id EFC895FA
