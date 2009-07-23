Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:29577 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510AbZGWIqi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 04:46:38 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2009 01:46:39 -0700
Date: Thu, 23 Jul 2009 14:14:42 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Gabor Juhos <juhosg@openwrt.org>
CC: John Linville <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath9k: wake up the chip for PS config changes
Message-ID: <20090723084442.GB9186@vasanth-laptop>
References: <1248338052-10435-1-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1248338052-10435-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 23, 2009 at 02:04:11PM +0530, Gabor Juhos wrote:
> If we are in NETWORK_SLEEP state, calling of 'ath9k_hw_setrxabort' in
> 'ath9k_config' will fail with the following error:
> 
> ath9k: timeout (100000 us) on reg 0x806c: 0xdeadbeef & 0x01f00000 != 0x00000000
> ath9k: RX failed to go idle in 10 ms RXSM=0xdeadbeef
> 
> Fix it by waking up the chip, and set 'ps_restore_mode' directly instead
> of calling the 'ath9k_hw_setpower' routine..
> 
> The problem is reported by Luis:
> http://article.gmane.org/gmane.linux.kernel.wireless.general/34363
> 
> Changes-licensed-under: ISC
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> ---
>         if (changed & IEEE80211_CONF_CHANGE_PS) {
> +               ath9k_ps_wakeup(sc);

This seems to be a workaround. chip should not be sleeping when
mac80211 thinks it is awake.

Vasanth

