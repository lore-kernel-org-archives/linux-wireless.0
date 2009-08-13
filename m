Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:57907 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279AbZHMH3m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 03:29:42 -0400
Date: Thu, 13 Aug 2009 09:28:16 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH 2.6.30] iwl3945: fix rfkill switch
Message-ID: <20090813072816.GA2373@dhcp-lab-161.englab.brq.redhat.com>
References: <1249389350-4158-1-git-send-email-sgruszka@redhat.com> <1249512709.30019.4902.camel@rc-desk> <20090806071902.GA9816@dhcp-lab-161.englab.brq.redhat.com> <1249589758.30019.5034.camel@rc-desk> <20090807063141.GA2523@dhcp-lab-161.englab.brq.redhat.com> <1249922692.30019.5610.camel@rc-desk> <20090811140908.GA3235@dhcp-lab-161.englab.brq.redhat.com> <1250014113.30019.5799.camel@rc-desk> <20090812151235.GA3912@dhcp-lab-161.englab.brq.redhat.com> <1250095502.30019.5951.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1250095502.30019.5951.camel@rc-desk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 12, 2009 at 09:45:02AM -0700, reinette chatre wrote:
> > > I also do not understand the need to modify rfkill's internal state.
> > 
> > It's needed for Case1. Additional change of internal rfkill state, which
> > I proposed in previous e-mail is against situation when we have:
> >  	STATUS_RF_KILL_HW = 1, STATUS_RF_KILL_SW = 0, RFKILL_STATE_SOFT_BLOCKED
> > To make it:
> >  	STATUS_RF_KILL_HW = 1, STATUS_RF_KILL_SW = 0, RFKILL_STATE_HARD_BLOCKED
> 
> ok - this makes sense now. In your previous email you also mentioned
> that that delta patch was untested. Is it possible for you or anybody
> else on that redhat bugzilla to give the new patch a try?
Yes, I'm going to rewrite patch, test and resend it. 
 
> I think I now understand what is going on. Having worked through all the
> possible scenarios makes me more comfortable about his patch considering
> the awkward way in which it is forced to solve the problem. I am really
> glad we do not need to do this moving forward.
I'm happy too.

Thanks
Stanislaw
