Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53959 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab0BQWaG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 17:30:06 -0500
Received: by vws11 with SMTP id 11so114359vws.19
        for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2010 14:30:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B7C561C.70702@free.fr>
References: <1266437114.23447.0.camel@jlt3.sipsolutions.net>
	<1266438137.23447.1.camel@jlt3.sipsolutions.net> <1266438446.23447.2.camel@jlt3.sipsolutions.net>
	<4B7C561C.70702@free.fr>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 17 Feb 2010 14:29:44 -0800
Message-ID: <43e72e891002171429j7f47c86bqd4374bf07b8979de@mail.gmail.com>
Subject: Re: [PATCH v3] mac80211: deprecate RX status noise
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 17, 2010 at 12:48 PM, Benoit PAPILLAULT
<benoit.papillault@free.fr> wrote:
> Johannes Berg a écrit :
>>
>> The noise value as is won't be used, isn't
>> filled by most drivers and doesn't really
>> make a whole lot of sense on a per packet
>> basis -- proper cfg80211 survey support in
>> mac80211 will need to be different.
>>
>> Mark the struct member as deprecated so it
>> will be removed from drivers.
>>
>> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>> ---
>> I shouldn't be trying this at 9:30pm...
>>
>>
>> Currently creates the following warnings:
>>
>> drivers/net/wireless/mwl8k.c:756: warning: ‘noise’ is deprecated
>> drivers/net/wireless/mwl8k.c:858: warning: ‘noise’ is deprecated
>> drivers/net/wireless/ath/ar9170/main.c:928: warning: ‘noise’ is deprecated
>> drivers/net/wireless/ath/ath9k/common.c:215: warning: ‘noise’ is
>> deprecated
>> drivers/net/wireless/ath/ath5k/base.c:1941: warning: ‘noise’ is deprecated
>> drivers/net/wireless/ath/ath5k/base.c:1942: warning: ‘noise’ is deprecated
>> drivers/net/wireless/b43/xmit.c:613: warning: ‘noise’ is deprecated
>> drivers/net/wireless/b43legacy/xmit.c:551: warning: ‘noise’ is deprecated
>> drivers/net/wireless/libertas_tf/main.c:497: warning: ‘noise’ is
>> deprecated
>> drivers/net/wireless/rt2x00/rt2x00dev.c:437: warning: ‘noise’ is
>> deprecated
>> drivers/net/wireless/p54/txrx.c:353: warning: ‘noise’ is deprecated
>> drivers/net/wireless/wl12xx/wl1251_rx.c:80: warning: ‘noise’ is deprecated
>> drivers/net/wireless/wl12xx/wl1271_rx.c:139: warning: ‘noise’ is
>> deprecated
>> drivers/net/wireless/iwlwifi/iwl-3945.c:682: warning: ‘noise’ is
>> deprecated
>> drivers/net/wireless/iwlwifi/iwl-3945.c:685: warning: ‘noise’ is
>> deprecated
>> drivers/net/wireless/iwlwifi/iwl-3945.c:689: warning: ‘noise’ is
>> deprecated
>> drivers/net/wireless/iwlwifi/iwl-3945.c:697: warning: ‘noise’ is
>> deprecated
>> drivers/net/wireless/iwlwifi/iwl-3945.c:711: warning: ‘noise’ is
>> deprecated
>> drivers/net/wireless/iwlwifi/iwl-rx.c:1191: warning: ‘noise’ is deprecated
>> drivers/net/wireless/iwlwifi/iwl-rx.c:1193: warning: ‘noise’ is deprecated
>> drivers/net/wireless/iwlwifi/iwl-rx.c:1206: warning: ‘noise’ is deprecated
>>
>> I'll make patches for drivers when it becomes
>> clear that it won't clash with any work others
>> have pending.
>>
>>  include/net/mac80211.h     |    4 ++--
>>  net/mac80211/debugfs_sta.c |    2 --
>>  net/mac80211/rx.c          |    9 ---------
>>  net/mac80211/sta_info.h    |    2 --
>>  4 files changed, 2 insertions(+), 15 deletions(-)
>>
>> --- wireless-testing.orig/include/net/mac80211.h        2010-02-17
>> 20:57:33.000000000 +0100
>> +++ wireless-testing/include/net/mac80211.h     2010-02-17
>> 21:25:46.000000000 +0100
>> @@ -543,7 +543,7 @@ enum mac80211_rx_flags {
>>  * @signal: signal strength when receiving this frame, either in dBm, in
>> dB or
>>  *     unspecified depending on the hardware capabilities flags
>>  *     @IEEE80211_HW_SIGNAL_*
>> - * @noise: noise when receiving this frame, in dBm.
>> + * @noise: noise when receiving this frame, in dBm (DEPRECATED).
>>  * @antenna: antenna used
>>  * @rate_idx: index of data rate into band's supported rates or MCS index
>> if
>>  *     HT rates are use (RX_FLAG_HT)
>> @@ -554,7 +554,7 @@ struct ieee80211_rx_status {
>>        enum ieee80211_band band;
>>        int freq;
>>        int signal;
>> -       int noise;
>> +       int noise __deprecated;
>>        int antenna;
>>        int rate_idx;
>>        int flag;
>> --- wireless-testing.orig/net/mac80211/debugfs_sta.c    2010-02-17
>> 21:20:49.000000000 +0100
>> +++ wireless-testing/net/mac80211/debugfs_sta.c 2010-02-17
>> 21:20:53.000000000 +0100
>> @@ -57,7 +57,6 @@ STA_FILE(tx_filtered, tx_filtered_count,
>>  STA_FILE(tx_retry_failed, tx_retry_failed, LU);
>>  STA_FILE(tx_retry_count, tx_retry_count, LU);
>>  STA_FILE(last_signal, last_signal, D);
>> -STA_FILE(last_noise, last_noise, D);
>>  STA_FILE(wep_weak_iv_count, wep_weak_iv_count, LU);
>>   static ssize_t sta_flags_read(struct file *file, char __user *userbuf,
>> @@ -289,7 +288,6 @@ void ieee80211_sta_debugfs_add(struct st
>>        DEBUGFS_ADD(tx_retry_failed);
>>        DEBUGFS_ADD(tx_retry_count);
>>        DEBUGFS_ADD(last_signal);
>> -       DEBUGFS_ADD(last_noise);
>>        DEBUGFS_ADD(wep_weak_iv_count);
>>        DEBUGFS_ADD(ht_capa);
>>  }
>> --- wireless-testing.orig/net/mac80211/rx.c     2010-02-17
>> 21:20:32.000000000 +0100
>> +++ wireless-testing/net/mac80211/rx.c  2010-02-17 21:26:31.000000000
>> +0100
>> @@ -179,14 +179,6 @@ ieee80211_add_rx_radiotap_header(struct
>>                pos++;
>>        }
>>  -       /* IEEE80211_RADIOTAP_DBM_ANTNOISE */
>> -       if (local->hw.flags & IEEE80211_HW_NOISE_DBM) {
>> -               *pos = status->noise;
>> -               rthdr->it_present |=
>> -                       cpu_to_le32(1 << IEEE80211_RADIOTAP_DBM_ANTNOISE);
>> -               pos++;
>> -       }
>> -
>>        /* IEEE80211_RADIOTAP_LOCK_QUALITY is missing */
>>          /* IEEE80211_RADIOTAP_ANTENNA */
>> @@ -1078,7 +1070,6 @@ ieee80211_rx_h_sta_process(struct ieee80
>>        sta->rx_fragments++;
>>        sta->rx_bytes += rx->skb->len;
>>        sta->last_signal = status->signal;
>> -       sta->last_noise = status->noise;
>>          /*
>>         * Change STA power saving mode only at the end of a frame
>> --- wireless-testing.orig/net/mac80211/sta_info.h       2010-02-17
>> 21:20:39.000000000 +0100
>> +++ wireless-testing/net/mac80211/sta_info.h    2010-02-17
>> 21:20:44.000000000 +0100
>> @@ -200,7 +200,6 @@ struct sta_ampdu_mlme {
>>  * @rx_fragments: number of received MPDUs
>>  * @rx_dropped: number of dropped MPDUs from this STA
>>  * @last_signal: signal of last received frame from this STA
>> - * @last_noise: noise of last received frame from this STA
>>  * @last_seq_ctrl: last received seq/frag number from this STA (per RX
>> queue)
>>  * @tx_filtered_count: number of frames the hardware filtered for this STA
>>  * @tx_retry_failed: number of frames that failed retry
>> @@ -271,7 +270,6 @@ struct sta_info {
>>        unsigned long rx_fragments;
>>        unsigned long rx_dropped;
>>        int last_signal;
>> -       int last_noise;
>>        __le16 last_seq_ctrl[NUM_RX_DATA_QUEUES];
>>          /* Updated from TX status path only, no locking requirements */
>>
>>
>
> I just wrote an application that read "last_signal" and "last_noise" in
> order to compute the SNR value of all neighboring nodes in
> /sys/kernel/debug/ieee80211/phy0/stations. So, it is used and needed.
>
> Being per packet or global, I'm not an RF engineer to say what's best, but
> even if it is global, "last_noise" would still be useful as "global noise
> when the last packets was received from this node".

If anything it should be per center freq.

  Luis
