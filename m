Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52702 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab0CWRWq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Mar 2010 13:22:46 -0400
Subject: Re: [PATCH 1/2] mac80211: add interface for disabling/enabling QoS
From: Johannes Berg <johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1269364795.9689.2.camel@jlt3.sipsolutions.net>
References: <1269348417-4081-1-git-send-email-sgruszka@redhat.com>
	 <1269364795.9689.2.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Mar 2010 10:22:50 -0700
Message-ID: <1269364970.9689.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-03-23 at 10:19 -0700, Johannes Berg wrote:
> On Tue, 2010-03-23 at 13:46 +0100, Stanislaw Gruszka wrote:
> 
> > + * @qos_disabled: whether QoS (aka WMM) should be disabled or not
> 
> Why "disabled" btw, and not enabled? Everything else is usually done in
> a positive sense here, I'd say.
> 
> Also, the default would now be enabled, and I think this needs more work
> for AP mode. You're implementing generic API, don't fall into the trap
> of thinking it's only for iwlwifi's special case. So at least there it
> should be enabled if the hw supports it and the change flag should be
> set at least once.
> 
> Also, your code sends a weird signal to hw that doesn't support QoS, it
> actually enables qos for it ...

Also, you probably should set the flag again and set qos_disabled = true
(or qos_enabled = false, which would imho be better) when
disassociating.

johannes

