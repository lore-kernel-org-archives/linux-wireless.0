Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40552 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbaKFKCb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 05:02:31 -0500
Message-ID: <1415268135.1884.1.camel@sipsolutions.net> (sfid-20141106_110356_792316_AAB049FA)
Subject: Re: [PATCH] mac80211: Fix regression that triggers a kernel BUG
 with CCMP
From: Johannes Berg <johannes@sipsolutions.net>
To: Ronald Wahl <ronald.wahl@raritan.com>
Cc: linux-wireless@vger.kernel.org,
	Christian Lamparter <chunkeey@googlemail.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Thu, 06 Nov 2014 11:02:15 +0100
In-Reply-To: <1415267752-4704-1-git-send-email-ronald.wahl@raritan.com>
References: <1415267752-4704-1-git-send-email-ronald.wahl@raritan.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-11-06 at 10:55 +0100, Ronald Wahl wrote:
> Commit 7ec7c4a9a686c608315739ab6a2b0527a240883c (mac80211: port CCMP to
> cryptoapi's CCM driver) introduced a regression when decrypting empty
> packets (data_len == 0). This will lead to backtraces like:

Not good.

> This patch adds an additional length check.
> 
> Signed-off-by: Ronald Wahl <ronald.wahl@raritan.com>

Please add

Cc: stable@vger.kernel.org
Fixes: 7ec7c4a9a686 ("mac80211: port CCMP to cryptoapi's CCM driver")

> +	if (data_len == 0)
> +		return EINVAL;

error codes should be negative. Or we could just return 0 to pretend it
was decrypted, after all, there was nothing to do? The packet is useless
though, so might as well drop it (and we would later anyway)

Oh, regarding Cc stable - don't actually send the mail there if you can
help it.

johannes

