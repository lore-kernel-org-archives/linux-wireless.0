Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17059 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab1ISOj0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 10:39:26 -0400
Date: Mon, 19 Sep 2011 20:10:03 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH 12/12] ath9k: do not insert padding into tx buffers on
 AR9380+
Message-ID: <20110919144002.GA22040@vmraj-lnx.users.atheros.com> (sfid-20110919_163932_984920_385332D8)
References: <1316028267-34187-3-git-send-email-nbd@openwrt.org>
 <1316028267-34187-4-git-send-email-nbd@openwrt.org>
 <1316028267-34187-5-git-send-email-nbd@openwrt.org>
 <1316028267-34187-6-git-send-email-nbd@openwrt.org>
 <1316028267-34187-7-git-send-email-nbd@openwrt.org>
 <1316028267-34187-8-git-send-email-nbd@openwrt.org>
 <1316028267-34187-9-git-send-email-nbd@openwrt.org>
 <1316028267-34187-10-git-send-email-nbd@openwrt.org>
 <1316028267-34187-11-git-send-email-nbd@openwrt.org>
 <1316028267-34187-12-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1316028267-34187-12-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 14, 2011 at 09:24:27PM +0200, Felix Fietkau wrote:
> With the new EDMA descriptor format, a single descriptor can contain up
> to four buffer pointers. By splitting the buffer into two parts, we can
> let the hardware add the padding internally instead of using memmove on
> the skb data.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath9k/xmit.c |   56 +++++++++++++++++++++-----------
>  1 files changed, 37 insertions(+), 19 deletions(-)
> 
Felix,

This patch again introduced "ath: Failed to stop TX DMA!" for AR9380+ chips.
After reverting this, the errors are completely gone away. Please look into this ASAP.

--
Rajkumar
