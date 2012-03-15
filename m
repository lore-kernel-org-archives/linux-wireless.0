Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45052 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755610Ab2COIPI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 04:15:08 -0400
Message-ID: <4F61A506.9010309@openwrt.org> (sfid-20120315_091523_925651_CA9DFE0C)
Date: Thu, 15 Mar 2012 09:15:02 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	rodrigue@qca.qualcomm.com
Subject: Re: [PATCH 03/14] ath9k_hw: remove ath9k_hw_htc_resetinit
References: <1331739634-22318-1-git-send-email-nbd@openwrt.org> <1331739634-22318-2-git-send-email-nbd@openwrt.org> <1331739634-22318-3-git-send-email-nbd@openwrt.org> <20321.33695.439509.73251@gargle.gargle.HOWL>
In-Reply-To: <20321.33695.439509.73251@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-03-15 6:52 AM, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> Automatically set the ah->htc_reset_init on init and after PHY disable.
>> 
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> ---
>>  drivers/net/wireless/ath/ath9k/htc_drv_main.c |    1 -
>>  drivers/net/wireless/ath/ath9k/hw.c           |    8 ++------
>>  drivers/net/wireless/ath/ath9k/hw.h           |    3 ---
>>  3 files changed, 2 insertions(+), 10 deletions(-)
> 
> ath9k_htc still has remnants of the old radio enable/disable code when
> drivers were handling RFKILL events. And until that area is cleaned up,
> this should probably be kept - since PHY disable is done there too, and
> we are fiddling with RST/RF registers.
I did see the old radio enabled/disable code and my patch preserves the
existing behavior. ath9k_hw_phy_disable sets ah->htc_reset_init = true,
so the first reset called by ath9k_htc_start() will trigger the extra
reset just like before.

- Felix
