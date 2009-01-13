Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:35831 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbZAMViy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 16:38:54 -0500
Subject: Re: [PATCH v3 00/11] ath9k: add preliminary support for the AR913x
 SoCs
From: Pavel Roskin <proski@gnu.org>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Christoph Hellwig <hch@infradead.org>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1231854029-26810-1-git-send-email-juhosg@openwrt.org>
References: <1231854029-26810-1-git-send-email-juhosg@openwrt.org>
Content-Type: text/plain
Date: Tue, 13 Jan 2009 16:38:51 -0500
Message-Id: <1231882731.21706.10.camel@dv> (sfid-20090113_223859_372241_7D2B094A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-01-13 at 14:40 +0100, Gabor Juhos wrote:
> This patch set introduces preliminary support for the Atheros' AR9130/AR9132
> SoCs built-in WMAC device. Tested with compat-wireless-2009-01-12 and 2.6.27.10 
> kernel on the following devices:
>   * Atheros AP83-050 reference board (AR9132 SoC, AR9106 RF)
>   * TRENDnet TEW-632BRP router (AR9130 SoC, AR9102 RF)
>   * Mikrotik RB433 board (AR7161 SoC) + AR5416 based miniPCI card

I confirm that my AR5416 miniPCI is still working with this patch on top
of yesterdays wireless-testing (master-2009-01-12).

Unfortunately, patch named "ath9k: move PCI code into separate file"
doesn't apply to the today's wireless-testing and needs to be rebased.

Current checkpatch.pl gets confused by several patches because an
"#endif" in the unchanged part somehow causes the preprocessor stack to
underflow:

Can't use an undefined value as an ARRAY reference at
scripts/checkpatch.pl line 453.

This appears to be a bug in checkpatch.pl and should not be considered a
problem in the patches.

-- 
Regards,
Pavel Roskin
