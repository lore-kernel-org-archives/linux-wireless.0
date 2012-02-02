Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36781 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881Ab2BBDIq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 22:08:46 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20265.65072.546108.448327@gargle.gargle.HOWL> (sfid-20120202_040850_828694_A790FA80)
Date: Thu, 2 Feb 2012 08:38:32 +0530
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Paul Stewart <pstew@google.com>
Subject: [PATCH 1/2] ath9k: recover the chip from tx/rx stuck
In-Reply-To: <1328112335-19265-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1328112335-19265-1-git-send-email-rmanohar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan wrote:
> +void ath_start_rx_poll(struct ath_softc *sc, const u32 msec)
> +{
> +	if (!AR_SREV_9300_20_OR_LATER(sc->sc_ah))
> +		return;

I have not reviewed the patch, but to do such workarounds for an entire
family of chips is overkill. Has it been confirmed that the other
chips falling under this SREV check require this snafu ?

Sujith
