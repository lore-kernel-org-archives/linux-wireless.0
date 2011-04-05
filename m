Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42053 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab1DEHHS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 03:07:18 -0400
Subject: Re: [RFC] cfg80211: Let mgmt_tx accept frames destined for its own
 stack.
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: Thomas Pedersen <thomas@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
In-Reply-To: <1301969218-9878-1-git-send-email-javier@cozybit.com>
References: <1301969218-9878-1-git-send-email-javier@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Apr 2011 09:07:14 +0200
Message-ID: <1301987234.3831.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-04-04 at 19:06 -0700, Javier Cardona wrote:
> This is useful for implementing frame protection in userspace. The kernel may
> request a userspace daemon to verify a frame (sent to userspace via
> cfg80211_rx_mgmt()).  The userspace daemon can then pass back the
> verified/unprotected frame to the stack for further processing (via a
> self-addressed frame sent with cfg80211_mlme_mgmt_tx())
> 
> We are using this for our implementation authenticated peering.  11s defines
> two versions of mesh peering, the non-secure mesh peering management (MPM) and
> the Authenticated Mesh Peering Exchange (AMPE).  The latter is based on the
> exact same state machine as MPM.  It is really convenient to use the in-kernel
> MPM with a minimal userspace daemon to add the security bits introduced by
> AMPE.  This way both secured and open mesh networks can use exact same peering
> code.
> 
> What do you think... will this fly?

Seems very strange to me. I guess if you're after unification in my mind
it makes more sense to declare the in-kernel state machine legacy, copy
it into the userspace tool and use it even for unprotected MPM?

johannes

