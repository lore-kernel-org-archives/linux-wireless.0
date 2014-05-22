Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44438 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbaEVNqF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 09:46:05 -0400
Message-ID: <1400766356.4174.14.camel@jlt4.sipsolutions.net> (sfid-20140522_154621_566191_E419B6FB)
Subject: Re: [PATCH 2/3] mac80211: use csa counter offsets instead of
 csa_active
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 22 May 2014 15:45:56 +0200
In-Reply-To: <1400765294-14732-3-git-send-email-michal.kazior@tieto.com> (sfid-20140522_153530_337542_BA3BCA73)
References: <1400765294-14732-1-git-send-email-michal.kazior@tieto.com>
	 <1400765294-14732-3-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140522_153530_337542_BA3BCA73)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-05-22 at 15:28 +0200, Michal Kazior wrote:
> vif->csa_active is protected by mutexes only. This
> means it is unreliable to depend on it on codeflow
> in non-sleepable beacon and CSA code. There was no
> guarantee to have vif->csa_active update be
> visible before beacons are updated on SMP systems.
> 
> Using csa counter offsets which are embedded in
> beacon struct (and thus are protected with single
> RCU assignment) is much safer.

This seems reasonable, but many uses of csa_active remain, no? hwsim for
example seems to access it without locking as well.

johannes

