Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58956 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934417Ab1CYC7f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 22:59:35 -0400
Message-ID: <4D8C0512.5010608@openwrt.org>
Date: Fri, 25 Mar 2011 03:59:30 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith <m.sujith@gmail.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com, Jouni.Malinen@atheros.com
Subject: Re: [PATCH 1/3] ath9k: fix beacon timer handling issues
References: <1300827259-42910-1-git-send-email-nbd@openwrt.org> <19852.783.629604.122760@gargle.gargle.HOWL>
In-Reply-To: <19852.783.629604.122760@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-03-25 3:50 AM, Sujith wrote:
> Felix Fietkau wrote:
>> AP mode beacon timers in ath9k are configured in milliseconds, which breaks
>> when increasing ATH_BCBUF to 8 instead of 4 (due to rounding errors).
>> Since the hardware timers are actually configured in microseconds, it's
>> better to let the driver use that unit directly.
>> 
>> To be able to do that, the beacon interval parameter abuse for passing
>> certain flags needs to be removed. This is easy to do, because those flags
>> are completely unnecessary anyway. ATH9K_BEACON_ENA is ignored,
>> ATH9K_BEACON_RESET_TSF can be replaced with calling ath9k_hw_reset_tsf
>> from the driver directly.
> 
> I know this has been merged, but this changes the behaviour.
> 
> Earlier, the HW TSF would be reset _after_ the beacon timers have been
> configured, but now this isn't so. Wouldn't this alter the timers ?
The HW TSF reset was still issued before the code would activate the
timers (with the write to AR_TIMER_MODE), so I don't think this changes
the behaviour of the timers.
Since the timers are scheduled for absolute TSF32 values and (in case of
a reset being issued) always set to TU_TO_USEC(intval / ATH_BCBUF), that
leaves enough time for the timers to settle in after the TSF reset, so I
don't expect any race conditions there.

- Felix
