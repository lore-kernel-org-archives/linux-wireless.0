Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:33088 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab3JHLwj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Oct 2013 07:52:39 -0400
Message-ID: <1381233152.13359.10.camel@jlt4.sipsolutions.net> (sfid-20131008_135244_518811_DBA23334)
Subject: Re: [PATCH] mac80211: port CCMP to cryptoapi's CCM driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	patches@linaro.org, linville@tuxdriver.com
Date: Tue, 08 Oct 2013 13:52:32 +0200
In-Reply-To: <1381231915-24232-1-git-send-email-ard.biesheuvel@linaro.org> (sfid-20131008_133333_304168_2D31449F)
References: <1381231915-24232-1-git-send-email-ard.biesheuvel@linaro.org>
	 (sfid-20131008_133333_304168_2D31449F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-10-08 at 13:31 +0200, Ard Biesheuvel wrote:

Hmm, thanks I guess. I'll need to review this in more detail, but I have
a question first:

> +	/* allocate the variable sized aead_request on the stack */
> +	int l = DIV_ROUND_UP(crypto_aead_reqsize(tfm),
> +			     sizeof(struct aead_request));
> +	struct aead_request req[1 + l];

This looks a bit odd, why round up first and then add one? Why even
bother using a struct array rather than some local struct like

struct {
  struct aead_request req;
  u8 data[crypto_aed_reqsize(tfm)];
} req_data;

or so?

johannes

