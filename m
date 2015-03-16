Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56106 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbbCPGev (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2015 02:34:51 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [4.0] ath9k: fix tracking of enabled AP beacons
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1426177038-24164-1-git-send-email-nbd@openwrt.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20150316063451.3E01D140988@smtp.codeaurora.org> (sfid-20150316_073455_364161_B84CAC67)
Date: Mon, 16 Mar 2015 06:34:51 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> sc->nbcnvifs tracks assigned beacon slots, not enabled beacons.
> Therefore, it cannot be used to decide if cur_conf->enable_beacon (bool)
> should be updated, or if beacons have been enabled already.
> With the current code (depending on the order of calls), beacons often
> do not get enabled in an AP+STA setup.
> To fix tracking of enabled beacons, convert cur_conf->enable_beacon to a
> bitmask of enabled beacon slots.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Thanks, applied to wireless-drivers.git.

Kalle Valo
