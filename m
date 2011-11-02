Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:53685 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932431Ab1KBQXM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Nov 2011 12:23:12 -0400
Message-ID: <4EB16E6B.7080301@neratec.com> (sfid-20111102_172316_552775_0FA5CE01)
Date: Wed, 02 Nov 2011 17:23:07 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, linville@tuxdriver.com
Subject: Re: [PATCH] ath9k: preserve DFS flags in calcrxfilter
References: <1320235803-12190-1-git-send-email-zefir.kurtisi@neratec.com> <4EB14365.6000505@openwrt.org>
In-Reply-To: <4EB14365.6000505@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/02/2011 02:19 PM, Felix Fietkau wrote:
> On 2011-11-02 1:10 PM, Zefir Kurtisi wrote:
>> RX filter flags previously set for DFS radar detection were not
>> preserved after "ath9k: disable unnecessary PHY error reporting".
>>
>> This patch ensures that the flags required for DFS support are
>> kept set.
>>
>> Signed-off-by: Zefir Kurtisi<zefir.kurtisi@neratec.com>
> I think preserving the existing register values is a bit fragile wrt. hardware resets, register clobbering, etc.
> How about just adding an internal flag or bool in the softc?
> 
> - Felix

Hm, need to dig deeper.

Ideally, the DFS rx filter flags are set at reset along with the channel setup and remain untouched until the chip is stopped (and set-up again).

In fact, currently ath9k_hw_setrxfilter() is called only when the chip is stopped (clearing all flags in ath_stoprecv()) and from ath_opmode_init() and ieee80211_configure_filter() with the flags returned by ath_calcrxfilter().

Since ath_calcrxfilter() provides static initial filter settings for the current opmode, all rx filter flags set internally are reset each time ieee80211_configure_filter() is called.

With your proposal, we need to mirror each rx filter bit set in softc to be reset in ath_calcrxfilter(), right?.

My thinking is, if it is assured that the chip is always reset after a stop, we can ignore potential register clobbering and preserve those bits set in ath_calcrxfilter().


Thanks
Zefir
