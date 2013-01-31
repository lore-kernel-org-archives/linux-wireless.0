Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:47744 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763Ab3AaN5n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 08:57:43 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Sven Eckelmann <sven@narfation.org>
Cc: linux-wireless@vger.kernel.org, mcgrof@qca.qualcomm.com,
	jouni@qca.qualcomm.com, vthiagar@qca.qualcomm.com,
	senthilb@qca.qualcomm.com, linville@tuxdriver.com,
	ath9k-devel@lists.ath9k.org, rodrigue@qca.qualcomm.com
Subject: Re: [PATCH 4/6] ath9k: Only spectral scan relay file when it was created
References: <1359624409-14815-1-git-send-email-sven@narfation.org>
	<1359624409-14815-4-git-send-email-sven@narfation.org>
Date: Thu, 31 Jan 2013 15:57:35 +0200
In-Reply-To: <1359624409-14815-4-git-send-email-sven@narfation.org> (Sven
	Eckelmann's message of "Thu, 31 Jan 2013 10:26:47 +0100")
Message-ID: <87vcadbgkw.fsf@purkki.adurom.net> (sfid-20130131_145747_200287_465AA0CB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sven Eckelmann <sven@narfation.org> writes:

> The relay file depends on relayfs. Trying to close this file without having
> ATH9K_DEBUGFS (and therefore RELAY) activated causes build failures.
>
> Signed-off-by: Sven Eckelmann <sven@narfation.org>

[...]

> +#ifdef CONFIG_ATH9K_DEBUGFS
>  	if (sc->rfs_chan_spec_scan) {
>  		relay_close(sc->rfs_chan_spec_scan);
>  		sc->rfs_chan_spec_scan = NULL;
>  	}
> +#endif

Instead of ugly #ifdef you could do something like this:

        if (config_enabled(CONFIG_ATH6KL_REGDOMAIN) &&

I think you could use that elsehwere in your patchset as well, but I
didn't check that carefully.

-- 
Kalle Valo
