Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:38383 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966399AbaLLOQJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2014 09:16:09 -0500
Received: by mail-wg0-f41.google.com with SMTP id y19so9203407wgg.28
        for <linux-wireless@vger.kernel.org>; Fri, 12 Dec 2014 06:16:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1418387190.2470.28.camel@sipsolutions.net>
References: <1417429814-9618-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<1418387190.2470.28.camel@sipsolutions.net>
Date: Fri, 12 Dec 2014 15:16:07 +0100
Message-ID: <CAA2SeNJ6oiVRJmZS54Z6dSQDsEM10dCBqSGVmKe+QDaqLzgdWQ@mail.gmail.com> (sfid-20141212_151625_755183_367F05B0)
Subject: Re: [PATCHv2] mac80211: enable TPC through mac80211 stack
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	=?UTF-8?B?VGhvbWFzIEjDvGhu?= <thomas@net.t-labs.tu-berlin.de>,
	adrian@freebsd.org, haim.dreyfuss@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Mon, 2014-12-01 at 11:30 +0100, Lorenzo Bianconi wrote:
>> Enable/disable per packet Transmit Power Control (TPC) in lower drivers
>> according to TX power settings configured by the user. In particular TPC is
>> enabled if value passed in enum nl80211_tx_power_setting is
>> NL80211_TX_POWER_AUTOMATIC (no limit from userspace) or
>> NL80211_TX_POWER_LIMITED (allow using less than specified from userspace),
>> whereas TPC is disabled if nl80211_tx_power_setting is set to
>> NL80211_TX_POWER_FIXED (use value configured from userspace)
>>
>> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
>> ---
>>  include/net/mac80211.h     | 10 ++++++++++
>>  net/mac80211/cfg.c         |  6 +++++-
>>  net/mac80211/ieee80211_i.h |  1 +
>>  net/mac80211/iface.c       |  8 +++++++-
>>  net/mac80211/main.c        |  8 +++++++-
>>  5 files changed, 30 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
>> index cff3a26..7dd2432 100644
>> --- a/include/net/mac80211.h
>> +++ b/include/net/mac80211.h
>> @@ -376,6 +376,8 @@ enum ieee80211_rssi_event {
>>   * @ssid_len: Length of SSID given in @ssid.
>>   * @hidden_ssid: The SSID of the current vif is hidden. Only valid in AP-mode.
>>   * @txpower: TX power in dBm
>> + * @tpc_enabled: enable/disable per packet Transmit Power Control (TPC) for the
>> + *   current vif
>
> Why not put the enum nl80211_tx_power_setting value here?
>

ack

>>  struct ieee80211_conf {
>>       u32 flags;
>>       int power_level, dynamic_ps_timeout;
>> +     bool tpc_enabled;
>>       int max_sleep_period;
>
> Do you need it here at all?
>

In multi-vif scenario, TPC could be enabled just on given interfaces,
but driver TPC registers should be configured anyway (so I used a glob
flag). However I can move that logic in driver code, what do you
suggest?

>> +++ b/net/mac80211/ieee80211_i.h
>> @@ -869,6 +869,7 @@ struct ieee80211_sub_if_data {
>>
>>       int user_power_level; /* in dBm */
>>       int ap_power_level; /* in dBm */
>> +     enum nl80211_tx_power_setting tx_power_type;
>
> if you put this into bss_conf you can of course get rid of it here.
>

It sounds good to me. I can set nl80211_tx_power_setting value in
ieee80211_set_tx_power()

> johannes
>

Best regards,
Lorenzo


-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
