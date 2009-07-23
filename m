Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:59876 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbZGWJfd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 05:35:33 -0400
Message-ID: <4A682EE3.9010407@openwrt.org>
Date: Thu, 23 Jul 2009 11:35:31 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
CC: John Linville <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath9k: wake up the chip for PS config changes
References: <1248338052-10435-1-git-send-email-juhosg@openwrt.org> <20090723084442.GB9186@vasanth-laptop>
In-Reply-To: <20090723084442.GB9186@vasanth-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan írta:
> On Thu, Jul 23, 2009 at 02:04:11PM +0530, Gabor Juhos wrote:
>> If we are in NETWORK_SLEEP state, calling of 'ath9k_hw_setrxabort' in
>> 'ath9k_config' will fail with the following error:
>>
>> ath9k: timeout (100000 us) on reg 0x806c: 0xdeadbeef & 0x01f00000 != 0x00000000
>> ath9k: RX failed to go idle in 10 ms RXSM=0xdeadbeef
>>
>> Fix it by waking up the chip, and set 'ps_restore_mode' directly instead
>> of calling the 'ath9k_hw_setpower' routine..
>>
>> The problem is reported by Luis:
>> http://article.gmane.org/gmane.linux.kernel.wireless.general/34363
>>
>> Changes-licensed-under: ISC
>> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
>> ---
>>         if (changed & IEEE80211_CONF_CHANGE_PS) {
>> +               ath9k_ps_wakeup(sc);
> 
> This seems to be a workaround. chip should not be sleeping when
> mac80211 thinks it is awake.

Hm, first I thought this is a bug in ath9k:

ath9k: AWAKE -> NETWORK SLEEP
ath9k: timeout (100000 us) on reg 0x806c: 0xdeadbeef & 0x01f00000 != 0x00000000
ath9k: RX failed to go idle in 10 ms RXSM=0xdeadbeef
ath9k: NETWORK SLEEP -> NETWORK SLEEP

You are righ probably, this can happen when mac80211 tells us to enter PS mode,
even if we are in it currently. Although I have no idea yet how this may happen.

Gabor

