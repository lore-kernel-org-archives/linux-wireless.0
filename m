Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49284 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640Ab0IVOkO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 10:40:14 -0400
Subject: Re: [PATCH wireless-2.6] iwlwifi: do not perferm force reset while
 doing scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <20100922105722.3be42969@dhcp-lab-109.englab.brq.redhat.com>
References: <1284758657-25267-1-git-send-email-wey-yi.w.guy@intel.com>
	 <20100922105722.3be42969@dhcp-lab-109.englab.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Sep 2010 16:39:57 +0200
Message-ID: <1285166397.3684.64.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-22 at 10:57 +0200, Stanislaw Gruszka wrote:

> So why we can see this warning? During my testing I saw it also.
> There is race regarding SCAN_HW_SCANNING bit, usually we set/clear
> this bit under local->mtx, but not in ieee80211_restart_hw()
> 
> cpu0						cpu1
> __ieee80211_start_scan
>   __set_bit(SCAN_HW_SCANNING, &local->scanning);
>   
> 						iwl_bg_restart()
> 						  ieee80211_restart_hw()
> 						    WARN

Why can't iwlwifi's bg_restart() force-abort the scan? It'll be aborted
anyway...

johannes

