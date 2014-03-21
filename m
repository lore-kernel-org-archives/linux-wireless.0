Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46559 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbaCUORb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 10:17:31 -0400
Message-ID: <1395411440.4164.15.camel@jlt4.sipsolutions.net> (sfid-20140321_151734_897386_90DC3335)
Subject: Re: [PATCH] ath10k: dont call csa_finish more than once
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Date: Fri, 21 Mar 2014 15:17:20 +0100
In-Reply-To: <1395410520-26939-1-git-send-email-michal.kazior@tieto.com> (sfid-20140321_150948_706832_25F8B34B)
References: <1395410520-26939-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140321_150948_706832_25F8B34B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-03-21 at 15:02 +0100, Michal Kazior wrote:
> Driver is supposed to call it only once for each
> scheduled channel_switch_beacon().
> 
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
> This is required for multi-vif csa but since that
> isn't merged yet I'm not including any specifics
> in the commit log itself.
> 
> Preventing multiple ieee80211_csa_finish() calls
> sounds like a good idea in general to me.

Didn't we have this discussion on the hwsim patch before?

I'd argue that if all drivers must track this, then the mac80211 API is
defective.

johannes

