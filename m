Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49084 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab2KHMmq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2012 07:42:46 -0500
Message-ID: <1352378602.11421.4.camel@jlt4.sipsolutions.net> (sfid-20121108_134300_307000_E8AB8C41)
Subject: Re: [PATCH] mac80211: clear lower drv private data on iface removal
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 08 Nov 2012 13:43:22 +0100
In-Reply-To: <1352378241-31906-1-git-send-email-arik@wizery.com> (sfid-20121108_133740_044315_4BAB0F14)
References: <1352378241-31906-1-git-send-email-arik@wizery.com>
	 (sfid-20121108_133740_044315_4BAB0F14)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-11-08 at 14:37 +0200, Arik Nemtsov wrote:
> The lower driver might rely on getting zeroed per-vif private memory
> when an interface is added. Resetting the memory on removal avoids
> adverse affects during recovery, where the interface is added without
> being removed.

However, it means that data isn't stable across suspend/resume, which
could be desirable to the driver as it may want to have the same
configuration after resuming.

I think we should therefore leave this to the driver, it's obviously
easily implemented as the last step of the driver's ->remove_interface()

johannes

