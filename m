Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39774 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483Ab0IVPLG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 11:11:06 -0400
Subject: Re: [PATCH wireless-2.6] iwlwifi: do not perferm force reset while
 doing scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <20100922165155.21cb6321@dhcp-lab-109.englab.brq.redhat.com>
References: <1284758657-25267-1-git-send-email-wey-yi.w.guy@intel.com>
	 <20100922105722.3be42969@dhcp-lab-109.englab.brq.redhat.com>
	 <1285166397.3684.64.camel@jlt3.sipsolutions.net>
	 <20100922165155.21cb6321@dhcp-lab-109.englab.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Sep 2010 17:10:57 +0200
Message-ID: <1285168257.3684.65.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-22 at 16:51 +0200, Stanislaw Gruszka wrote:

> Yes, bg_restart() force scan abort, but not if no scan is pending. It looks
> like that:
> 
> cpu0						cpu1
> 
> 						iwl_bg_restart()
> 						  __iwl_down()
> 						     iwl_scan_cancel_timeout
> 						     (do nothing since no pending scan)
> 			  
> __ieee80211_start_scan
>   __set_bit(SCAN_HW_SCANNING, &local->scanning);

Ah, ok, makes sense. I think some mutex trickery could possibly help
here though? But I'm not sure it's worth it...

johannes

