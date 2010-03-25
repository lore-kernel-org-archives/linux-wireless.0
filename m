Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753Ab0CYKtH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 06:49:07 -0400
Date: Thu, 25 Mar 2010 11:46:47 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 1/2] mac80211: add interface for disabling/enabling QoS
Message-ID: <20100325104646.GA2643@dhcp-lab-161.englab.brq.redhat.com>
References: <1269348417-4081-1-git-send-email-sgruszka@redhat.com> <1269364795.9689.2.camel@jlt3.sipsolutions.net> <20100324093742.GB7512@dhcp-lab-161.englab.brq.redhat.com> <1269447233.6935.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1269447233.6935.1.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 24, 2010 at 09:13:53AM -0700, Johannes Berg wrote:
> On Wed, 2010-03-24 at 10:37 +0100, Stanislaw Gruszka wrote:
> 
> > > Why "disabled" btw, and not enabled? Everything else is usually done in
> > > a positive sense here, I'd say.
> > 
> > To emphasize we disable QoS as conf_tx enable it implicitly.
> 
> Which I actually think should be changed in iwlwifi. No other driver
> cares, and this has always been a bit of a mess there (in iwlwifi).

Hmm, for example in mwl8k have mwl8k_cmd_set_wmm_mode(1)in conf_tx()
as well. I think this is hardware/firmware requirement.

> > In ideal case we want to change conf_tx to configure all queues
> > or disable qos. But since this is exported  to userspace additional 
> > disable_qos callback is the best implementation for me.
> 
> Yes, that would be ideal, but the second best thing, and one that we can
> do, would be to decouple configuring QoS and enabling/disabling QoS
> completely, not do a jumbled-up implementation like you're suggesting?

Since conf_tx enable QoS, and must do it, we need only interface to 
disable QoS. Decoupling just give us only more code, but since you
require that, I will do it. If this must be called at initialization
ieee80211_ops->config is better for that, I will use new
ieee80211_conf->flags.

Stanislaw  
