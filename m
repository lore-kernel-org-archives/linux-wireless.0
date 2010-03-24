Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754752Ab0CXJje (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 05:39:34 -0400
Date: Wed, 24 Mar 2010 10:37:42 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 1/2] mac80211: add interface for disabling/enabling QoS
Message-ID: <20100324093742.GB7512@dhcp-lab-161.englab.brq.redhat.com>
References: <1269348417-4081-1-git-send-email-sgruszka@redhat.com> <1269364795.9689.2.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1269364795.9689.2.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 23, 2010 at 10:19:55AM -0700, Johannes Berg wrote:
> On Tue, 2010-03-23 at 13:46 +0100, Stanislaw Gruszka wrote:
> 
> > + * @qos_disabled: whether QoS (aka WMM) should be disabled or not
> 
> Why "disabled" btw, and not enabled? Everything else is usually done in
> a positive sense here, I'd say.

To emphasize we disable QoS as conf_tx enable it implicitly.

> Also, the default would now be enabled, and I think this needs more work
> for AP mode. You're implementing generic API, don't fall into the trap
> of thinking it's only for iwlwifi's special case.

I did not think this is iwlwifi only case, but only for iwlwifi I have
bug reports as far.

> So at least there it
> should be enabled if the hw supports it and the change flag should be
> set at least once.

It must be enabled conf_tx is called anyway, so I do not think that is
needed. Ok, flag that device can handle bss_info_changed(BSS_CHANGEDS_QOS)
but that all is overcomplicated for me.

> Also, your code sends a weird signal to hw that doesn't support QoS, it
> actually enables qos for it ...

Not really. It's only used to disable QoS.

Well, my first patch which add new disable_qos callback, was like that.
If device do not have QoS, driver do not implement callback - wasn't
that simple and clean design?

In ideal case we want to change conf_tx to configure all queues
or disable qos. But since this is exported  to userspace additional 
disable_qos callback is the best implementation for me.

Stanislaw
