Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:33326 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215Ab1CAVyW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 16:54:22 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2011 13:54:01 -0800
Date: Tue, 1 Mar 2011 13:54:12 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"nbd@openwrt.org" <nbd@openwrt.org>,
	"dubowoj@neratec.com" <dubowoj@neratec.com>,
	"zefir.kurtisi@neratec.com" <zefir.kurtisi@neratec.com>,
	"simon.wunderlich@saxnet.de" <simon.wunderlich@saxnet.de>
Subject: Re: [PATCH 2/9] [{mac|nl}80211] Add 2 new radar channel flags
Message-ID: <20110301215412.GD6835@tux>
References: <201102281740.37036.bernhard.schmidt@saxnet.de>
 <201102281747.06564.bernhard.schmidt@saxnet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <201102281747.06564.bernhard.schmidt@saxnet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 28, 2011 at 08:47:06AM -0800, Bernhard Schmidt wrote:
> DFS introduces 2 new flags a channel requiring radar detection
> might take. The interference flag indicates that interference was
> detected either during CAC or in-service monitoring and the
> channel is not to be used for the NOP period. The clear flag
> indicates that during a full CAC no interference was detected and
> it is allowed to open a BSS on that channel. The case were both
> flags are set is used to indicate that interference has been
> detected and we are in progress of closing on that channel.

What does closing mean?

> Signed-off-by: Bernhard Schmidt <bernhard.schmidt@saxnet.de>

> ---
>  include/linux/nl80211.h |    6 ++++++
>  include/net/cfg80211.h  |   18 ++++++++++++------
>  net/mac80211/cfg.c      |    6 ++++++
>  net/mac80211/tx.c       |    6 ++++--
>  net/wireless/nl80211.c  |    4 ++++
>  5 files changed, 32 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> index e3c9ec7..2282f56 100644
> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -1371,6 +1371,10 @@ enum nl80211_band_attr {
>   *	(100 * dBm).
>   * @NL80211_FREQUENCY_ATTR_MAX: highest frequency attribute number
>   *	currently defined
> + * @NL80211_FREQUENCY_ATTR_RADAR_CLEAR: during a full CAC no interference has
> + *	been detected.

Why do you need a flag for clear, can you simply count on the
lack of the flag as the "clear" state?

  Luis
