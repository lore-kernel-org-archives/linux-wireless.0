Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54095 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602Ab1DRL11 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 07:27:27 -0400
Message-ID: <4DAC2016.3000008@openwrt.org>
Date: Mon, 18 Apr 2011 13:27:18 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith <m.sujith@gmail.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com, jouni.malinen@atheros.com
Subject: Re: [PATCH 1/2] ath9k: fix powersave frame filtering/buffering in
 AP mode
References: <1303075690-53804-1-git-send-email-nbd@openwrt.org>	<19883.48525.986878.991570@gargle.gargle.HOWL>	<4DABFC54.8030502@openwrt.org> <19884.7222.186200.867910@gargle.gargle.HOWL>
In-Reply-To: <19884.7222.186200.867910@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-04-18 1:10 PM, Sujith wrote:
> Felix Fietkau wrote:
>>  The driver calls ieee80211_sta_set_tim on STA_NOTIFY_SLEEP whenever it
>>  still has some buffered frames that it intends to keep until the client
>>  wakes up again (i.e. frames that will not be returned to mac80211 as
>>  filtered).
>
> Why should ieee80211_sta_set_tim() be called from complete_aggr() ?
I should probably add an extra check that tests for tid->buf_q being 
empty - and some comments.
This handles a race condition that occurs if an A-MPDU completes (with 
some pending frames) after the station entered PS and 
ieee80211_sta_set_tim was not called because the buffer queue was empty.

- Felix
