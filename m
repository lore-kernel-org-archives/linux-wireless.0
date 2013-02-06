Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52771 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758252Ab3BFVbi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 16:31:38 -0500
Message-ID: <1360186322.7910.76.camel@jlt4.sipsolutions.net> (sfid-20130206_223157_371001_6B8BBDFB)
Subject: Re: [PATCH 0/4] Add support for off-channel powersave state in
 mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org,
	Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	brcm80211-dev-list@broadcom.com
Date: Wed, 06 Feb 2013 22:32:02 +0100
In-Reply-To: <1360184478-31481-1-git-send-email-seth.forshee@canonical.com>
References: <1360184478-31481-1-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-06 at 15:01 -0600, Seth Forshee wrote:
> Hi Johannes,
> 
> As promised, here are the patches which add the off-channel powesave
> state. At a high level, the changes are:
> 
>  * Expand the PS configuration flag to be 2 bits and add helper
>    functions for reading and setting the modes
>  * Change the terminology around PS states, i.e. disabled -> awake and
>    enabled -> doze
>  * Add the off-channel PS state and put it to use
>  * Minor driver updates based on these changes
>  * Update brcmsmac to utilize the off-channel PS state

That's a lot of driver changes ... :)

I've been trying to disentangle the mess a bit. It looks like I was
completely wrong about wl1251, it has HW scan so we don't care about its
weird PS behaviour (1).

That leaves us with a few different drivers:
 * iwlegacy -- has PS support but not NULLFUNC_STACK, so generates a
   wakeup to the AP when we want to go scan ...
 * drivers like iwlwifi/wl12xx have HW scan and don't set NULLFUNC_STACK
 * drivers like ath5k/9k/... have all SW but set NULLFUNC_STACK
 * drivers that just don't have powersave

So I guess iwlegacy is kinda the weird case and not wl1251 ... Oh well.

So for those that have HW scan we just don't have to worry about all of
this, since they never run the scan code :-)

Ok now I forgot where I was going with this ... oops. I'll look at the
code and patches some more.

johannes

(1) let's leave aside remain-on-channel for now, I think we should
probably go and require that drivers set a "I support this" flag, since
it is otherwise almost certain to not work ... it also only matters for
P2P and 11u, so no big deal for old drivers


