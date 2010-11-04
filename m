Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44095 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab0KDUru (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 16:47:50 -0400
Subject: Re: [RFC 03/15] nl80211: alloc and free the periodic_req data
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1288612336-2830-4-git-send-email-luciano.coelho@nokia.com>
References: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
	 <1288612336-2830-4-git-send-email-luciano.coelho@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 11:43:16 -0400
Message-ID: <1288885396.3659.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-11-01 at 13:52 +0200, Luciano Coelho wrote:

> +	/*
> +	 * FIXME: Can this stay here? How will the auto-complete and other
> +	 * cleanup cases work?
> +	 */
> +	kfree(rdev->periodic_req);
> +	rdev->periodic_req = NULL;

No ... you want a new function that you call here, and also call the
stop into the device at netdev down from the notifier in core.c.

johannes

