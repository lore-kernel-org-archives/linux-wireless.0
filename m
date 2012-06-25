Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:50644 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756365Ab2FYN1b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 09:27:31 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Eliad Peller <eliad@wizery.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: don't require associated->beacon_ies for ps
References: <1340610505-7713-1-git-send-email-eliad@wizery.com>
Date: Mon, 25 Jun 2012 16:27:29 +0300
In-Reply-To: <1340610505-7713-1-git-send-email-eliad@wizery.com> (Eliad
	Peller's message of "Mon, 25 Jun 2012 10:48:25 +0300")
Message-ID: <87395j4j3y.fsf@purkki.adurom.net> (sfid-20120625_152734_695297_A41D3045)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eliad Peller <eliad@wizery.com> writes:

> beacon_ies is needed only in order to extract the dtim
> period. However, even if it's missing we can still enter
> ps with dtim=1 (which also happens if the TIM ie is invalid).
>
> Most drivers don't use conf.max_sleep_period/ps_dtim_period
> anyway, and this check prevents them from entering ps if
> they don't have beacon (but only probe response), even though
> the beacon is not needed at all.

Does this increase the chances of accidentally using dtim 1 even though
AP has dtim > 1? I'm just worried that it's difficult to detect cases
when we are forcing dtim to 1 and nobody might not notice it. How often
will this happen?

Should we add a warning message for that case? Or few years ago we
talked about waiting for a beacon before enabling ps mode, should we
reconsider that? (Or maybe it's implemented already?)

-- 
Kalle Valo
