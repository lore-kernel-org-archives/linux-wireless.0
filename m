Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38455 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab3LBK7h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 05:59:37 -0500
Message-ID: <1385981972.4445.7.camel@jlt4.sipsolutions.net> (sfid-20131202_115942_549529_092727A4)
Subject: Re: [RFC] mac80211: fix rx_nss calculation for drivers with hw rc
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Date: Mon, 02 Dec 2013 11:59:32 +0100
In-Reply-To: <1385981647-4147-1-git-send-email-michal.kazior@tieto.com> (sfid-20131202_115744_274098_9362F537)
References: <1385739434.8656.0.camel@jlt4.sipsolutions.net>
	 <1385981647-4147-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20131202_115744_274098_9362F537)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-12-02 at 11:54 +0100, Michal Kazior wrote:
> Drivers with hardware rate control were given
> sta->rx_nss set to 0. This was because rx_nss
> calculation procedure was protected by hw/sw rate
> control check.
> 
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
> Hi Johannes,
> 
> I've re-checked the issue I've mentioned with the patch 'ath10k: use nss
> provided by mac80211'.
> 
> Apparently drivers with HW rate control are only affected by this bug
> and this patch is what I came up with as a quick fix. Any comments?

Yeah this looks reasonable. I guess I'll apply it despite the [RFC]

johannes

