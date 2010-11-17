Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35669 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935069Ab0KQSvz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 13:51:55 -0500
Subject: Re: [PATCH] mac80211:  Fix deadlock in ieee80211_do_stop.
From: Johannes Berg <johannes@sipsolutions.net>
To: Tejun Heo <tj@kernel.org>
Cc: Ben Greear <greearb@candelatech.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4CE396A9.1050908@kernel.org>
References: <1289592426-5367-1-git-send-email-greearb@candelatech.com>
	 <1289594998.3736.11.camel@jlt3.sipsolutions.net>
	 <4CDDAA3B.9090007@candelatech.com>
	 <1289596096.3736.13.camel@jlt3.sipsolutions.net>
	 <4CDE699B.70401@kernel.org> <4CE1A344.7040201@candelatech.com>
	 <4CE292F7.4090200@kernel.org>
	 <1289929258.3673.1.camel@jlt3.sipsolutions.net>
	 <4CE396A9.1050908@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 10:53:25 -0800
Message-ID: <1290020005.3777.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-17 at 09:47 +0100, Tejun Heo wrote:

> WQ_NON_REENTRANT doesn't guarantee ordered execution but it guarantees
> that a single work is not executed concurrently on multiple CPUs.  I'm
> not sure whether this would be safe for the workqueue used by mac80211
> but it should let us know whether the workqueue is choked due to a
> work which is executing for long time.  In the long run, if using non
> reentrant is safe for mac80211, using it would be much better.

No, I don't think it's safe for mac80211.

johannes

