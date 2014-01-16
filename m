Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:36528 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824AbaAPPoJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 10:44:09 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH 1/5] ath: add common function ath_is_mybeacon
References: <1389802038-6688-1-git-send-email-linux@rempel-privat.de>
	<1389802038-6688-2-git-send-email-linux@rempel-privat.de>
Date: Thu, 16 Jan 2014 17:44:07 +0200
In-Reply-To: <1389802038-6688-2-git-send-email-linux@rempel-privat.de>
	(Oleksij Rempel's message of "Wed, 15 Jan 2014 17:07:14 +0100")
Message-ID: <87r488lyns.fsf@purkki.adurom.net> (sfid-20140116_164448_256710_0AA310F4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oleksij Rempel <linux@rempel-privat.de> writes:

> +bool ath_is_mybeacon(struct ath_common *common, struct ieee80211_hdr *hdr)

Would a static inline be better? At least on ath9k I suspect the
compiler automatically inlines the static function, after your patch
there's an extra function call.

-- 
Kalle Valo
