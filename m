Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:55568 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab1CJJqz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 04:46:55 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 01:46:33 -0800
Date: Thu, 10 Mar 2011 15:16:29 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 4/4] ath9k: improve reliability of beacon transmission
	and stuck beacon handling
Message-ID: <20110310094629.GE28100@vasanth-laptop>
References: <1299717303-42430-1-git-send-email-nbd@openwrt.org> <1299717303-42430-2-git-send-email-nbd@openwrt.org> <1299717303-42430-3-git-send-email-nbd@openwrt.org> <1299717303-42430-4-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1299717303-42430-4-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 10, 2011 at 06:05:03AM +0530, Felix Fietkau wrote:
> ath9k calls ath9k_hw_stoptxdma every time it sends a beacon, however there
> is not much point in doing that if the previous beacon and mcast traffic
> went out properly. On AR9380, calling that function too often can result
> in an increase of stuck beacons due to differences in the handling of the
> queue enable/disable functionality.
> 
> With this patch, the queue will only be explicitly stopped if the previous
> data frames were not sent successfully. With the beacon code being the
> only remaining user of ath9k_hw_stoptxdma, this function can be simplified
> in order to remove the now pointless attempts at waiting for transmission
> completion, which would never happen at this point due to the different
> method of tx scheduling of the beacon queue.

Thanks. Can this patch be split into two, one which possibly fixes btsuck
(a stable fix) and the other one which is a cleanup?.

Vasanth
