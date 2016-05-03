Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32970 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbcECG4e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2016 02:56:34 -0400
Message-ID: <1462258588.2251.1.camel@sipsolutions.net> (sfid-20160503_085642_034631_7411749C)
Subject: Re: [PATCH 2/2] mac80211_hwsim: Allow managing radios from
 non-initial namespaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Martin Willi <martin@strongswan.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Tue, 03 May 2016 08:56:28 +0200
In-Reply-To: <1462258398-6749-3-git-send-email-martin@strongswan.org>
References: <1462258398-6749-1-git-send-email-martin@strongswan.org>
	 <1462258398-6749-3-git-send-email-martin@strongswan.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-05-03 at 08:53 +0200, Martin Willi wrote:
> While wiphys can be moved into network namespaces over nl80211, the
> creation and removal of hwsim radios is currently limited to the
> initial namespace. This patch allows management of namespaced radios
> from the owning namespace by setting genetlink netnsok.

Interesting.

> To prevent two arbitrary namespaces from communicating over the
> simulated
> shared medium, radios are separated by netgroups. Each radio created
> in
> the same namespace lives in the same netgroup and hence can
> communicate
> with other radios in that group. When moving radios to other
> namespaces,
> the netgroup is preserved, so two radios having the same netgroup can
> communicate even if not in the same namespace; This allows a
> controlling
> namespace to create radios and move them to other namespaces for
> communication.

Neat.

I'm curious what the use case is?

I'll need some time to review it, it'll likely have to wait until next
week given our holiday here on Thursday (and I'm also off work
tomorrow/Friday)

johannes

