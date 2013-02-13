Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50625 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438Ab3BMJaV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 04:30:21 -0500
Message-ID: <1360747816.8868.7.camel@jlt4.sipsolutions.net> (sfid-20130213_103030_852044_FF95066B)
Subject: Re: [RFCv4 2/2] mac80211: free ps->bc_buf skbs on vlan device stop
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Braun <michael-dev@fami-braun.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	projekt-wlan@fem.tu-ilmenau.de
Date: Wed, 13 Feb 2013 10:30:16 +0100
In-Reply-To: <1360695107-5721-3-git-send-email-michael-dev@fami-braun.de> (sfid-20130212_200235_648904_98A270D2)
References: <1360695107-5721-1-git-send-email-michael-dev@fami-braun.de>
	 <1360695107-5721-3-git-send-email-michael-dev@fami-braun.de>
	 (sfid-20130212_200235_648904_98A270D2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-02-12 at 19:51 +0100, Michael Braun wrote:
> When the vlan device is removed, ps->bc_buf processing can no longer
> send its frames.
> 
> Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
> ---
> V4: Add this patch. Does it need locks? Which?

Yes, the bc_buf has a spinlock itself, which we never use because we
never walk the queue (we use skb_dequeue() which has locking built-in)

Also this patch needs to be the first, otherwise during bisect the
problem might show up.

johannes

