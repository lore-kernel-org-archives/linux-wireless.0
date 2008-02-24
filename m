Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57567 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbYBXUQO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2008 15:16:14 -0500
Date: Sun, 24 Feb 2008 15:16:11 -0500
From: Christoph Hellwig <hch@infradead.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com
Subject: Re: [PATCH 6/8] ath5k: Fixes for PCI-E cards
Message-ID: <20080224201611.GA20715@infradead.org> (sfid-20080224_201620_596567_4A8BB537)
References: <20080224042851.GE4426@makis.domain.invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080224042851.GE4426@makis.domain.invalid>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 24, 2008 at 06:28:51AM +0200, Nick Kossifidis wrote:
> +	if((srev >= AR5K_SREV_VER_AR2424 && srev <= AR5K_SREV_VER_AR5424) ||
> +	srev >= AR5K_SREV_VER_AR5416) {
> +		ah->ah_pcie = true;
> +	} else {
> +		ah->ah_pcie = false;
> +	}

Sorry for beeing nitpicky. but the indentation/spacing bracing here
seems just too odd :)

This should be something like:

	if ((srev >= AR5K_SREV_VER_AR2424 && srev <= AR5K_SREV_VER_AR5424) ||
	    srev >= AR5K_SREV_VER_AR5416)
		ah->ah_pcie = true;
	else
		ah->ah_pcie = false;

or even better just leave the else clause out because ah has presumably
been zeroed before.

