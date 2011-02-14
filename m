Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33120 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab1BNJ5i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 04:57:38 -0500
Subject: Re: [PATCH 1/5] iwlwifi: Simplify tx queue management
From: Johannes Berg <johannes@sipsolutions.net>
To: "Nathaniel J. Smith" <njs@pobox.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	wey-yi.w.guy@intel.com, ilw@linux.intel.com
In-Reply-To: <1297619803-2832-2-git-send-email-njs@pobox.com>
References: <1297619803-2832-1-git-send-email-njs@pobox.com>
	 <1297619803-2832-2-git-send-email-njs@pobox.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 10:57:33 +0100
Message-ID: <1297677453.3785.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-02-13 at 09:56 -0800, Nathaniel J. Smith wrote:
> Previously, the iwlwifi driver filled its transmit queue until it
> reached a high-water mark, and then stopped until it had fallen to a
> low-water mark. This basic logic makes sense for interrupt mitigation
> -- you might not want to wake up the CPU after every packet, but
> instead wait until a batch of packets has been sent -- except the
> iwlwifi driver doesn't actually do any interrupt mitigation; the CPU
> wakes up after every packet transmitted anyway. So we simplify the
> code to maintain only a single limit on total queue length, and
> whenever we drop below that limit we allow more packets in.
> 
> This patch should have no user-visible effect.

I'm pretty sure the devices (but maybe not 3945) implement interrupt
mitigation at least in some cases. How did you arrive at the conclusion
that "the driver doesn't actually do any interrupt mitigation"?

johannes


