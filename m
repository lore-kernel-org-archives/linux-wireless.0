Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:59877 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756391AbZKREGr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 23:06:47 -0500
Message-ID: <4B0372DC.7010209@openwrt.org>
Date: Wed, 18 Nov 2009 05:06:52 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 1/2] ath9k: properly use the mac80211 rate control api
References: <4B03700F.50309@openwrt.org>
In-Reply-To: <4B03700F.50309@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> This patch changes ath9k to pass proper MCS indexes and flags
> between the RC and the rest of the driver code.
> sc->cur_rate_table remains, as it's used by the RC code internally,
> but the rest of the driver code no longer uses it, so a potential
> new RC for ath9k would not have to update it.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
> - replaces sc->hw usage with common->hw
> - initializes unused tx status rates to -1 for minstrel compatibility
> - split up for easier review
> - tested in ap mode with minstrel against a legacy STA
Sorry, disregard that patch. It doesn't really work when split up this
way, as I still need to adjust the MCS indexes, which is currently done
in the second patch. I'll resend later...

- Felix

