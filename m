Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5252 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab2FORsD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 13:48:03 -0400
Date: Fri, 15 Jun 2012 23:19:17 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>, <c_manoha@qca.qualcomm.com>
Subject: Re: [PATCH 4/9] ath9k_hw: clean up / fix ANI mode checks related to
 beacon RSSI
Message-ID: <20120615174916.GB648@vmraj-lnx.qca.qualcomm.com> (sfid-20120615_194808_132635_50D437DE)
References: <1339766727-61926-1-git-send-email-nbd@openwrt.org>
 <1339766727-61926-2-git-send-email-nbd@openwrt.org>
 <1339766727-61926-3-git-send-email-nbd@openwrt.org>
 <1339766727-61926-4-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1339766727-61926-4-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 15, 2012 at 03:25:22PM +0200, Felix Fietkau wrote:
> Beacon RSSI is only meaningful in station mode - in ad-hoc mode it
> fluctuates, depending on which peer last sent a beacon, and in other
> modes it is not set at all.
> Fix places in ANI where the beacon RSSI is used to limit their use
> to station mode only.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath9k/ani.c |   12 +++++-------
>  1 files changed, 5 insertions(+), 7 deletions(-)
> 
If so, we should not update beacon rssi in process_rssi in IBSS
mode.

-Rajkumar
