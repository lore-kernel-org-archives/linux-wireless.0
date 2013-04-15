Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49667 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab3DONoi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 09:44:38 -0400
Message-ID: <1366033473.8361.26.camel@jlt4.sipsolutions.net> (sfid-20130415_154442_413488_F5D72785)
Subject: Re: [PATCH 3/5] mac80211: improve the rate control API
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 15 Apr 2013 15:44:33 +0200
In-Reply-To: <1365890626-86895-3-git-send-email-nbd@openwrt.org>
References: <1365890626-86895-1-git-send-email-nbd@openwrt.org>
	 <1365890626-86895-2-git-send-email-nbd@openwrt.org>
	 <1365890626-86895-3-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-04-14 at 00:03 +0200, Felix Fietkau wrote:

> +EXPORT_SYMBOL(rate_control_set_rates);

I don't think that needs to be exported (at least not now)?

I suspect that the answer to my question in patch 2 lies here, if the
rate control updates the table then would it not just update the table
when the protection mechanism needs to be changed? There should be
triggers for that, rather than having to check the "use_cts" variables
on every packet, and if they aren't complete that should be fixed?

johannes

