Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43135 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122Ab3KFKvs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 05:51:48 -0500
Message-ID: <1383735101.14307.25.camel@jlt4.sipsolutions.net> (sfid-20131106_115151_733700_FBC66B23)
Subject: Re: [RFC v2 2/2] mac80211: only set CSA beacon when at least one
 beacon must be transmitted
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luciano.coelho@intel.com>
Cc: linux-wireless@vger.kernel.org, sw@simonwunderlich.de
Date: Wed, 06 Nov 2013 11:51:41 +0100
In-Reply-To: <1383684854-21663-2-git-send-email-luciano.coelho@intel.com>
References: <1383684854-21663-1-git-send-email-luciano.coelho@intel.com>
	 <1383684854-21663-2-git-send-email-luciano.coelho@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-11-05 at 22:54 +0200, Luciano Coelho wrote:
> With a CSA count of 0, we won't transmit any CSA beacons, because the
> switch will happen before the next TBTT.  To avoid extra work and
> potential confusion in the drivers, complete the CSA immediately,
> instead of waiting for the driver to call ieee80211_csa_finish().

Does it make sense to go to the workqueue rather than do it inline?

Maybe we should just reject this? I'm a bit worried that this might
confuse drivers that expect a certain order of calls?

johannes

