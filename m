Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:57579 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752368Ab0AHNPX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 08:15:23 -0500
Date: Fri, 8 Jan 2010 15:14:51 +0200
From: Jouni Malinen <j@w1.fi>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/4] cfg80211: fix 2 GHz subband calculation for
 country IEs
Message-ID: <20100108131451.GA18758@jm.kir.nu>
References: <1262903097-2129-1-git-send-email-lrodriguez@atheros.com>
 <1262903097-2129-3-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1262903097-2129-3-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 07, 2010 at 05:24:55PM -0500, Luis R. Rodriguez wrote:
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -555,7 +555,7 @@ static struct ieee80211_regdomain *country_ie_2_rd(
>  		/* 2 GHz */
>  		if (triplet->chans.first_channel <= 14)

By the way, that looks completely bogus.. Channel number cannot be used
to figure out whether this is 2.4 GHz or 5 GHz band (e.g., channel 8 is
used in both). This really should be based on the band the frame with
the Country IE was received.

>  			end_channel = triplet->chans.first_channel +
> -				triplet->chans.num_channels;
> +				triplet->chans.num_channels - 1;

Could be reasonable to verify that num_channels is not 0.. Based on a
quick look, I did not notice places where negative end_channel value
would trigger bad problems, but it would be safer to validate that the
received information is valid before using it.

-- 
Jouni Malinen                                            PGP id EFC895FA
