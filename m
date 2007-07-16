Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:40278 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762392AbXGPQ4k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jul 2007 12:56:40 -0400
Date: Mon, 16 Jul 2007 18:56:16 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Daniel Drake <dsd@gentoo.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] mac80211: STA reassociation improvements
Message-ID: <20070716185616.58030016@griffin.suse.cz>
In-Reply-To: <20070715140251.B4F6B7B409F@zog.reactivated.net>
References: <20070715140251.B4F6B7B409F@zog.reactivated.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[removed netdev, no reason for sending this there]

On Sun, 15 Jul 2007 15:02:51 +0100 (BST), Daniel Drake wrote:
> My cheapy D-Link AP behaves strangely w.r.t reassociations.
> 
> The following sequence of commands causes me to lose association and to be
> unable to regain it:
> 
> 	ifconfig eth8 down
> 	ifconfig eth8 up
> 	iwconfig eth8 essid <x>
> 
> This is because mac80211 tries to reassociate, rather than just associate.
> My AP replies with an association response (not a reassociation response...)
> denying the association with code 12: "Association denied due to reason
> outside the scope of this standard"
> 
> mac80211 tries this reassociation another 4 times or so before finally giving
> up.
> 
> I see 2 problems here:
>  1. bringing the interface down and up again should be resetting interface state
>     i.e. after the interface is brought down, it should have no memory of if or
>          where it was previously associated
>  2. after the first reassociation fails, mac80211 should fall back to
>     standard association for the next attempt
> 
> Signed-off-by: Daniel Drake <dsd@gentoo.org>

Acked-by: Jiri Benc <jbenc@suse.cz>


-- 
Jiri Benc
SUSE Labs
