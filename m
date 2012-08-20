Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36281 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab2HTLUf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2012 07:20:35 -0400
Message-ID: <1345461629.4459.10.camel@jlt3.sipsolutions.net> (sfid-20120820_132039_184862_8F50EC13)
Subject: Re: [PATCH v1] cfg80211: Support for 4-way handshake offloading for
 WPA2-Personal
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Date: Mon, 20 Aug 2012 13:20:29 +0200
In-Reply-To: <1343907187-6686-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1343907187-6686-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1343907187-6686-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-08-02 at 14:33 +0300, Vladimir Kondratiev wrote:

> + * @NL80211_ATTR_4WAY_HANDSHAKE_OFFLOAD_STA: This is a flag that indicates to
> + *	WPA supplicant that 4-way handshake has been offloaded to the firmware
> + *	in the STA mode.
> + *	In this case, WPA supplicant will provide driver with PSK for
> + *	connect()
> + *
> + * @NL80211_ATTR_4WAY_HANDSHAKE_OFFLOAD_AP: This is a flag that indicates to
> + *	WPA supplicant that 4-way handshake has been offloaded to the firmware
> + *	in the AP mode.
> + *	In this case, WPA supplicant will provide driver with PSK for
> + *	start_ap()

I think you should use the nl80211 driver flags, not extra attributes
here.

>  struct cfg80211_connect_params {
>  	struct ieee80211_channel *channel;
> @@ -1322,6 +1325,7 @@ struct cfg80211_connect_params {
>  	int bg_scan_period;
>  	struct ieee80211_ht_cap ht_capa;
>  	struct ieee80211_ht_cap ht_capa_mask;
> +	const u8 *psk;
>  };

And the descriptions (and flag checking!) should make it clear that it
is only supported with the connect() API, not with the auth/assoc APIs.

 
> + * @WIPHY_FLAG_4WAY_HANDSHAKE_OFFLOAD: Device supports 4-way handshake offload.

Use nl80211 flag directly. Also, docs are wrong:

> +	WIPHY_FLAG_4WAY_HANDSHAKE_OFFLOAD_STA	= BIT(22),
> +	WIPHY_FLAG_4WAY_HANDSHAKE_OFFLOAD_AP	= BIT(23),


Please also add validation that these flags are specified only when the
correct APIs (connect/start_ap) are supported.

johannes

