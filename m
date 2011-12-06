Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56089 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab1LFHPE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Dec 2011 02:15:04 -0500
Received: by iakc1 with SMTP id c1so3281217iak.19
        for <linux-wireless@vger.kernel.org>; Mon, 05 Dec 2011 23:15:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1323102012.4051.38.camel@jlt3.sipsolutions.net>
References: <1323102012.4051.38.camel@jlt3.sipsolutions.net>
Date: Tue, 6 Dec 2011 09:15:04 +0200
Message-ID: <CAB3XZEdk73G-1tfCOPUGDH5jVO7NZ_Wh5ObDWi7EJSZRSeSa9g@mail.gmail.com> (sfid-20111206_081510_685435_CFEDA995)
Subject: Re: [PATCH] mac80211: accept public action frames with mismatched BSSID
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Arik Nemtsov <anamtsov@gmail.com>, Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 5, 2011 at 6:20 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Arik's patch "mac80211: allow action frames with unknown
> BSSID in GO mode" allowed any action frames in P2P mode
> to go through, but only to cooked monitor interfaces as
> the IEEE80211_RX_RA_MATCH was still cleared. As a result
> my no-monitor patches broke invitation responses.
>
> Instead of allowing any action frames in P2P GO mode to
> go through with a wrong BSSID like that patch did, allow
> all public action frames. They will never be processed
> by mac80211, but can be reported via nl80211 then.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
[...]

> +static inline bool ieee80211_is_public_action(struct ieee80211_hdr *hdr,
> +                                             size_t len)
> +{
> +       struct ieee80211_mgmt *mgmt = (void *)hdr;
> +
> +       if (len < 25)
> +               return false;

maybe use offsetof() to make clearer?

Eliad.
