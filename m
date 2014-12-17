Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36150 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbaLQKta (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 05:49:30 -0500
Message-ID: <1418813359.2135.7.camel@sipsolutions.net> (sfid-20141217_114933_396855_B90F48A0)
Subject: Re: [PATCH v5] mac80211: keep sending peer candidate events while
 in listen state
From: Johannes Berg <johannes@sipsolutions.net>
To: "Nishikawa, Kenzoh" <Kenzoh.Nishikawa@jp.sony.com>
Cc: "'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>,
	"'devel@lists.open80211s.org'" <devel@lists.open80211s.org>,
	"'Bob Copeland (me@bobcopeland.com)'" <me@bobcopeland.com>,
	"'Thomas Pedersen (thomas@noack.us)'" <thomas@noack.us>
Date: Wed, 17 Dec 2014 11:49:19 +0100
In-Reply-To: <2EB4F5C65A3B8E4E92660930F4EF6B5B07AB81@JPYOKXMS113.jp.sony.com>
References: <2EB4F5C65A3B8E4E92660930F4EF6B5B07AB81@JPYOKXMS113.jp.sony.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-12-16 at 01:41 +0000, Nishikawa, Kenzoh wrote:
> Instead of sending peer candidate events just once, send them as long as the peer remains in the LISTEN state in the peering state machine, when userspace is implementing the peering manager.
> Userspace may silence the events from a peer by progressing the state machine or by setting the link state to BLOCKED.
> 
> Fixes the problem that a mesh peering process won't be fired again after the previous first peering trial fails due to like air propagation error if the peering is managed by user space such as wpa_supplicant.
> 
> This patch works with another patch for wpa_supplicant described here which fires a peering process again triggered by the notice from kernel.
> http://lists.shmoo.com/pipermail/hostap/2014-November/031235.html

Applied, but please try to send patches with line-broken commit
messages.

johannes

