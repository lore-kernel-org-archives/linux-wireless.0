Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49112 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751939AbcI0MgY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Sep 2016 08:36:24 -0400
Message-ID: <1474979775.5141.27.camel@sipsolutions.net> (sfid-20160927_143628_365933_C2CDEBDE)
Subject: Re: [PATCH] cfg80211: add key management offload feature
From: Johannes Berg <johannes@sipsolutions.net>
To: Amitkumar Karwar <akarwar@marvell.com>,
        linux-wireless@vger.kernel.org,
        hostap <hostap@lists.infradead.org>, Jouni Malinen <j@w1.fi>,
        Ilan Peer <ilan.peer@intel.com>
Cc: yangzy@marvell.com, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        lihz <lihz@marvell.com>
Date: Tue, 27 Sep 2016 14:36:15 +0200
In-Reply-To: <1474973796-1873-1-git-send-email-akarwar@marvell.com> (sfid-20160927_125737_815734_5AE7ADB1)
References: <1474973796-1873-1-git-send-email-akarwar@marvell.com>
         (sfid-20160927_125737_815734_5AE7ADB1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>  #define WLAN_CIPHER_SUITE_SMS4		0x00147201
> +#define WLAN_CIPHER_SUITE_PMK           0x00147202
> +#define WLAN_CIPHER_SUITE_PMK_R0        0x00147203
> +#define WLAN_CIPHER_SUITE_PMK_R0_NAME   0x00147204

Err, what? No, things can't work that way. This is the Chinese
company's OUI, you can't just assign it to PMK stuff.

> + * @NL80211_ATTR_AUTHORIZED: flag attribute, if set indicates that the
> + *      connection is authorized.
> + *
>   * @NUM_NL80211_ATTR: total number of nl80211_attrs available
>   * @NL80211_ATTR_MAX: highest attribute number currently defined
>   * @__NL80211_ATTR_AFTER_LAST: internal use
> @@ -2267,6 +2270,8 @@ enum nl80211_attrs {
>  
>  	NL80211_ATTR_MESH_PEER_AID,
>  
> +	NL80211_ATTR_AUTHORIZED,

This already exists, no?

NL80211_STA_FLAG_AUTHORIZED should be more or less equivalent, if you
do it per station (or just for the AP in case of managed connection)

>  	/* add attributes here, update the policy in nl80211.c */
>  
>  	__NL80211_ATTR_AFTER_LAST,
> @@ -3687,6 +3692,9 @@ enum nl80211_key_attributes {
>  	NL80211_KEY_DEFAULT_MGMT,
>  	NL80211_KEY_TYPE,
>  	NL80211_KEY_DEFAULT_TYPES,
> +	NL80211_KEY_REPLAY_CTR,
> +	NL80211_KEY_KCK,
> +	NL80211_KEY_KEK,

I don't think we should conflate the (P)MK and *TK concepts in nl80211,
they're both keys, but they're completely separate in terms of expected
usage.


Ilan and I looked at this, considering 4-way-HS offload after 1X
authentication, and think that the more natural API would be to add all
the necessary data to the PMKSA cache entry. Thus, a PMKSA cache entry
for a device that does 4-way-handshake offloading would include the PMK
(or perhaps MSK?), and for FT it would also including the PMK-R0,
PMKR0Name (and possibly the MDID, or can it be derived?)


However, I'm wondering what exactly the offloads here do. Jouni, could
you also chime in with the QCA (vendor command) design?

In particular, with key management offloaded, it's not clear to me what
exactly the roles of the device and host are here. I'm considering that
the device would handle the 4-way and 2-way handshakes, but then you
wouldn't need the KEK/KCK/ReplayCounter in the host, so there wouldn't
be much point in giving them to it.
But if the device doesn't do that, what exactly *does* it do?


Thanks,
johannes
