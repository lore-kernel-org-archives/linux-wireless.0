Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753741Ab0IVPYk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 11:24:40 -0400
Date: Wed, 22 Sep 2010 17:23:53 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [PATCH wireless-2.6] iwlwifi: do not perferm force reset while
 doing scan
Message-ID: <20100922172353.3e53d221@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <1285168257.3684.65.camel@jlt3.sipsolutions.net>
References: <1284758657-25267-1-git-send-email-wey-yi.w.guy@intel.com>
	<20100922105722.3be42969@dhcp-lab-109.englab.brq.redhat.com>
	<1285166397.3684.64.camel@jlt3.sipsolutions.net>
	<20100922165155.21cb6321@dhcp-lab-109.englab.brq.redhat.com>
	<1285168257.3684.65.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 22 Sep 2010 17:10:57 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

> On Wed, 2010-09-22 at 16:51 +0200, Stanislaw Gruszka wrote:
> 
> > Yes, bg_restart() force scan abort, but not if no scan is pending. It looks
> > like that:
> > 
> > cpu0						cpu1
> > 
> > 						iwl_bg_restart()
> > 						  __iwl_down()
> > 						     iwl_scan_cancel_timeout
> > 						     (do nothing since no pending scan)
> > 			  
> > __ieee80211_start_scan
> >   __set_bit(SCAN_HW_SCANNING, &local->scanning);
> 
> Ah, ok, makes sense. I think some mutex trickery could possibly help
> here though? But I'm not sure it's worth it...

I showed possible patch earlier in this thread, I will rethink about it and
eventually post. Perhaps applying the patch is good idea, since we will stop
seeing the warning it that harmless case, and be sure something is really
wrong when see it again.

Stanislaw
