Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18843 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab1KXGIT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 01:08:19 -0500
Message-ID: <4ECDDF25.6030900@qca.qualcomm.com> (sfid-20111124_070825_447116_D2828054)
Date: Thu, 24 Nov 2011 11:37:33 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>, Wilson Tsao <wtsao@qca.qualcomm.com>
Subject: Re: [PATCH 16/18] ath9k: make ath_reset non-static
References: <1321978965-21684-1-git-send-email-mohammed@qca.qualcomm.com> <1321978965-21684-17-git-send-email-mohammed@qca.qualcomm.com> <4ECD032F.4040009@openwrt.org> <4ECD0ECC.2060101@qca.qualcomm.com> <4ECD1224.3070900@openwrt.org>
In-Reply-To: <4ECD1224.3070900@openwrt.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 23 November 2011 09:02 PM, Felix Fietkau wrote:

> Doing reset from tasklet context created several nasty stability issues
> that were hard to track down, and the potential gain from doing reset
> 'immediately' that way is purely theoretical. Resets should be rare in
> normal operation, as they're also expensive.
> The main problem when running reset from a tasklet is that there is no
> way of gracefully shutting down ongoing workqueue activity, so the
> result of the reset could be that the work items mess up the state right
> after the reset is done.

thanks, true in this case ath_reset is called from tasklet context. i 
will send a v2 for using queue_work.

>
> - Felix


-- 
thanks,
shafi
