Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:38552 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbbCZPOi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2015 11:14:38 -0400
Message-ID: <5514225D.5070409@candelatech.com> (sfid-20150326_161442_136564_08808914)
Date: Thu, 26 Mar 2015 08:14:37 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: replenish htc tx credits always
References: <1427368943-29526-1-git-send-email-michal.kazior@tieto.com>
In-Reply-To: <1427368943-29526-1-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/26/2015 04:22 AM, Michal Kazior wrote:
> There's always at most 2 credits and it makes
> little sense to set the
> ATH10K_HTC_FLAG_NEED_CREDIT_UPDATE flag
> conditionally.
> 
> This seems to fix some random issues with tx
> credit starvation on WLAN.RM.2.0-00073 I've been
> seeing. Note: this isn't related to wmi mgmt tx.

Good to see this in.

This will help when using CT firmware as well, since it makes
better use of tx-credits-update than stock 10.1.467 at least.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

