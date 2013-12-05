Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:49179 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab3LEKbn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 05:31:43 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21152.21739.555819.395470@gargle.gargle.HOWL> (sfid-20131205_113145_898425_48C1A5E9)
Date: Thu, 5 Dec 2013 15:56:51 +0530
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [RFT 1/2] ath: fix warning on usage of REGULATORY_CUSTOM_REG
In-Reply-To: <1386092034-13442-2-git-send-email-mcgrof@do-not-panic.com>
References: <1386092034-13442-1-git-send-email-mcgrof@do-not-panic.com>
	<1386092034-13442-2-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
>  	wiphy_apply_custom_regulatory(wiphy, regd);
> +	if (!ath_is_world_regd(reg))
> +		wiphy->regulatory_flags &= ~REGULATORY_STRICT_REG;

The warning is gone, but why is this cleared here ?

Sujith
