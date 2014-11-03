Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:34551 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaKCEiA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Nov 2014 23:38:00 -0500
From: Sujith Manoharan <sujith@msujith.org>
Message-ID: <21591.1777.261577.885153@gargle.gargle.HOWL> (sfid-20141103_053934_129748_90AFBF4F)
Date: Mon, 3 Nov 2014 10:09:13 +0530
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: Re: [PATCH] ath9k: Cancel pending offchannel operations [and 1 more messages]
In-Reply-To: <1414825459-8974-1-git-send-email-sujith@msujith.org>,
	<1414825540-9064-1-git-send-email-sujith@msujith.org>
References: <1414825540-9064-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Can you please hold off on these patches ?
I'll repost them after some more testing.

Sujith

Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> In mgd_prepare_tx(), any pending HW scan is cancelled,
> but pending RoC operations are not cancelled. This
> results in a RoC request that never completes. For example,
> in a GO/STA setup, if p2p-find is initiated on an active GO
> interface wpa_s issues a RoC on the listen channel at the
> end of each scan run.
> 
> Enabling the station interface will force the station context
> and the earlier RoC is not cleared. Fix this by clearing all
> pending offchannel operations in mgd_prepare_tx().

Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> When a pending roc or scan operation is cancelled,
> the offchannel operation is cleared, but the offchannel
> state in the main scheduler is not cleared. This causes
> problems since an active GO will try to process a stale
> offchannel request that was deferred earlier. Fix this
> by clearing the state when there is no pending offchannel
> (roc/scan) operation.
