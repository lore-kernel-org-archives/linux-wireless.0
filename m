Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60821 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147Ab0CXQNw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 12:13:52 -0400
Subject: Re: [PATCH 1/2] mac80211: add interface for disabling/enabling QoS
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20100324093742.GB7512@dhcp-lab-161.englab.brq.redhat.com>
References: <1269348417-4081-1-git-send-email-sgruszka@redhat.com>
	 <1269364795.9689.2.camel@jlt3.sipsolutions.net>
	 <20100324093742.GB7512@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 09:13:53 -0700
Message-ID: <1269447233.6935.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-03-24 at 10:37 +0100, Stanislaw Gruszka wrote:

> > Why "disabled" btw, and not enabled? Everything else is usually done in
> > a positive sense here, I'd say.
> 
> To emphasize we disable QoS as conf_tx enable it implicitly.

Which I actually think should be changed in iwlwifi. No other driver
cares, and this has always been a bit of a mess there (in iwlwifi).

> In ideal case we want to change conf_tx to configure all queues
> or disable qos. But since this is exported  to userspace additional 
> disable_qos callback is the best implementation for me.

Yes, that would be ideal, but the second best thing, and one that we can
do, would be to decouple configuring QoS and enabling/disabling QoS
completely, not do a jumbled-up implementation like you're suggesting?

johannes

