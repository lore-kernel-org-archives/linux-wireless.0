Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:24291 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbYGXV0a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 17:26:30 -0400
Subject: Re: [PATCH 2/12] ath5k: Restore saved initval after POST
From: Pavel Roskin <proski@gnu.org>
To: Nick Kossifidis <mick@madwifi.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com
In-Reply-To: <20080720033232.GB7440@makis>
References: <20080720033232.GB7440@makis>
Content-Type: text/plain
Date: Thu, 24 Jul 2008 17:26:28 -0400
Message-Id: <1216934788.3094.8.camel@dv> (sfid-20080724_232633_313143_16CB19E1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-07-20 at 06:32 +0300, Nick Kossifidis wrote:
> * Restore saved initial value after POST
...
> @@ -170,6 +172,10 @@ static int ath5k_hw_post(struct ath5k_hw *ah)
>  			var_pattern = 0x003b080f;
>  			ath5k_hw_reg_write(ah, var_pattern, cur_reg);
>  		}
> +
> +		/* Restore previous value */
> +		ath5k_hw_reg_write(ah, init_val, cur_reg);
> +
>  	}

Perhaps "at the end of POST"?  Anyway, the code looks good to me.

-- 
Regards,
Pavel Roskin
