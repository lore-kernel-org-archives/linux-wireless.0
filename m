Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42640 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbbJ1TB5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 15:01:57 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2] mwifiex: toggle carrier state in start_ap/stop_ap.
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1445838841-20253-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Marty Faltesek <mfaltesek@google.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20151028190157.29F141415A7@smtp.codeaurora.org> (sfid-20151028_200201_067739_A8BDDD3F)
Date: Wed, 28 Oct 2015 19:01:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Marty Faltesek <mfaltesek@google.com>
> 
> In uap mode the carrier is not enabled until after the first STA joins.
> The carrier triggers the bridge to start its state machine, and if STP
> is enabled, it takes 4 seconds as it transitions from disabled to
> forwarding. During this time the bridge drops all traffic, and the EAPOL
> handshake times out after 3 seconds, preventing stations from joining.
> 
> Follow the logic used in mac80211 and start the carrier in start_ap
> and disable it in stop_ap. This has a nice benefit of allowing the
> first station connection time to be reduced by up to 75% when STP is
> in use.
> 
> Signed-off-by: Martin Faltesek <mfaltesek@google.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
