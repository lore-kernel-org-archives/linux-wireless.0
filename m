Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:60868 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752592Ab0GZBE3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jul 2010 21:04:29 -0400
Date: Sun, 25 Jul 2010 18:04:18 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: simplify key locking
Message-ID: <20100726010418.GA3697@jm.kir.nu>
References: <1275380359.3621.17.camel@jlt3.sipsolutions.net>
 <20100724053301.GA6773@jm.kir.nu>
 <1279962385.8223.2.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1279962385.8223.2.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 24, 2010 at 11:06:25AM +0200, Johannes Berg wrote:
> I removed the comment because the linked vs. not linked handling is a
> bit different now I think ... I don't think we should restore the NULL
> handling as it was before, since __ieee80211_key_free() should be able
> to handle this now.
> 
> The fix should be passing in the local pointer to ieee80211_key_free() I
> guess. Can you try that?

__ieee80211_key_free() handles this, but the function it calls does
not.. ieee80211_key_disable_hw_accel() dereferences key->local before
checking whether the key has been uploaded to hardware (which this key
would not be).. Would you like the local pointer to be passed to
ieee80211_key_disable_hw_accel(), too? Or make __ieee80211_key_destroy()
skip that call if key->local == NULL? Actually, calling
__ieee80211_key_destroy() with not-yet-linked key is somewhat odd from
the debugfs view point, too (ieee80211_debugfs_key_remove() gets called
even when matching _key_add has not happened).

-- 
Jouni Malinen                                            PGP id EFC895FA
