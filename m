Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56305 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752475AbcJROQi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Oct 2016 10:16:38 -0400
Message-ID: <1476800194.6425.35.camel@sipsolutions.net> (sfid-20161018_161642_416941_DE3E9E8D)
Subject: Re: [RFC PATCH 2/2] mac80211: aes_ccm: cache AEAD request
 structures per CPU
From: Johannes Berg <johannes@sipsolutions.net>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: herbert@gondor.apana.org.au, j@w1.fi, luto@amacapital.net
Date: Tue, 18 Oct 2016 16:16:34 +0200
In-Reply-To: <1476799713-16188-3-git-send-email-ard.biesheuvel@linaro.org> (sfid-20161018_160844_561124_0C52FCB9)
References: <1476799713-16188-1-git-send-email-ard.biesheuvel@linaro.org>
         <1476799713-16188-3-git-send-email-ard.biesheuvel@linaro.org>
         (sfid-20161018_160844_561124_0C52FCB9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-10-18 at 15:08 +0100, Ard Biesheuvel wrote:
> 
> +	aead_req = *this_cpu_ptr(ccmp->reqs);
> +	if (!aead_req) {
> +		aead_req = kzalloc(reqsize + CCM_AAD_LEN, GFP_ATOMIC);
> +		if (!aead_req)
> +			return -ENOMEM;
> +		*this_cpu_ptr(ccmp->reqs) = aead_req;
> +		aead_request_set_tfm(aead_req, ccmp->tfm);
> +	}

Hmm. Is it really worth having a per-CPU variable for each possible
key? You could have a large number of those (typically three when
you're a client on an AP, and 1 + 1 for each client when you're the
AP).

Would it be so bad to have to set the TFM every time (if that's even
possible), and just have a single per-CPU cache?

johannes
