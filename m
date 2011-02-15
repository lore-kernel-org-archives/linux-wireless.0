Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34374 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206Ab1BOWTH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 17:19:07 -0500
Received: by fxm20 with SMTP id 20so697493fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Feb 2011 14:19:05 -0800 (PST)
Message-ID: <4D5AFBD5.4030309@lwfinger.net>
Date: Tue, 15 Feb 2011 16:19:01 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC/RFT] mac80211: make tx() operation return void
References: <1297778837.8664.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1297778837.8664.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/15/2011 08:07 AM, Johannes Berg wrote:
> From: Johannes Berg<johannes.berg@intel.com>
>
> The return value of the tx operation is commonly
> misused by drivers, leading to errors. All drivers
> will drop frames if they fail to TX the frame, and
> they must also properly manage the queues (if they
> didn't, mac80211 would already warn).
>
> Removing the ability for drivers to return a BUSY
> value also allows significant cleanups of the TX
> TX handling code in mac80211.
>
> NB: Also fixes a bug in ath9k_htc.
>
> Signed-off-by: Johannes Berg<johannes.berg@intel.com>
> ---
>   drivers/net/wireless/adm8211.c                |    4
>   drivers/net/wireless/at76c50x-usb.c           |    7 -
>   drivers/net/wireless/ath/ar9170/ar9170.h      |    2
>   drivers/net/wireless/ath/ar9170/main.c        |    5
>   drivers/net/wireless/ath/ath5k/base.c         |    5
>   drivers/net/wireless/ath/ath5k/mac80211-ops.c |   10 -
>   drivers/net/wireless/ath/ath9k/htc_drv_main.c |    7 -
>   drivers/net/wireless/ath/ath9k/main.c         |    6
>   drivers/net/wireless/ath/carl9170/carl9170.h  |    2
>   drivers/net/wireless/ath/carl9170/tx.c        |    5
>   drivers/net/wireless/b43/main.c               |    5
>   drivers/net/wireless/b43legacy/main.c         |    5
>   drivers/net/wireless/iwlwifi/iwl-agn.c        |    3
>   drivers/net/wireless/iwlwifi/iwl-agn.h        |    2
>   drivers/net/wireless/iwlwifi/iwl3945-base.c   |    3
>   drivers/net/wireless/libertas_tf/main.c       |    3
>   drivers/net/wireless/mac80211_hwsim.c         |    5
>   drivers/net/wireless/mwl8k.c                  |   15 --
>   drivers/net/wireless/p54/lmac.h               |    2
>   drivers/net/wireless/p54/main.c               |    2
>   drivers/net/wireless/p54/txrx.c               |   11 -
>   drivers/net/wireless/rt2x00/rt2x00.h          |    2
>   drivers/net/wireless/rt2x00/rt2x00mac.c       |    5
>   drivers/net/wireless/rtl818x/rtl8180/dev.c    |    8 -
>   drivers/net/wireless/rtl818x/rtl8187/dev.c    |    6
>   drivers/net/wireless/rtlwifi/core.c           |    5
>   drivers/net/wireless/wl1251/main.c            |    4
>   drivers/net/wireless/wl12xx/main.c            |    4
>   drivers/net/wireless/zd1211rw/zd_mac.c        |    5
>   include/net/mac80211.h                        |    2
>   net/mac80211/driver-ops.h                     |    4
>   net/mac80211/tx.c                             |  164 ++++++++------------------
>   32 files changed, 113 insertions(+), 205 deletions(-)

ACK for b43legacy, rtl8187, and rtlwifi.

Larry

