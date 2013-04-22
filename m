Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54383 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754807Ab3DVOxF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 10:53:05 -0400
Message-ID: <51754ED0.5080106@openwrt.org> (sfid-20130422_165311_436592_285B8162)
Date: Mon, 22 Apr 2013 16:53:04 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mac80211: add support for per-chain signal strength
 reporting
References: <1366640971-12872-1-git-send-email-nbd@openwrt.org>  <1366640971-12872-2-git-send-email-nbd@openwrt.org> <1366641428.8637.31.camel@jlt4.sipsolutions.net>
In-Reply-To: <1366641428.8637.31.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-04-22 4:37 PM, Johannes Berg wrote:
> On Mon, 2013-04-22 at 16:29 +0200, Felix Fietkau wrote:
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> ---
>>  include/net/mac80211.h  |  5 +++++
>>  net/mac80211/cfg.c      | 13 ++++++++++++-
>>  net/mac80211/rx.c       | 14 ++++++++++++++
>>  net/mac80211/sta_info.c |  2 ++
>>  net/mac80211/sta_info.h |  5 +++++
>>  5 files changed, 38 insertions(+), 1 deletion(-)
>> 
>> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
>> index 4ecff78..aeb4a5c 100644
>> --- a/include/net/mac80211.h
>> +++ b/include/net/mac80211.h
>> @@ -848,6 +848,9 @@ enum mac80211_rx_flags {
>>   * @signal: signal strength when receiving this frame, either in dBm, in dB or
>>   *	unspecified depending on the hardware capabilities flags
>>   *	@IEEE80211_HW_SIGNAL_*
>> + * @chains: bitmask of receive chains for which separate signal strength
>> + *	values were filled.
>> + * @chain_signal: per-chain signal strength, same format as @signal
> 
> Oops, sorry, I should've looked at this patch before ... This isn't
> right, @signal can be in "dB" or "unspec" units, but @chain_signal is
> required to be dBm. If you want, I'll edit the patch to just say that it
> must only be provided in dBm?
OK, sounds good.

- Felix

