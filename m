Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dmz4.indranet.co.nz ([203.97.93.68]:51738 "EHLO
	mail.indranet.co.nz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753770Ab0CACHb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2010 21:07:31 -0500
Date: Mon, 1 Mar 2010 15:02:16 +1300 (NZDT)
From: Derek Smithies <derek@indranet.co.nz>
To: Benoit Papillault <benoit.papillault@free.fr>
cc: jirislaby@gmail.com, mickflemm@gmail.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] [PATCH] ath5k: Fix 64 bits TSF reading.
In-Reply-To: <1267394932-11038-1-git-send-email-benoit.papillault@free.fr>
Message-ID: <alpine.DEB.2.00.1003011457470.20218@kauri.acheron.indranet.co.nz>
References: <4B8AE8F1.40006@free.fr> <1267394932-11038-1-git-send-email-benoit.papillault@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,
  No, canot support this.

What happens if there is an interrupt immediately after the first 
two reads - before the test on tsf_lower? - and thisinterrupt lasts longer 
than 100us ? Most often, this is ok - until the interrupt happens at the 
wrong time.

OR, there is a TSF merge event after the tsf_upper has been read, but 
before the tsf_lower has been read? The tsf merge (which is done by the 
hardware), adjusted both the high and low registers.

Derek.
On Sun, 28 Feb 2010, Benoit Papillault wrote:

> +
> +	tsf_upper = ath5k_hw_reg_read(ah, AR5K_TSF_U32);
> +	tsf_lower = ath5k_hw_reg_read(ah, AR5K_TSF_L32);
> +
> +	if (tsf_lower < 100)
> +		tsf_upper = ath5k_hw_reg_read(ah, AR5K_TSF_U32);
> +
> 	ATH5K_TRACE(ah->ah_sc);
>
> -	return ath5k_hw_reg_read(ah, AR5K_TSF_L32) | (tsf << 32);
> +	return (((u64)tsf_upper << 32) | tsf_lower);
> }
>
> /**
>

-- 
Derek Smithies Ph.D.
IndraNet Technologies Ltd.
ph +64 3 365 6485
Web: http://www.indranet-technologies.com/

"The only thing IE should be used for is to download Fire Fox"

"My favorite language is call STAR. It's extremely concise. It has
  exactly one verb '*', which does exactly what I want at the moment."
     --Larry Wall
