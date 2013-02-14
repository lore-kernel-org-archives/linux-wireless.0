Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56301 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934663Ab3BNRga (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 12:36:30 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U62jV-0001SK-2g
	for linux-wireless@vger.kernel.org; Thu, 14 Feb 2013 18:36:29 +0100
Message-ID: <1360863386.8210.10.camel@jlt4.sipsolutions.net> (sfid-20130214_183633_290828_FFB5CD8F)
Subject: Re: [PATCH] mac80211: use spin_lock_bh() for TKIP lock
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 14 Feb 2013 18:36:26 +0100
In-Reply-To: <1360775047-16109-1-git-send-email-johannes@sipsolutions.net> (sfid-20130213_180417_797902_0DE6C5F2)
References: <1360775047-16109-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130213_180417_797902_0DE6C5F2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-13 at 18:04 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Since no driver calls the TKIP functions from interrupt
> context, there's no need to use spin_lock_irqsave().
> Just use spin_lock_bh() (and spin_lock() in the TX path
> where we're in a BH or they're already disabled.)

Applied.

johannes

