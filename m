Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:59256 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaBQDIb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Feb 2014 22:08:31 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21249.32008.832500.383449@gargle.gargle.HOWL> (sfid-20140217_040849_957956_B1904367)
Date: Mon, 17 Feb 2014 08:37:52 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH] ath9k: Fix ETSI compliance for AR9462 2.0
In-Reply-To: <530177EF.3030000@openwrt.org>
References: <1392345920-28891-1-git-send-email-sujith@msujith.org>
	<52FE3791.8020104@openwrt.org>
	<21249.29605.11000.880663@gargle.gargle.HOWL>
	<530177EF.3030000@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> Almost all chips are using the same values in the initvals - the
> exceptions seem to be the ones that have had ETSI compliance fix
> attempts already. I'm pretty sure the new values (if adjusted for
> different bands) would be fully compatible.

For most of the chips, adjusting AR_PHY_CCA_MAX_GOOD_VAL_9300_2GHZ/5GHZ
from the previous values to -60 is sufficient and the initvals don't
need any changes to be compliant. For some chips, the change in the max. CCA
threshold require adjustments in the minCCApwr_thr field - it is easier to do this
via the initvals.

This has been done for AR9485, AR9462 and AR9565 so far.

AR9485: new value is -50 dB

AR9565: new value is -92 dB

AR9462:
chain 0 : 2G: -91dB, 5G: -88dB
chain 1 : 2G: -91dB, 5G: -90dB

The SoC chips do not have any corresponding changes in
minCCApwr_thr for the new CCA_MAX_GOOD_VAL. The only weird exception
is AR9331 which has new minCCApwr_thr values in the internal PCOEM driver,
but not in the SoC driver - not sure which one is correct.

Sujith
