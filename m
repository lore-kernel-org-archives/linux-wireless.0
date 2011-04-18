Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52702 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab1DRLIR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 07:08:17 -0400
Received: by pvg12 with SMTP id 12so2111576pvg.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 04:08:17 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19884.7222.186200.867910@gargle.gargle.HOWL>
Date: Mon, 18 Apr 2011 16:40:46 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com, jouni.malinen@atheros.com
Subject: Re: [PATCH 1/2] ath9k: fix powersave frame filtering/buffering in AP mode
In-Reply-To: <4DABFC54.8030502@openwrt.org>
References: <1303075690-53804-1-git-send-email-nbd@openwrt.org>
	<19883.48525.986878.991570@gargle.gargle.HOWL>
	<4DABFC54.8030502@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> The driver calls ieee80211_sta_set_tim on STA_NOTIFY_SLEEP whenever it 
> still has some buffered frames that it intends to keep until the client 
> wakes up again (i.e. frames that will not be returned to mac80211 as 
> filtered).

Why should ieee80211_sta_set_tim() be called from complete_aggr() ?

Sujith
