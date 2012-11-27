Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40211 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab2K0QHC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 11:07:02 -0500
Message-ID: <1354032428.9576.9.camel@jlt4.sipsolutions.net> (sfid-20121127_170706_353206_A1016C0A)
Subject: Re: [PATCH] mac80211: Reject setting masked mac addresses
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Nov 2012 17:07:08 +0100
In-Reply-To: <1354031029-7956-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20121127_164404_462942_B1141D28)
References: <1354031029-7956-1-git-send-email-helmut.schaa@googlemail.com>
	 (sfid-20121127_164404_462942_B1141D28)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-27 at 16:43 +0100, Helmut Schaa wrote:

> +	if (!is_zero_ether_addr(local->hw.wiphy->addr_mask)) {
> +		m = local->hw.wiphy->perm_addr;

I'm not sure I like using perm_addr here. You might actually want to use
a totally different address, but fit all of them into the mask, no?

johannes

