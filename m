Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44831 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab1ELI2P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 04:28:15 -0400
Subject: Re: [PATCH] cfg80211: make stripping of 802.11 header optional
 from AMSDU
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>
In-Reply-To: <1305168432-15569-2-git-send-email-bzhao@marvell.com>
References: <1305168432-15569-1-git-send-email-bzhao@marvell.com>
	 <1305168432-15569-2-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 10:28:13 +0200
Message-ID: <1305188893.3461.8.camel@jlt3.sipsolutions.net> (sfid-20110512_102819_887416_67368964)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-05-11 at 19:47 -0700, Bing Zhao wrote:
> From: Yogesh Ashok Powar <yogeshp@marvell.com>
> 
> Currently the devices that have already stripped IEEE 802.11
> header from the AMSDU SKB can not use ieee80211_amsdu_to_8023s
> routine. This patch enhances ieee80211_amsdu_to_8023s() API by
> changing mandatory removing of IEEE 802.11 header from AMSDU
> to optional.

Nice.

> @@ -2173,10 +2173,13 @@ int ieee80211_data_from_8023(struct sk_buff *skb, const u8 *addr,
>   * @addr: The device MAC address.
>   * @iftype: The device interface type.
>   * @extra_headroom: The hardware extra headroom for SKBs in the @list.
> + * @stripped_80211_header: Set it true if SKB is without IEEE 802.11
> + *	header.

I think I'd prefer this be the other way around though, like
"has_80211_header" (or so), that seems more natural here and in the
code? Not that it matters much.

johannes

