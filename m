Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.fenrir.org.uk ([81.168.115.223]:48459 "EHLO mx.fenrir.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbYCaXFd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 19:05:33 -0400
Date: Mon, 31 Mar 2008 23:00:30 +0100
From: Brian Morrison <bdm@fenrir.org.uk>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cfg80211: add EU regulatory domain
Message-ID: <20080331230030.18da1c21@peterson.fenrir.org.uk> (sfid-20080401_000538_531462_F55C8CDE)
In-Reply-To: <1206997315-15878-1-git-send-email-linville@tuxdriver.com>
References: <1206997315-15878-1-git-send-email-linville@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 31 Mar 2008 17:01:55 -0400
"John W. Linville" <linville@tuxdriver.com> wrote:

> Based on initial footwork from Brian Morrison.
> 
> Cc: Brian Morrison <bdm@fenrir.org.uk>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> Is this worth having?  I'm surprised no one has asked for it until
> recently...
> 
> Are these values correct?  Including the power and gain values?  Does
> anyone know have a link to an authoritative source?
> 
>  net/wireless/reg.c |   16 ++++++++++++++++
>  1 files changed, 16 insertions(+), 0 deletions(-)
> 
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 8cc6037..998ceb6 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -80,6 +80,21 @@ static const struct ieee80211_channel_range ieee80211_JP_channels[] = {
>  				     IEEE80211_CHAN_RADAR),
>  };
>  
> +static const struct ieee80211_channel_range ieee80211_EU_channels[] = {
> +	/* IEEE 802.11b/g, channels 1..13 */
> +	RANGE_PWR(2412, 2472, 27, 6, 0),

This should read:

+	RANGE_PWR(2412, 2472, 20, 0, 0),

The power limit is supposed to be +20dBm in the EU, and it's EIRP so
that includes antenna gain which I've set to 0dB.

For an authoritative document you need http://www.etsi.org but their
site is down just now, so I can't find the document I want.

> +	/* IEEE 802.11a, channel 36*/
> +	RANGE_PWR(5180, 5180, 23, 6, 0),
> +	/* IEEE 802.11a, channel 40*/
> +	RANGE_PWR(5200, 5200, 23, 6, 0),
> +	/* IEEE 802.11a, channel 44*/
> +	RANGE_PWR(5220, 5220, 23, 6, 0),
> +	/* IEEE 802.11a, channels 48..64 */
> +	RANGE_PWR(5240, 5320, 23, 6, 0),
> +	/* IEEE 802.11a, channels 100..140 */
> +	RANGE_PWR(5500, 5700, 23, 6, 0),
> +};
> +
>  #define REGDOM(_code)							\
>  	{								\
>  		.code = __stringify(_code),				\
> @@ -90,6 +105,7 @@ static const struct ieee80211_channel_range ieee80211_JP_channels[] = {
>  static const struct ieee80211_regdomain ieee80211_regdoms[] = {
>  	REGDOM(US),
>  	REGDOM(JP),
> +	REGDOM(EU),
>  };
>  
>  




-- 

Brian Morrison

bdm at fenrir dot org dot uk

   "Arguing with an engineer is like wrestling with a pig in the mud;
    after a while you realize you are muddy and the pig is enjoying it."
    
GnuPG key ID DE32E5C5 - http://wwwkeys.uk.pgp.net/pgpnet/wwwkeys.html
