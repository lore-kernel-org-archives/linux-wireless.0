Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483Ab0IVOwp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 10:52:45 -0400
Date: Wed, 22 Sep 2010 16:51:55 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [PATCH wireless-2.6] iwlwifi: do not perferm force reset while
 doing scan
Message-ID: <20100922165155.21cb6321@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <1285166397.3684.64.camel@jlt3.sipsolutions.net>
References: <1284758657-25267-1-git-send-email-wey-yi.w.guy@intel.com>
	<20100922105722.3be42969@dhcp-lab-109.englab.brq.redhat.com>
	<1285166397.3684.64.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 22 Sep 2010 16:39:57 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

> On Wed, 2010-09-22 at 10:57 +0200, Stanislaw Gruszka wrote:
> 
> > So why we can see this warning? During my testing I saw it also.
> > There is race regarding SCAN_HW_SCANNING bit, usually we set/clear
> > this bit under local->mtx, but not in ieee80211_restart_hw()
> > 
> > cpu0						cpu1
> > __ieee80211_start_scan
> >   __set_bit(SCAN_HW_SCANNING, &local->scanning);
> >   
> > 						iwl_bg_restart()
> > 						  ieee80211_restart_hw()
> > 						    WARN
> 
> Why can't iwlwifi's bg_restart() force-abort the scan? It'll be aborted
> anyway...

Yes, bg_restart() force scan abort, but not if no scan is pending. It looks
like that:

cpu0						cpu1

						iwl_bg_restart()
						  __iwl_down()
						     iwl_scan_cancel_timeout
						     (do nothing since no pending scan)
			  
__ieee80211_start_scan
  __set_bit(SCAN_HW_SCANNING, &local->scanning);

						  ieee80211_restart_hw()
						    WARN
  
   drv_hw_scan
     iwl_mac_hw_scan
     (OK, fail new scan, return error)
   
   local->scanning = 0;





