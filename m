Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39618 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744Ab0IVPaB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 11:30:01 -0400
Subject: Re: [PATCH wireless-2.6] iwlwifi: do not perferm force reset while
 doing scan
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <20100922172353.3e53d221@dhcp-lab-109.englab.brq.redhat.com>
References: <1284758657-25267-1-git-send-email-wey-yi.w.guy@intel.com>
	 <20100922105722.3be42969@dhcp-lab-109.englab.brq.redhat.com>
	 <1285166397.3684.64.camel@jlt3.sipsolutions.net>
	 <20100922165155.21cb6321@dhcp-lab-109.englab.brq.redhat.com>
	 <1285168257.3684.65.camel@jlt3.sipsolutions.net>
	 <20100922172353.3e53d221@dhcp-lab-109.englab.brq.redhat.com>
Content-Type: text/plain
Date: Wed, 22 Sep 2010 08:29:02 -0700
Message-Id: <1285169342.13944.12.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-22 at 08:23 -0700, Stanislaw Gruszka wrote:
> On Wed, 22 Sep 2010 17:10:57 +0200
> Johannes Berg <johannes@sipsolutions.net> wrote:
> 
> > On Wed, 2010-09-22 at 16:51 +0200, Stanislaw Gruszka wrote:
> > 
> > > Yes, bg_restart() force scan abort, but not if no scan is pending. It looks
> > > like that:
> > > 
> > > cpu0						cpu1
> > > 
> > > 						iwl_bg_restart()
> > > 						  __iwl_down()
> > > 						     iwl_scan_cancel_timeout
> > > 						     (do nothing since no pending scan)
> > > 			  
> > > __ieee80211_start_scan
> > >   __set_bit(SCAN_HW_SCANNING, &local->scanning);
> > 
> > Ah, ok, makes sense. I think some mutex trickery could possibly help
> > here though? But I'm not sure it's worth it...
> 
> I showed possible patch earlier in this thread, I will rethink about it and
> eventually post. Perhaps applying the patch is good idea, since we will stop
> seeing the warning it that harmless case, and be sure something is really
> wrong when see it again.
> 

I will prefer not seeing "warning" even it is harmless in this case

Thanks
Wey

