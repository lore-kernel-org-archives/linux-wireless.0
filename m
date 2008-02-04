Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:40992 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754511AbYBDSkb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 13:40:31 -0500
Message-ID: <47A75BF5.90101@openwrt.org> (sfid-20080204_184035_094159_BDAC431E)
Date: Mon, 04 Feb 2008 19:39:49 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Tomas Winkler <tomasw@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: add rate to ieee80211_tx_status
References: <12020697053277-git-send-email-tomas.winkler@intel.com>	 <1ba2fa240802040330o5b9ffb2dk32b28f7f959e49f4@mail.gmail.com>	 <5358276387473684738@unknownmsgid>	 <1ba2fa240802040357vf517e6as374540e28dd1ab56@mail.gmail.com>	 <47A718CF.50303@openwrt.org> <-5971017268625562167@unknownmsgid>	 <1ba2fa240802040621h2c0e9fe6yb5d84d24513aedf4@mail.gmail.com>	 <-7767648866191425885@unknownmsgid>	 <1ba2fa240802040713k56fdf22fp8ab15924bbebe88@mail.gmail.com>	 <47A72E13.8070305@openwrt.org> <1ba2fa240802041036v2b311eb4vcced7a9f1e2aa6a0@mail.gmail.com>
In-Reply-To: <1ba2fa240802041036v2b311eb4vcced7a9f1e2aa6a0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler wrote:
> Will this work work you?
> 
> ieee80211_tx_ratectrl {
>   u32 bitrate ( or pointer to ieee80211_rate I prefer no)
>   u32 flags
>   u32 retry_count
> }
> 
> ieee80211_tx_status {
>     ieee80211_tx_ratectrl  retry_count[ X]  / * X >= 4 */
> }
I guess that would work, but shouln't the array below be dynamic based on
what the driver can do? Many drivers can only work with one or two rates, IMHO.

- Felix
