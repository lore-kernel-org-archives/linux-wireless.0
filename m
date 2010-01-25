Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:33360 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751572Ab0AYSfv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 13:35:51 -0500
Date: Mon, 25 Jan 2010 10:35:43 -0800
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: wey-yi.w.guy@intel.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 1/1] mac80211: tell driver when dtim change detected
Message-ID: <20100125183543.GB19528@jm.kir.nu>
References: <1264109996-15995-1-git-send-email-wey-yi.w.guy@intel.com>
 <1264186981.2593.10.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1264186981.2593.10.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 22, 2010 at 08:03:01PM +0100, Johannes Berg wrote:
> The other solution I see is that we add a new step before or after the
> direct probe step, which would just be "wait for a beacon". This would
> ensure we have both probe and beacon information always ready. It would
> also ensure we have both probe and beacon info for our new userspace
> reporting of that.

I'm somewhat concerned about this as an unconditional change for our
association process due to the extra latency it adds. At minimum, I
would like to see a driver flag that can be used to indicate that such
behavior is really required and skip the extra wait if the driver does
not need the Beacon frame before association.

For most cases, I would also assume it should be possible to update the
PS settings after having received the first Beacon frame after
association, but if that is not enough, allowing the driver to request
mac80211 to wait with association sounds reasonable. I just don't want
to see additional 50 msec or so (or much worse if the AP is configured
with insanely long beacon interval) delay popping up with every
association by default..

-- 
Jouni Malinen                                            PGP id EFC895FA
