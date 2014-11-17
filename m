Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:41800 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbaKQNh3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2014 08:37:29 -0500
Received: by mail-ig0-f169.google.com with SMTP id hl2so2000903igb.0
        for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2014 05:37:28 -0800 (PST)
Date: Mon, 17 Nov 2014 08:34:18 -0500
From: Bob Copeland <me@bobcopeland.com>
To: "Nishikawa, Kenzoh" <Kenzoh.Nishikawa@jp.sony.com>,
	devel@lists.open80211s.org
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] mac80211: Send peering open frame again if beacon
 from listen state peer is received
Message-ID: <20141117133418.GG11482@localhost> (sfid-20141117_143742_486910_05D4D5B4)
References: <2EB4F5C65A3B8E4E92660930F4EF6B5B069684@JPYOKXMS113.jp.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2EB4F5C65A3B8E4E92660930F4EF6B5B069684@JPYOKXMS113.jp.sony.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 17, 2014 at 09:35:42AM +0000, Nishikawa, Kenzoh via Devel wrote:
> Fixes the problem that a mesh peering process won't be fired again 
> after the previous first peering trial fails due to like air propagation error
> if the peering is managed by user space such as wpa_supplicant.
> 
> This patch works with another patch for wpa_supplicant described here
> which fires a peering process again triggered by the notice from kernel.
> http://lists.shmoo.com/pipermail/hostap/2014-November/031235.html

I think this makes sense in principle.  I also checked authsae and it
should handle getting these additional events so no problems with
existing userspace.

However, some comments:

The subject doesn't really match what this does.  I would also describe
the new kernel behavior in the commit log in addition to the motivation.

Maybe something like this:

mac80211: keep sending peer candidate events while in listen state

Instead of sending peer candidate events just once, send them as
long as the peer remains in the LISTEN state in the peering state
machine, when userspace is implementing the peering manager.  Userspace
may silence the events from a peer by progressing the state machine or
by setting the link state to BLOCKED.

Fixes the problem that a mesh peering process won't be fired again
after the previous first peering trial fails due to like air propagation error
if the peering is managed by user space such as wpa_supplicant.

This patch works with another patch for wpa_supplicant described here
which fires a peering process again triggered by the notice from kernel.
http://lists.shmoo.com/pipermail/hostap/2014-November/031235.html

> +		(sdata->u.mesh.user_mpm ||
> +		sdata->u.mesh.security & IEEE80211_MESH_SEC_AUTHED))
> +		cfg80211_notify_new_peer_candidate(sdata->dev, hw_addr,
> +							   elems->ie_start,
> +							   elems->total_len,
> +							   GFP_KERNEL);

>From a cursory glance I think this needs to be GFP_ATOMIC -- don't you get
lockdep warnings?  (If not, make sure CONFIG_PROVE_LOCKING is enabled, and
that you aren't hitting other lockdep warnings prior to this code running.)
This code is in an RCU read critical section as far as I can tell.

-- 
Bob Copeland %% http://bobcopeland.com/
