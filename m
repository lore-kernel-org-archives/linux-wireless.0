Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6768 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbaJ2FoG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 01:44:06 -0400
Date: Wed, 29 Oct 2014 11:16:05 +0530
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	"Michal Kazior" <michal.kazior@tieto.com>
Subject: Re: [PATCH] ath10k: add tracing for tx ieee80211 header
Message-ID: <20141029054604.GB20332@qca.qualcomm.com> (sfid-20141029_064419_889743_3E643C82)
References: <1414514885-3694-1-git-send-email-rmanohar@qti.qualcomm.com>
 <1414515579.1834.4.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1414515579.1834.4.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 28, 2014 at 05:59:39PM +0100, Johannes Berg wrote:
> On Tue, 2014-10-28 at 22:18 +0530, Rajkumar Manoharan wrote:
> > For packet log, the transmitted frame 802.11 header alone is sufficient.
> > Recording entire packet is also consuming lot of disk space. To
> > optimize, add tracepoints for sending tx-ed 802.11 headers alone.
> 
> FWIW, in iwlwifi I made the data portion (only!) a separate tracing
> subsystem, so that you can do
> 
> trace-cmd record -e iwlwifi
> 
> to get the hdrs, and
> 
> trace-cmd record -e iwlwifi -e iwlwifi_data
> 
> to get the hdrs, and the data, and then I put the two together in
> userspace. That way, "-e iwlwifi" gets most useful stuff, and adding -e
> iwlwifi_data when needed still has no duplication.
> 
> With what you're suggesting, it will be difficult to control tracing to
> do exactly what's needed.
> 
> Anyway, I don't really care, but this just caught my eye.
> 
Thanks for your feedback. Will send updated patch.

-Rajkumar
