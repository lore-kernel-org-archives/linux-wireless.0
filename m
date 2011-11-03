Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51051 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab1KCIhs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 04:37:48 -0400
Subject: Re: [PATCH v3 1/3] mac80211: Support forcing station to disable HT
 (802.11n).
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1320299722-30113-1-git-send-email-greearb@candelatech.com> (sfid-20111103_065534_192366_EF6ABFB6)
References: <1320299722-30113-1-git-send-email-greearb@candelatech.com>
	 (sfid-20111103_065534_192366_EF6ABFB6)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Nov 2011 09:37:45 +0100
Message-ID: <1320309465.3950.14.camel@jlt3.sipsolutions.net> (sfid-20111103_093753_210769_DC31D0B7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-02 at 22:55 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This allows a user to configure a wifi station interface
> to disable the HT features, even if the AP and NIC supports it.

I like this version much better. Some nitpicks:


> +#define ASSOC_REQ_DISABLE_HT	(1<<0) /* Disable HT (802.11n) */

You could use an enum to use kernel-doc notation here.

> @@ -1046,6 +1048,7 @@ struct cfg80211_auth_request {
>   * @use_mfp: Use management frame protection (IEEE 802.11w) in this association
>   * @crypto: crypto settings
>   * @prev_bssid: previous BSSID, if not %NULL use reassociate frame
> + * @flags:  See ASSOC_REQ_* flags above.

and then say "See &enum cfg80211_assoc_req_flags" or so should even
create the correct link in kernel-doc output.

> @@ -1053,6 +1056,7 @@ struct cfg80211_assoc_request {
>  	size_t ie_len;
>  	struct cfg80211_crypto_settings crypto;
>  	bool use_mfp;
> +	u32 flags;

Seems like it might be good for use_mfp to become a flag? Anyway,
internal APIs are easy to change.

> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c

I'd rather split this up into cfg80211/mac80211. In fact, maybe
splitting it into one cfg80211 and one mac80211 patch, instead of three
different patches that span both might be worthwhile?

johannes

