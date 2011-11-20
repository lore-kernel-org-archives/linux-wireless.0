Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2971 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab1KTQOm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Nov 2011 11:14:42 -0500
Date: Sun, 20 Nov 2011 10:44:00 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, mcgrof@gmail.com, nbd@openwrt.org,
	jirislaby@gmail.com
Subject: Re: [PATCH 13/13] ath5k: Optimize ath5k_cw_validate
Message-ID: <20111120154359.GA4069@hash.lan> (sfid-20111120_171446_205493_41251B6E)
References: <1321775788-12520-1-git-send-email-mickflemm@gmail.com>
 <1321775788-12520-14-git-send-email-mickflemm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1321775788-12520-14-git-send-email-mickflemm@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 20, 2011 at 09:56:28AM +0200, Nick Kossifidis wrote:
> +	/* Check if cw_req + 1 a power of 2 */
> +	if (!((cw_req + 1) & cw_req))
> +		return cw_req;
> +
> +	/* Check if cw_req is a power of 2 */
> +	if (!(cw_req & (cw_req - 1)))
> +		return cw_req - 1;

There's is_power_of_two() in log2.h .. but this whole thing could also
be something like roundup_pow_of_two(cw) maybe?

-- 
Bob Copeland %% www.bobcopeland.com

