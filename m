Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:34465 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab3JHTI7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Oct 2013 15:08:59 -0400
Message-ID: <1381259316.13359.17.camel@jlt4.sipsolutions.net> (sfid-20131008_210904_314516_ACE03E57)
Subject: Re: [PATCH] mac80211: port CCMP to cryptoapi's CCM driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	patches@linaro.org, linville@tuxdriver.com
Date: Tue, 08 Oct 2013 21:08:36 +0200
In-Reply-To: <1381231915-24232-1-git-send-email-ard.biesheuvel@linaro.org> (sfid-20131008_133333_304168_2D31449F)
References: <1381231915-24232-1-git-send-email-ard.biesheuvel@linaro.org>
	 (sfid-20131008_133333_304168_2D31449F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm not too familiar with the aead API, so here's another question:

> +	sg_init_one(&pt, data, data_len);
> +	sg_init_one(&assoc, &aad[2], be16_to_cpup((__be16 *)aad));
> +	sg_init_table(ct, 2);
> +	sg_set_buf(&ct[0], cdata, data_len);
> +	sg_set_buf(&ct[1], mic, IEEE80211_CCMP_MIC_LEN);

Is it guaranteed to be allowed that the input and output are the same
buffer? It seems we rely on that for encrypt_one(), but is it true here
as well?

(Btw - why pass in data/cdata as separate pointers into the function?)

> @@ -343,7 +337,7 @@ static void ccmp_special_blocks(struct sk_buff *skb, u8 *pn, u8 *scratch,
>  		data_len -= IEEE80211_CCMP_MIC_LEN;
>  
>  	/* First block, b_0 */
> -	b_0[0] = 0x59; /* flags: Adata: 1, M: 011, L: 001 */
> +	b_0[0] = 0x1; /* set L := 1, M and Adata flags are implied */

Hmm. I don't think I understand, can you explain this to me?

johannes

