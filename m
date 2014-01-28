Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:38517 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbaA1NBy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jan 2014 08:01:54 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Antonio Quartulli <antonio@meshcoding.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	<brcm80211-dev-list@broadcom.com>,
	Antonio Quartulli <antonio@open-mesh.com>,
	Arend van Spriel <arend@broadcom.com>,
	Bing Zhao <bzhao@marvell.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	<libertas-dev@lists.infradead.org>
Subject: Re: [PATCH RESEND mac80211] cfg80211: fix channel configuration in IBSS join
References: <1390913540-2127-1-git-send-email-antonio@meshcoding.com>
Date: Tue, 28 Jan 2014 15:01:47 +0200
In-Reply-To: <1390913540-2127-1-git-send-email-antonio@meshcoding.com>
	(Antonio Quartulli's message of "Tue, 28 Jan 2014 13:52:20 +0100")
Message-ID: <87wqhkgszo.fsf@kamboji.qca.qualcomm.com> (sfid-20140128_140209_396369_D5C8F8D4)
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
>
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
>
> By passing the channel to cfg80211_get_bss() we can solve
> this ambiguity and retrieve/create the correct BSS object.
>
> All the users of cfg80211_ibss_joined() have been changed
> accordingly.
>
> Cc: Kalle Valo <kvalo@qca.qualcomm.com>
> Cc: Arend van Spriel <arend@broadcom.com>
> Cc: Bing Zhao <bzhao@marvell.com>
> Cc: Jussi Kivilinna <jussi.kivilinna@iki.fi>
> Cc: libertas-dev@lists.infradead.org
> Signed-off-by: Antonio Quartulli <antonio@meshcoding.com>
> ---
>
> - Patch is getting resent because I did not CC'd the linux-wireless mailing list in
> my previous attempt. :)

Oh, I missed that. Anyway, in previous version I  commented about
documenting NULL usage. What do you think about that?

-- 
Kalle Valo
