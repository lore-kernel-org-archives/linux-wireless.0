Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:33611 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574Ab2KXHqa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2012 02:46:30 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] iwlwifi: initialize rx_status
References: <1353710779-7142-1-git-send-email-johannes@sipsolutions.net>
Date: Sat, 24 Nov 2012 09:46:21 +0200
In-Reply-To: <1353710779-7142-1-git-send-email-johannes@sipsolutions.net>
	(Johannes Berg's message of "Fri, 23 Nov 2012 23:46:19 +0100")
Message-ID: <87ehjjwiia.fsf@purkki.adurom.net> (sfid-20121124_084634_984655_D4E7F316)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> From: Johannes Berg <johannes.berg@intel.com>
>
> The vendor radiotap patch added a few fields to
> struct ieee80211_rx_status that need to be zero,
> initialize the struct instead of using whatever
> was left on the stack.
>
> Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Just to confirm: latest wireless-testing was crashing for me during
boot. It was something iwlwifi related, but I didn't manage to see the
whole stack trace. Applying this patch on top of a1055e1 fixed the issue
for me.

Tested-by: Kalle Valo <kvalo@adurom.com>

-- 
Kalle Valo
