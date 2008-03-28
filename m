Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38909 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753919AbYC1GjM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2008 02:39:12 -0400
Date: Thu, 27 Mar 2008 23:38:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Luis Carlos Cobo <luisca@cozybit.com>
Subject: Re: [PATCH 13/18] mac80211: mesh statistics and config through
 debugfs
Message-Id: <20080327233816.f6cb207e.akpm@linux-foundation.org> (sfid-20080328_063918_018308_8CA3DA72)
In-Reply-To: <20080223142015.478371000@sipsolutions.net>
References: <20080223141703.194775000@sipsolutions.net>
	<20080223142015.478371000@sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 23 Feb 2008 15:17:16 +0100 Johannes Berg <johannes@sipsolutions.net> wrote:

> 
> This patch contains the debugfs code for mesh statistics and configuration
> parameters. Please note that generic support for r/w debugfs attributes has been
> added.


Would it be OK if we do this?

From: Andrew Morton <akpm@linux-foundation.org>

This bool causes my gcc-4.1.0 alpha cross compiler to go into an infinite
loop.  Switching it to u8 works around that.

Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>
Cc: Luis Carlos Cobo <luisca@cozybit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/debugfs_netdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/mac80211/debugfs_netdev.c~net-mac80211-debugfs_netdevc-use-of-bool-triggers-a-gcc-bug net/mac80211/debugfs_netdev.c
--- a/net/mac80211/debugfs_netdev.c~net-mac80211-debugfs_netdevc-use-of-bool-triggers-a-gcc-bug
+++ a/net/mac80211/debugfs_netdev.c
@@ -222,7 +222,7 @@ IEEE80211_IF_WFILE(dot11MeshConfirmTimeo
 IEEE80211_IF_WFILE(dot11MeshHoldingTimeout,
 		u.sta.mshcfg.dot11MeshHoldingTimeout, DEC, u16);
 IEEE80211_IF_WFILE(dot11MeshTTL, u.sta.mshcfg.dot11MeshTTL, DEC, u8);
-IEEE80211_IF_WFILE(auto_open_plinks, u.sta.mshcfg.auto_open_plinks, DEC, bool);
+IEEE80211_IF_WFILE(auto_open_plinks, u.sta.mshcfg.auto_open_plinks, DEC, u8);
 IEEE80211_IF_WFILE(dot11MeshMaxPeerLinks,
 		u.sta.mshcfg.dot11MeshMaxPeerLinks, DEC, u16);
 IEEE80211_IF_WFILE(dot11MeshHWMPactivePathTimeout,
_


quite a few people are (hopefully) using the alpha cross-compiler from
http://userweb.kernel.org/~akpm/cross-compilers/, and this is rather an
inconvenience.

