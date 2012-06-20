Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53605 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852Ab2FTPkR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 11:40:17 -0400
Message-ID: <1340206817.4655.75.camel@jlt3.sipsolutions.net> (sfid-20120620_174034_668153_3F655888)
Subject: Re: [PATCH] mac80211: fix cleanup if driver suspend callback fails
From: Johannes Berg <johannes@sipsolutions.net>
To: Eyal Shapira <eyal@wizery.com>
Cc: linux-wireless@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
	Luciano Coelho <coelho@ti.com>
Date: Wed, 20 Jun 2012 17:40:17 +0200
In-Reply-To: <1340187014-11269-1-git-send-email-eyal@wizery.com> (sfid-20120620_121024_517016_9B4354DA)
References: <1340187014-11269-1-git-send-email-eyal@wizery.com>
	 (sfid-20120620_121024_517016_9B4354DA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-20 at 13:10 +0300, Eyal Shapira wrote:
> In case the driver suspend callback fails, mac80211 is left
> with stopped queues which prevents any further traffic as well
> as all STAs are left marked with WLAN_STA_BLOCK_BA which will
> cause any further ADDBA requests to be declined. Fix it by
> undoing both before returning from __iee80211_suspend.
> 
> Reported-by: Vitaly Wool <vitalywool@gmail.com>
> Signed-off-by: Eyal Shapira <eyal@wizery.com>
> ---
> 
> This was discussed in this thread:
> http://comments.gmane.org/gmane.linux.kernel.wireless.general/89571
> but no v2 was submitted. We've had this patch applied
> on our internal tree for a while so here it is.

Applied.

johannes

