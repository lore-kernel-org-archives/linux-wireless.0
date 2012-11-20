Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plout10-01.prod.sin2.secureserver.net ([182.50.145.4]:58410
	"HELO sg2plout10-01.prod.sin2.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751786Ab2KTBUs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 20:20:48 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20650.56024.392104.393540@gargle.gargle.HOWL> (sfid-20121120_022051_140469_253EB37F)
Date: Tue, 20 Nov 2012 06:50:24 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] mac80211: fix channel context suspend handling
In-Reply-To: <1353360586-32157-1-git-send-email-johannes@sipsolutions.net>
References: <1353360586-32157-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Sujith reported warnings with suspend/resume due to
> channel contexts. When I looked into it, I realised
> that the code was completely broken as it unassigned
> the channel contexts when suspending, which actually
> means they are destroyed.
> 
> Fix this by calling just the driver method (if it is
> implemented) instead of trying to use the mac80211
> channel context management code.
> 
> Reported-by: Sujith Manoharan <sujith@msujith.org>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Thanks. So there were three warnings which are fixed by:

mac80211: fix channel context warning on suspend
mac80211: fix channel context suspend handling
mac80211: check add_chanctx callback before use in ieee80211_reconfig

Sujith
