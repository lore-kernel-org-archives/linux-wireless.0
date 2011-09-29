Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34574 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992Ab1I2LcQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 07:32:16 -0400
Message-ID: <4E845733.1000203@openwrt.org> (sfid-20110929_133219_852759_EFB58AD8)
Date: Thu, 29 Sep 2011 13:32:03 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ath9k: Choose highest rate of MRR based on IEEE80211_TX_CTL_USE_MINRATE
References: <1317295446-20749-1-git-send-email-rmanohar@qca.qualcomm.com>
In-Reply-To: <1317295446-20749-1-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-09-29 1:24 PM, Rajkumar Manoharan wrote:
> Select appropriate rate as highest rate of rate series, if the frame
> was asked to be sent at minimum rate. For example nullfunc frames
> either can be sent at HT rates on normal case or at non-HT rates if
> it is used for connection monitoring.
>
> Signed-off-by: Rajkumar Manoharan<rmanohar@qca.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath9k/rc.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
Shouldn't the check for IEEE80211_TX_CTL_USE_MINRATE be in 
rate_control_send_low(), so that it does not have to be repeated in 
every single rate control module?

- Felix
