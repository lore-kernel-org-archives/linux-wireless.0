Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:48116 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750815Ab1J0OW6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Oct 2011 10:22:58 -0400
Date: Thu, 27 Oct 2011 17:22:48 +0300
From: Jouni Malinen <j@w1.fi>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: init rate-control for TDLS sta when supp-rates
 are known
Message-ID: <20111027142248.GA3972@jm.kir.nu> (sfid-20111027_162301_760247_DD73E4AA)
References: <1319636866-12171-1-git-send-email-arik@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1319636866-12171-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 26, 2011 at 03:47:46PM +0200, Arik Nemtsov wrote:
> Initialize rate control algorithms only when supported rates are known
> for a TDLS peer sta. Direct Tx between peers is not allowed before the
> link is enabled. In turn, this only occurs after a change_station()
> call that sets supported rates.

Thanks - this seems to fix the issues I saw previously. I tested ath9k
with this instead of my earlier patch and was able to run successfully
through my TDLS test scripts against another implementation.

-- 
Jouni Malinen                                            PGP id EFC895FA
