Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:55879 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbaBQC22 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Feb 2014 21:28:28 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21249.29605.11000.880663@gargle.gargle.HOWL> (sfid-20140217_032853_109569_681A207F)
Date: Mon, 17 Feb 2014 07:57:49 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH] ath9k: Fix ETSI compliance for AR9462 2.0
In-Reply-To: <52FE3791.8020104@openwrt.org>
References: <1392345920-28891-1-git-send-email-sujith@msujith.org>
	<52FE3791.8020104@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> Wouldn't it be better to do this for all AR93xx chipsets in
> ar9003_hw_apply_minccapwr_thresh instead of initvals?
> I'm pretty sure this patch will leave most other devices non-compliant.

The threshold values are adjusted for each chip and are not the same
for all chips in the AR9003 family, so this is done in the initvals.

ar9003_hw_apply_minccapwr_thresh() will be used only for chips which
contain the new 'MinCCApwr' field in struct ar9300_BaseExtension_1.
This is not present in almost all the AR9003-family chips. I believe it has
been introduced in AR955x.

Sujith
