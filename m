Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18478 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaA2PO3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 10:14:29 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Antonio Quartulli <antonio@meshcoding.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	Antonio Quartulli <antonio@open-mesh.com>,
	Arend van Spriel <arend@broadcom.com>,
	Bing Zhao <bzhao@marvell.com>,
	"Jussi Kivilinna" <jussi.kivilinna@iki.fi>,
	<libertas-dev@lists.infradead.org>
Subject: Re: [PATCHv2] cfg80211: fix channel configuration in IBSS join
References: <1391002505-3771-1-git-send-email-antonio@meshcoding.com>
Date: Wed, 29 Jan 2014 17:12:38 +0200
In-Reply-To: <1391002505-3771-1-git-send-email-antonio@meshcoding.com>
	(Antonio Quartulli's message of "Wed, 29 Jan 2014 14:35:05 +0100")
Message-ID: <87eh3q255l.fsf@kamboji.qca.qualcomm.com> (sfid-20140129_161432_343530_8E2293CB)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Antonio Quartulli <antonio@meshcoding.com> writes:

> From: Antonio Quartulli <antonio@open-mesh.com>
>
> When receiving an IBSS_JOINED event select the BSS object
> based on the {bssid, channel} couple rather than the bssid
> only.
> With the current approach if another cell having the same
> BSSID (but using a different channel) exists then cfg80211
> picks up the wrong BSS object.
> The result is a mismatching channel configuration between
> cfg80211 and the driver, that can lead to any sort of
> problem.
>
> The issue can be triggered by having an IBSS sitting on
> given channel and then asking the driver to create a new
> cell using the same BSSID but with a different frequency.
> By passing the channel to cfg80211_get_bss() we can solve
> this ambiguity and retrieve/create the correct BSS object.
> All the users of cfg80211_ibss_joined() have been changed
> accordingly.
>
> Moreover WARN when cfg80211_ibss_joined() gets a NULL
> channel as argument and remove a bogus call of the same
> function in ath6kl (it does not make sense to call
> cfg80211_ibss_joined() with a zero BSSID on ibss-leave).
>
> Cc: Kalle Valo <kvalo@qca.qualcomm.com>
> Cc: Arend van Spriel <arend@broadcom.com>
> Cc: Bing Zhao <bzhao@marvell.com>
> Cc: Jussi Kivilinna <jussi.kivilinna@iki.fi>
> Cc: libertas-dev@lists.infradead.org
> Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>

For the ath6kl part:

Acked-by: Kalle Valo <kvalo@qca.qualcomm.com>

-- 
Kalle Valo
