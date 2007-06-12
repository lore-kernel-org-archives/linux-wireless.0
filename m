Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:47182 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754364AbXFLMFq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2007 08:05:46 -0400
Date: Tue, 12 Jun 2007 14:05:45 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Daniel Drake <dsd@gentoo.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: regulatory domain cleanup
Message-ID: <20070612140545.6a469560@logostar.upir.cz>
In-Reply-To: <20070609180715.02BC17B409F@zog.reactivated.net>
References: <20070609180715.02BC17B409F@zog.reactivated.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat,  9 Jun 2007 19:07:14 +0100 (BST), Daniel Drake wrote:
> Currently, a function misnamed ieee80211_init_client() is used to handle
> regulatory domain control. It is called from
> ieee80211_register_hwmode(), which typically runs 2 or 3 times
> (802.11a/b/g), but each time it iterates over all the modes.
> 
> This patch cleans this up and removes the confusion:
> ieee80211_init_client was effectively renamed to
> ieee80211_set_default_regdomain and is now run on a per-mode basis
> (doesn't have to deal with netdevs). I also moved the regdomain handling
> code into its own file and added some documentation.
> 
> Signed-off-by: Daniel Drake <dsd@gentoo.org>

Acked-by: Jiri Benc <jbenc@suse.cz>

-- 
Jiri Benc
SUSE Labs
