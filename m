Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37733 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238AbaDHJ5c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 05:57:32 -0400
Message-ID: <1396951051.5936.13.camel@jlt4.sipsolutions.net> (sfid-20140408_115737_996876_1F984A06)
Subject: Re: [PATCH v3 1/4] mac80211: fix CSA tx queue locking
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 08 Apr 2014 11:57:31 +0200
In-Reply-To: <1396259841-6359-2-git-send-email-michal.kazior@tieto.com> (sfid-20140331_120329_586540_255D568C)
References: <1395408675-26013-1-git-send-email-michal.kazior@tieto.com>
	 <1396259841-6359-1-git-send-email-michal.kazior@tieto.com>
	 <1396259841-6359-2-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140331_120329_586540_255D568C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-03-31 at 11:57 +0200, Michal Kazior wrote:
> It was possible for tx queues to be stuck locked
> if AP CSA finalization failed. In that case
> stop_ap nor do_stop woke the queues up. This means
> it was impossible to perform tx at all until
> driver was reloaded or a successful CSA was
> performed later.
> 
> It was possible to solve this in a simpler manner
> however this is more robust and future proof
> (having multi-vif CSA in mind).
> 
> New sdata->csa_block_tx is introduced to keep
> track of which interfaces requested tx to be
> blocked for CSA. This is required because mac80211
> locks all tx queues for that purpose. This means
> queues must be unlocked only when last tx-blocking
> CSA interface is finished.
> 
> It is still possible to have tx queues stopped
> after CSA failure but as soon as offending
> interfaces are stopped from userspace (stop_ap or
> ifdown) tx queues are woken up properly.

Looks fine, but I agree with Luca regarding locked -> stopped.

johannes

