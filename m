Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51172 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751247AbdHGGco (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 02:32:44 -0400
Date: Mon, 7 Aug 2017 08:31:27 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Michael Skeffingfon <mike@astro.ai>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] rt2x00: Fix MMIC Countermeasures.
Message-ID: <20170807063127.GA2823@redhat.com> (sfid-20170807_083247_425525_7BB264A5)
References: <20170803153121.9046-1-mike@astro.ai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170803153121.9046-1-mike@astro.ai>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 03, 2017 at 11:31:21AM -0400, Michael Skeffingfon wrote:
> @@ -136,10 +136,19 @@ void rt2800mmio_fill_rxdone(struct queue_entry *entry,
>  		 */
>  		rxdesc->flags |= RX_FLAG_MMIC_STRIPPED;
>  
> -		if (rxdesc->cipher_status == RX_CRYPTO_SUCCESS)
> +		if (rxdesc->cipher_status == RX_CRYPTO_SUCCESS) {
>  			rxdesc->flags |= RX_FLAG_DECRYPTED;
> -		else if (rxdesc->cipher_status == RX_CRYPTO_FAIL_MIC)
> +        } else if (rxdesc->cipher_status == RX_CRYPTO_FAIL_MIC) {

Not sure why this happened, but here and on some other places below,
tab was replaced by spaces resulting in wrong indent.

Stanislaw
