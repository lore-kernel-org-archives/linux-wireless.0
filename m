Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:8535 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbXJ2Cw3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 22:52:29 -0400
Subject: Re: [PATCH] iwlwifi: select proper rate control algorithm
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1193579616.5197.13.camel@johannes.berg>
References: <1193579616.5197.13.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 29 Oct 2007 10:40:02 +0800
Message-Id: <1193625602.3069.489.camel@debian.sh.intel.com> (sfid-20071029_025232_822602_ABCEFC3B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Sun, 2007-10-28 at 14:53 +0100, Johannes Berg wrote:
> Prior to this patch, iwlwifi would always use the first
> registered rate control algorithm which, depending on system
> setup, could be anything. After the mac80211 patch to make
> the simple algorithm built-in, it would always be simple.
> 
> This has always been a bug in iwlwifi.
> 
> This fixes it by requesting that mac80211 selects the right
> rate control algorithm.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> 
> ---
> Untested, and the iwlwifi base code that registers rate control
> algorithms is a *total* mess. They should only be registered once at
> module load rather than at hardware probe time! Hence, I have no idea
> whether this will suffice or if rate control algorithm initialisation
> has to be rewritten.
> 
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 ++
>  drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 ++
>  2 files changed, 4 insertions(+)
> 
> ---
> linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c  2007-10-28
> 14:31:02.845330022 +0100
> +++
> linux-2.6/drivers/net/wireless/iwlwifi/iwl3945-base.c       2007-10-28
> 14:31:54.255349989 +0100
> @@ -8317,6 +8317,8 @@ static int iwl_pci_probe(struct pci_dev 
>         }
>         SET_IEEE80211_DEV(hw, &pdev->dev);
>  
> +       hw->rate_control_algorithm = "iwl-3945-rs";
> +

Which mac80211.h has this field added? wireless-2.6 doesn't seem to have
this support yet.

Thanks,
-yi
