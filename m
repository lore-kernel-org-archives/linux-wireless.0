Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785Ab0CSP77 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 11:59:59 -0400
Date: Fri, 19 Mar 2010 16:57:50 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: Re: [RFC PATCH 1/2] mac80211: add interface for disabling QoS
Message-ID: <20100319155749.GA4972@dhcp-lab-161.englab.brq.redhat.com>
References: <20100310152024.GB2969@dhcp-lab-161.englab.brq.redhat.com> <1268265597.4192.3.camel@jlt3.sipsolutions.net> <20100311095656.GB4682@dhcp-lab-161.englab.brq.redhat.com> <1268319960.4413.1.camel@jlt3.sipsolutions.net> <20100316145114.GA2496@dhcp-lab-161.englab.brq.redhat.com> <1268774282.4054.1.camel@jlt3.sipsolutions.net> <20100317092612.GB3726@dhcp-lab-161.englab.brq.redhat.com> <1268841106.5989.1.camel@jlt3.sipsolutions.net> <20100319105612.GA4915@dhcp-lab-161.englab.brq.redhat.com> <1269009449.11480.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1269009449.11480.1.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 19, 2010 at 07:37:29AM -0700, Johannes Berg wrote:
> On Fri, 2010-03-19 at 11:56 +0100, Stanislaw Gruszka wrote:
> > Add BSS_CHANGE_QOS_DISABLED flag to pass to drivers when want to disable
> > QoS (aka WMM, WME).
> 
> Umm? Take another look at how the change flags etc. work

You want it that way:
      changed |= BSS_CHANGED_QOS
      sdata->vif.bss_conf.qos_disabled = true;	
?

Stanislaw
