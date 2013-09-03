Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:48154 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab3ICGwj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 02:52:39 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21029.34383.979005.849228@gargle.gargle.HOWL> (sfid-20130903_085244_404159_79EAD53C)
Date: Tue, 3 Sep 2013 12:18:47 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/4] initvals: Remove duplicate mapping for AR9485 arrays
In-Reply-To: <522580E2.2090501@openwrt.org>
References: <1378184318-1169-1-git-send-email-sujith@msujith.org>
	<1378184318-1169-2-git-send-email-sujith@msujith.org>
	<522580E2.2090501@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> Why did you make this change? At least the mac_postamble is still
> identical, and with the other arrays you can just let the initvals tool
> detect if mappings are duplicate or not.

AR9485 is still maintained and it makes it a bit easier to update the
initvals. The gain value arrays differ from AR9462/AR9300, so only
mac_postamble can be reused - which is a small array and space savings
is marginal.

If PC-OEM card support is compiled out, we can have a bigger gain.
AR9485 1.1, AR9462 2.0, AR9462 2.1, AR9565 1.0/1.0.1 (AR9565 1.1 to come)
are not needed for AP platforms.

Sujith
