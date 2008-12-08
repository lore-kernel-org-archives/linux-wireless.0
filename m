Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:33795 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752128AbYLHNPD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 08:15:03 -0500
Date: Mon, 8 Dec 2008 15:14:40 +0200
From: Jouni Malinen <j@w1.fi>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni.Malinen@atheros.com, Luis.Rodriguez@atheros.com,
	johannes@sipsolutions.net, tomas.winkler@intel.com
Subject: Re: [RFC v2] mac80211: fix HT channel selection
Message-ID: <20081208131440.GA7365@jm.kir.nu> (sfid-20081208_141513_953414_5FAA4390)
References: <18748.62215.331271.141163@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <18748.62215.331271.141163@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 08, 2008 at 03:42:23PM +0530, Sujith wrote:

> HT management is done differently for AP and STA modes, unify
> to just the ->config() callback since HT is fundamentally a
> PHY property and cannot be per-BSS.
> 
> Add a new NL80211 attribute to enable/disable HT (NL80211_ATTR_WIPHY_HT).
> NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET now has only the secondary channel
> offsets.

Looks reasonable to me. Please just make sure this gets in before
NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET additions get included in any
official kernel release since otherwise this would change the userspace
API..

-- 
Jouni Malinen                                            PGP id EFC895FA
